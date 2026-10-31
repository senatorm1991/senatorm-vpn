# senatorm vpn – Google Play Console answers (prepared draft)

> I (Claude) cannot log in to Play Console or submit these forms. Copy the answers below into the matching pages.
> Re-check each answer against the final build before you submit. Wrong declarations can get the app removed.

Package name: `com.senatorm.vpn` · Price: Free · Ads: none · Purpose: non-commercial, open source (fork of Hiddify, see README)

## 1. App access
All functionality is available without an account or login. No special instructions needed for reviewers.
Reviewer hint: "Open the app, tap + and paste any subscription/config link, then tap the power button to connect."

## 2. Ads
"No, my app does not contain ads."

## 3. Target audience and content
- Target age group: **18 and over** (a VPN client is not designed for children).
- Not appealing to children. Not a "Families" app.

## 4. Content rating (IARC questionnaire)
Category: **Utility / Productivity / Tools**. Answer **No** to: violence, blood, sexual content, nudity, profanity, drugs, gambling, user-generated content, user-to-user communication, sharing location, digital purchases, and unrestricted web content access *by the app itself* (the app is a network tunnel, it is not a browser). Expected rating: Everyone / 3+.

## 5. Data safety form
| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | **No** (the app has no developer-operated servers, analytics, ads or crash-reporting) |
| Is all of the user data collected by your app encrypted in transit? | Not applicable (no data collected). If asked about the tunnel: traffic is encrypted by the protocol the user selects (e.g. TLS/Reality, WireGuard, Hysteria2) |
| Do you provide a way for users to request data deletion? | Not applicable (no account, data stays on the device and is removed on uninstall) |
| Privacy policy URL | https://github.com/senatorm1991/senatorm-vpn/blob/main/PRIVACY.md |

Notes:
- Subscription/config links, settings and profiles are stored only on the device.
- The app makes ordinary network requests to: the proxy server the user chooses, the DNS/DoH provider the user chooses, the config sources the user adds, and GitHub (update check). None of these is operated by the developer.
- If you later add analytics (Sentry, Firebase, etc.) or a developer-run server, **update this form and PRIVACY.md first**.

## 6. VPN service declaration
"Does your app use the VpnService class?" → **Yes**.
Core functionality (paste):
> senatorm vpn is a VPN client whose core functionality is to create a device-level tunnel (Android VpnService) and route the user's traffic through proxy servers that the user imports or selects (VLESS, VMess, Trojan, Shadowsocks, Hysteria2, TUIC, WireGuard, etc.), with configurable DNS-over-HTTPS. The app does not collect or share personal or sensitive user data, does not redirect or manipulate traffic for advertising, and does not hijack or manipulate ads.
Encryption: Yes, traffic is encrypted between the device and the user's chosen server by the selected protocol.

## 7. Permission / sensitive-API declarations
| Permission | Declaration text |
|---|---|
| `BIND_VPN_SERVICE` (VpnService) | Core feature, see section 6 |
| `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_SPECIAL_USE` | Keeps the VPN tunnel alive while the user uses other apps. A foreground notification shows the connection state and a stop action. **Play asks for a short screen-recording video** of connecting and of the notification; please record one. |
| `POST_NOTIFICATIONS` | Shows the persistent connection notification |
| `CAMERA` | Optional: scan a QR code to import a config. Camera is not used otherwise |
| `RECEIVE_BOOT_COMPLETED` | Optional: reconnect after reboot if the user enables auto-start |
| `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` | Needed so Android does not kill the VPN tunnel in the background. **Google restricts this permission; the review may reject it.** If it is rejected, I can switch the app to open the system battery-settings screen instead (no permission needed) |
| `QUERY_ALL_PACKAGES` | **Removed** from this build; per-app VPN lists launchable apps through a `<queries>` entry |

## 8. Other App content forms
- Government apps: No · Financial features: No · Health: No · News: No · COVID-19: No · Data deletion: N/A

## 9. Store listing (English)
**Title (max 30):** senatorm vpn
**Short description (max 80):** Open-source VPN client with modern protocols and DoH support.
**Full description:**
> senatorm vpn is a free, open-source VPN and proxy client built on the sing-box core.
>
> • Modern protocols: VLESS (Reality), VMess, Trojan, Shadowsocks, Hysteria2, TUIC, WireGuard
> • Import configs and subscription links, scan QR codes
> • Connection and latency tests, automatic best-server selection
> • Custom DNS with DNS-over-HTTPS / DNS-over-TLS
> • Per-app VPN, clean black-and-white interface
> • No ads, no accounts, no analytics
>
> senatorm vpn does not provide servers. You bring your own configuration or subscription. It is a non-commercial fork of Hiddify (https://github.com/hiddify/hiddify-app); source code: https://github.com/senatorm1991/senatorm-vpn

## 10. Store listing (Persian)
**عنوان:** senatorm vpn
**توضیح کوتاه:** کلاینت متن‌باز VPN با پروتکل‌های مدرن و پشتیبانی از DoH
**توضیح کامل:**
> senatorm vpn یک کلاینت رایگان و متن‌باز VPN و پروکسی بر پایه‌ی هسته‌ی sing-box است.
>
> • پروتکل‌های مدرن: VLESS (Reality)، VMess، Trojan، Shadowsocks، Hysteria2، TUIC، WireGuard
> • افزودن کانفیگ و لینک اشتراک، اسکن QR
> • تست اتصال و تأخیر و انتخاب خودکار بهترین سرور
> • DNS سفارشی با DNS-over-HTTPS و DNS-over-TLS
> • VPN برای اپ‌های انتخابی، رابط ساده‌ی سیاه و سفید
> • بدون تبلیغات، بدون حساب کاربری، بدون ردیابی
>
> این برنامه سرور ارائه نمی‌دهد و کانفیگ را خودتان وارد می‌کنید. نسخه‌ای غیرتجاری از Hiddify است: https://github.com/hiddify/hiddify-app

## 11. Before you publish: checklist
1. Create a Play developer account (see the note below), then create the app with package `com.senatorm.vpn`.
2. Upload the **AAB** built by the `senatorm Android` workflow, signed with the upload key stored in repo secrets. Enable **Play App Signing**.
3. Fill sections 1–9 above, add a 512×512 icon (`android/app/src/main/ic_launcher-playstore.png`), a 1024×500 feature graphic and at least 2 phone screenshots.
4. Verify current testing requirements for new personal accounts (a closed test with a minimum number of testers for a minimum number of days was required before production).
5. Keep the app free and ad-free (license is non-commercial) and keep the source public.

Account note: Google Play developer registration and payments are not available in every country (e.g. sanctioned regions). Check Google's current list of supported locations before registering.
