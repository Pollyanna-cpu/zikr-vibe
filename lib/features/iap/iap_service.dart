import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../core/skin.dart';

/// IAP service for Zikr Vibe skin monetization.
///
/// Flow:
/// - Initialize on app start, listen to purchase stream
/// - User taps paid skin → purchase(skinId)
/// - Google Play handles payment + sandbox for closed testers
/// - On purchased: SkinNotifier.unlock(skinId) + auto-deliver
/// - Restore: queryPastPurchases() → unlock all owned
///
/// Product IDs match Google Play Console SKU (set by Yun in Console):
///   skin.pink_sand
///   skin.misty_rose
///   skin.mint_fog
///   skin.haze_lilac
///   skin.pearl_mist
///   skin.ruby_petals
///
/// Each priced $1.99 USD (matches priceUsd in skin.dart).
class IapService {
  IapService(this._ref);

  final Ref _ref;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  bool _available = false;

  static const Set<String> _kSkinSkus = {
    'skin.pink_sand',
    'skin.misty_rose',
    'skin.mint_fog',
    'skin.haze_lilac',
    'skin.pearl_mist',
    'skin.ruby_petals',
  };

  /// Map skin id ↔ Play Store SKU.
  static String skuFromSkinId(String skinId) => 'skin.$skinId';
  static String skinIdFromSku(String sku) => sku.replaceFirst('skin.', '');

  /// Call once on app start.
  Future<void> init() async {
    _available = await _iap.isAvailable();
    if (!_available) {
      debugPrint('[IAP] Store not available on this device');
      return;
    }
    // Listen for purchase updates (purchase / restore / error)
    _sub = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _sub?.cancel(),
      onError: (e) => debugPrint('[IAP] purchaseStream error: $e'),
    );
  }

  void dispose() {
    _sub?.cancel();
  }

  /// Trigger purchase for a paid skin.
  /// Returns true if purchase flow launched. The actual unlock happens async
  /// via [_onPurchaseUpdate] when Google Play confirms.
  Future<bool> buySkin(String skinId) async {
    if (!_available) return false;
    final sku = skuFromSkinId(skinId);

    final response = await _iap.queryProductDetails({sku});
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('[IAP] SKU not found: $sku — Yun must add in Play Console');
      return false;
    }
    if (response.productDetails.isEmpty) return false;

    final purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
    // Skins are non-consumable — buy once, own forever
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Re-fetch past purchases. Called on app start + Restore Purchases tap.
  ///
  /// Returns `true` if the store is reachable and the restore call was
  /// dispatched (results stream back through [_onPurchaseUpdate]). Returns
  /// `false` when the device has no IAP store available — e.g. an Android
  /// build without Google Play Services, or iOS Simulator with sandbox off.
  /// The UI surfaces this so testers don't tap "Restore Purchases" and see
  /// nothing happen.
  Future<bool> restorePurchases() async {
    if (!_available) return false;
    try {
      await _iap.restorePurchases();
      return true;
    } catch (e) {
      debugPrint('[IAP] restorePurchases threw: $e');
      return false;
    }
  }

  /// Whether an IAP store is reachable on this device.
  bool get isStoreAvailable => _available;

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final p in purchases) {
      if (p.status == PurchaseStatus.pending) {
        // User initiated checkout but Play Store hasn't confirmed yet.
        // Don't complete or error — wait for the next stream event.
        debugPrint('[IAP] Purchase pending: ${p.productID}');
        continue;
      }

      if (p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored) {
        final sku = p.productID;
        if (_kSkinSkus.contains(sku)) {
          final skinId = skinIdFromSku(sku);
          _ref.read(ownedSkinsProvider.notifier).unlock(skinId);
          debugPrint('[IAP] Unlocked skin: $skinId (status=${p.status})');
        }
      } else if (p.status == PurchaseStatus.error) {
        debugPrint('[IAP] Purchase error: ${p.error}');
      } else if (p.status == PurchaseStatus.canceled) {
        debugPrint('[IAP] Purchase canceled: ${p.productID}');
      }

      if (p.pendingCompletePurchase) {
        _iap.completePurchase(p);
      }
    }
  }
}

final iapServiceProvider = Provider<IapService>((ref) {
  final service = IapService(ref);
  ref.onDispose(service.dispose);
  return service;
});
