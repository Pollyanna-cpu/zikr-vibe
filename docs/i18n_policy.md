# Zikr Vibe / Nbidea Portfolio i18n Policy

**Effective**: 2026-04-24
**Owner**: Yun (CEO)
**Scope**: All Soul Vibe brand web properties + mobile apps

---

## Rule of Thumb

> **Portal sites speak to investors, tech press, and global readers — English only.**
> **End-user apps speak to the market they serve — localized per audience.**

---

## Site-by-site

| Property | URL | Audience | Language Rule |
|---|---|---|---|
| Nbidea portal | `nbidea.ai` / `www.nbidea.ai` | Global B2B, investors, press | **English only.** No Arabic, no Chinese in product copy. |
| Soul Alchemy | `soulvibeai.com` | Global paying users ($99) | **English only.** |
| Soulthread | `soulthread.nbidea.ai` | Global matchmaking users | **English only.** |
| Soul Vibe Band/Ring Shopify | `zikrvibe.com` (Shopify) | TBD — Yun decides per market | English + optional Arabic (Yun call) |
| **Zikr Vibe PWA** | `app.zikrvibe.com` | **Muslim end users** | **i18n en/ar** — system language switch allowed |
| Zikr Vibe iOS/Android app | Store builds | Muslim end users | **i18n en/ar** — system language switch allowed |
| FitCheck AI | `fitcheck.nbidea.ai` | Global fitness users | English only |

---

## Why the split

NBidea is the **mother hub** — it funnels global traffic to the specific products.
- Investors reading nbidea.ai should not see Arabic strings — that is a product-level detail, not a portfolio-level detail.
- End-users installing Zikr Vibe are **Muslim practitioners** who expect `مسجد`, `بتلات الياقوت`, `ماء الورد` as skin names and Arabic prayer strings. That localization is core to the Zikr Vibe product and stays in the app layer.

Split enforces clean audience layering:
- **Brand layer (portals)** — culturally neutral, English-only.
- **Product layer (apps)** — culturally specific, localized.

---

## Religious wording exception (Zikr Vibe only)

Zikr Vibe is an explicit exception to the "brand layer culturally neutral" rule in CLAUDE.md (see V1.9 宗教审 `#2`). Because Zikr Vibe's product definition **is** Muslim prayer technology, religious wording in:

- Zikr Vibe PWA (`app.zikrvibe.com`)
- Zikr Vibe native iOS/Android
- Zikr Vibe Ring Shopify (`zikrvibe.com`)

…is allowed and in fact required. Skin names like `Mosque`, `Rosewater`, `Pearl Mist` with Arabic counterparts (`مسجد`, `ماء الورد`, `ضباب اللؤلؤ`) stay.

Religious wording is **not** allowed on:
- `nbidea.ai` / `www.nbidea.ai` product cards, descriptions, hero copy
- `soulvibeai.com`
- `soulthread.nbidea.ai`
- `fitcheck.nbidea.ai`

---

## Enforcement in code

### NBidea portal (`~/Desktop/深圳苏尔韦-v1.0/灵韵戒指SoulVibeRing/landing/`)

- Every Zikr Vibe link / card / study entry carries `lang="en"` at the root element.
- No Arabic Unicode characters (U+0600 to U+06FF) anywhere in HTML / CSS / copy.
- No `nameAr` / `descAr` fields pulled from Zikr Vibe app data model.
- HTML comment above each Zikr Vibe reference: `<!-- NBidea portal policy (2026-04-24): English-only. Arabic/i18n only in app.zikrvibe.com PWA. -->`

### Zikr Vibe app (`~/Desktop/深圳苏尔韦-v1.0/zikr_vibe/`)

- `lib/l10n/` keeps `en` + `ar` ARB files.
- `lib/core/skin.dart` `ZikrSkin.nameAr` stays — used in-app only.
- System locale determines render — user choice persists in Hive `settings.locale`.

---

## Dusty Rose as Zikr Vibe brand accent

Default skin on the app is **Rosewater** (`#DB9A9F` Dusty Rose + champagne gold).
When NBidea portal references Zikr Vibe visually (product card background, og:image background, accent color), use `--dusty-rose: #DB9A9F`.
The old mosque green `#0A4D38` remains **only** as the `Mosque` skin inside the app — users can still select it, but it is no longer the brand's first-impression color.

---

## Audit checklist (run before any portal deploy)

1. `grep -rn "[\x{0600}-\x{06FF}]" landing/ --include='*.html'` → must return 0 lines
2. `grep -rn "0A4D38\|0a4d38\|mosque green" landing/` → must return 0 lines in portal pages
3. All Zikr Vibe anchors carry `lang="en"`
4. Shop card for Zikr Vibe Ring uses `f-dustyrose` plate class, not `f-ivory`

If any check fails, flag in INBOX under Unread before shipping.

---

*Canon: this file. Updated when policy changes. Never delete.*
