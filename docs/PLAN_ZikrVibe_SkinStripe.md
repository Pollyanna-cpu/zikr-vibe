# PLAN — Zikr Vibe Skin Stripe Monetization

**Status**: DEFERRED (not shipped 2026-04-24)
**Reason**: Stripe foundation not scaffolded in `zikr_vibe`. Shipping half-working payment flow would violate the Codex Contract §10 (smallest correct action — nothing half-done, especially payments).
**Owner**: Yun (CEO) + next Worker window
**Created**: 2026-04-24 by Worker-ZikrVibe-marketing-4fixes

---

## Context

- 6 Zikr Vibe app skins are currently `isFree: true` with `priceUsd: 1.99` (or `9.99` bundle). See `lib/core/skin.dart`.
- Skins flagged as paid but unlockable for free during App Store / Play Store review period.
- Once review passes (Apple approves, Google approves), all 6 must flip to `isFree: false` and require a real payment to unlock.
- Web PWA (`app.zikrvibe.com`) is the first surface to monetize — no Apple 30% tax, no Google Play Billing friction.

---

## Why Stripe Checkout on Web first (not native IAP)

| Option | Apple cut | Google cut | Complexity | Verdict |
|---|---|---|---|---|
| Stripe Checkout on web PWA | 0% (Apple policy) | 0% | Low | **Yes — ship here first** |
| Apple StoreKit IAP | 30% mandatory for digital unlocks | — | Medium | Required only for native iOS unlock |
| Google Play Billing | — | 30% (15% after $1M) | Medium | Required for native Android unlock |
| External payment in native app | Not allowed (App Store) | Allowed since 2024 | High | Risky — may trigger review rejection |

**Decision**: Web-first. Native apps only show "Upgrade on web" CTA → link-out to `app.zikrvibe.com/upgrade?skin=pearl_mist`.

Later, if native IAP is justified, add StoreKit + Play Billing as secondary rails. Do not block v1 on that.

---

## Stripe product catalog to create

All under Soul Vibe Technology Limited (HK) USD Stripe account — same one as Soul Alchemy.

| SKU | Name | Price | Type | Metadata |
|---|---|---|---|---|
| `skin_pearl_mist` | Pearl Mist skin | $1.99 one-time | Digital good | `product=zikr_vibe, skin_id=pearl_mist` |
| `skin_pink_sand` | Pink Sand skin | $1.99 one-time | Digital good | `product=zikr_vibe, skin_id=pink_sand` |
| `skin_misty_rose` | Misty Rose skin | $1.99 one-time | Digital good | `product=zikr_vibe, skin_id=misty_rose` |
| `skin_mint_fog` | Mint Fog skin | $1.99 one-time | Digital good | `product=zikr_vibe, skin_id=mint_fog` |
| `skin_haze_lilac` | Haze Lilac skin | $1.99 one-time | Digital good | `product=zikr_vibe, skin_id=haze_lilac` |
| `skin_ruby_petals` | Ruby Petals skin | $1.99 one-time | Digital good | `product=zikr_vibe, skin_id=ruby_petals` |
| `skins_all_bundle` | All skins bundle | $9.99 one-time | Digital good | `product=zikr_vibe, skin_id=all` |

---

## Architecture sketch

```
User in app
   │
   ▼
Paid skin tapped in skin_selector_screen.dart
   │
   ▼
Route to /upgrade?skin=pearl_mist (web) OR WebView on native
   │
   ▼
Supabase edge function `create-checkout-session`
   │  (auth user JWT → Stripe Checkout Session with skin_id in metadata)
   ▼
Stripe hosted Checkout
   │
   ▼  success
Supabase edge function `stripe-webhook`
   │  (verify signature, read metadata.skin_id, insert into owned_skins table)
   ▼
Client refetches owned skins → UI unlocks skin
```

Key primitives to build:

1. **Supabase table** `owned_skins (user_id uuid, skin_id text, purchased_at timestamptz, stripe_payment_intent_id text)`
2. **Edge function** `create-checkout-session` — accepts `{skin_id, return_url}` from auth'd user
3. **Edge function** `stripe-webhook` — verifies `Stripe-Signature`, handles `checkout.session.completed`
4. **Flutter route** `/upgrade` → shows skin preview + "Continue to payment" button
5. **Flutter skin state** — `SkinNotifier.isOwned` already reads `owned_skins` from local Hive; add Supabase sync on app start + after purchase redirect
6. **Deep link return** `app.zikrvibe.com/upgrade/success` → refresh owned skins + toast "Unlocked"

---

## Analytics events to wire (currently missing)

- `skin_preview_opened` — user opens paid skin preview
- `skin_unlock_intent` — user taps "Unlock $1.99" or "Unlock all $9.99"
- `stripe_checkout_start` — before redirecting to Stripe
- `stripe_checkout_success` — on return with successful session
- `stripe_checkout_cancelled` — on return with cancelled session
- `skin_applied` — user applies newly unlocked skin

All 6 events → Google Ads conversion action (once Yun opens Google Ads account).

---

## Effort estimate

| Task | Time |
|---|---|
| Stripe product + price creation (dashboard) | 30 min — Yun + Claude |
| Supabase `owned_skins` table + RLS policies | 30 min |
| `create-checkout-session` edge function | 1 h |
| `stripe-webhook` edge function + signature verify | 1.5 h |
| Flutter `/upgrade` screen | 2 h |
| `SkinNotifier` Supabase sync | 1 h |
| Deep link return handling | 1 h |
| Analytics events (6 events) | 1 h |
| End-to-end test (Stripe test mode) | 1 h |
| Go live + monitor first 10 transactions | 2 h |
| **Total** | **~11.5 h** |

---

## Dependencies / blockers

1. Yun confirms: which Stripe account — Soul Vibe HK USD (same as Soul Alchemy)? → Assumed yes.
2. `app.zikrvibe.com` routing must support `/upgrade` and `/upgrade/success` paths. Currently SPA — verify `go_router` handles deep link return.
3. Supabase project already exists (`zikr_vibe/supabase/` has migrations). Confirm env vars `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` exist in Supabase functions env.
4. Apple review policy check: if we ship web-first with native app link-out, confirm App Review won't flag as "steering".
   - As of 2024, the US Epic v. Apple ruling allows external payment links in US app versions. Outside US, 30% still applies.
   - Safe approach: in-app show "Upgrade on web" but do not include a clickable external payment link in the iOS build if that region disallows it.

---

## When to resume

Trigger conditions (any one):

1. Zikr Vibe app passes App Store + Play Store review and Yun wants to flip `isFree: false`.
2. Organic traffic to `app.zikrvibe.com` hits 500 WAU and Yun wants to monetize.
3. Yun explicitly says "build the skin stripe flow".

Until then, skins remain `isFree: true` and this plan stays cold in `docs/`.

---

*Saved to persist across sessions. Worker window resume with this file + the backlog.*
