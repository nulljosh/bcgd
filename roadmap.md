# Bcgd Roadmap


## Done 2026-08-18 — submit-ready
`asc validate` clean on **both** iOS 1.0 (`df882260-865d-4f33-9735-dc9f8137bcde`) and macOS 1.0
(`ef1421dd-4c4b-4592-a8be-a4fc0db4c149`): 0 errors, 0 warnings, 0 blocking.

Fixed today: both builds were missing the encryption declaration (`build.encryption.missing`, the
only blocking error on either row). Set `usesNonExemptEncryption=false` on builds
`e4da322e-12a0-4720-b914-6d9019f4a3af` (iOS) and `29b59afc-47fb-4a3a-8365-43b73dbcddb4` (macOS),
matching every sibling app in the fleet — HTTPS-only traffic is exempt.

Held for the four in-flight verdicts, not for any missing work.

- [ ] **Blocked on Joshua (dashboard only), do before the first submit.** BCGD carries a stray empty
  review submission `59cef0f7-188d-4ab8-bb6b-6c4c3f37239b` (IOS, READY_FOR_REVIEW, no submittedDate,
  zero items). `asc review submissions-cancel --confirm` refuses it: "Resource is not in cancellable
  state." Same defect Curvely has. Clear it in App Store Connect before submitting 1.0, or the real
  submission may collide with it.

## Submit attempt 2026-08-18 — now BLOCKED on App Privacy only (both platforms)

The Guideline 5.6 date freeze expired 2026-08-18 and BCGD was never one of the four
suspended apps, so it is clear to ship. Attempted iOS 1.0 submission
(`asc review submit --app 6791106082 --version 1.0 --platform IOS --build 798bbe86-b5f5-46e4-bb3d-633a74307236 --confirm`).
**It failed.** Three blockers were found; **two are now closed** (pricing, screenshots) and
**one remains: App Privacy, which needs Joshua.** Caution that still applies: `asc validate` on
iOS reported 0 errors / 0 warnings even while the submit call was failing on all three, so it
under-reports. Trust the real submit call, not validate. As of 2026-08-18 the only *known*
remaining blocker is App Privacy — but that has not been proven by a submit call, because no
third App Store submission should be queued until Curvely or Wiretext clears review.

- [ ] **App Privacy data usages not published** — `You must have published answers to your app's
      data usages`. Public API cannot do this. Needs `asc web privacy pull|plan|apply|publish --app 6791106082`,
      which needs a live `asc web auth login` (interactive 2FA — **Joshua only**). Web fallback:
      https://appstoreconnect.apple.com/apps/6791106082/appPrivacy
      The app is a fully local SwiftUI inventory/jobs tracker — `Store` persists to UserDefaults,
      no network calls, no accounts, no analytics — so the correct answer is **DATA_NOT_COLLECTED**.
- [ ] **More macOS screenshots (Inventory / Jobs / Settings) — only Dashboard shipped.** One shot
      satisfies Apple's minimum and unblocks submission, but the listing is thin. Blocked on the
      same thing as always: switching tabs needs a real click, and `TabView` here has no selection
      binding to persist, so there is no defaults-only way to land on another tab. Cheapest honest
      options if this matters: add a `@SceneStorage`/`selection` binding to the macOS `TabView`
      (then each tab is one defaults write + relaunch + capture), or accept a click-driven pass.
      Also worth knowing: the Dashboard shot is very whitespace-heavy at 1280x800 — the Mac layout
      genuinely looks like that, so richer screenshots probably want a design pass, not a capture
      trick.

Notes for whoever picks this up:
- iOS build `798bbe86-b5f5-46e4-bb3d-633a74307236` (build 1, uploaded 2026-07-15) is VALID,
  attached, encryption-exempt, and **expires 2026-10-13** — re-upload if that date passes.
- A stray empty review submission `59cef0f7-188d-4ab8-bb6b-6c4c3f37239b` (READY_FOR_REVIEW,
  0 items) now exists from the failed attempt. Harmless — `asc review submit` reuses it. Same
  litter pattern as Curvely's stray. Verify items with `asc review items list --submission ID`;
  `asc review submissions-list` misreports the Items count as 0.
- Not acted on: the iOS app uses `bcgdTeal` (#1B5959) as its tint, which conflicts with the
  standing "no teal" colour rule. It is the client's brand colour, so this is Joshua's call,
  not a lint fix.
- Not acted on: `src/ios/project.yml` has `MARKETING_VERSION: 0.1.0` while the ASC version is
  1.0, so the app's own Settings screen reports 0.1.0. Harmless to reviewers (they see the ASC
  version), but it kept the Settings tab out of the screenshot set. `src/macos/project.yml` is
  already correct at "1.0". Fixing means a yml bump + rebuild + re-upload of the iOS binary,
  which would replace the currently VALID attached build — deliberately not done mid-submission.
- Superseded: `src/ios/screenshots/*.png` (dashboard/inventory/jobs/settings, 1206x2622) are
  iPhone 6.3" captures, not an Apple 6.5" size. They are already uploaded to ASC under a
  different display type and were left alone; the 6.5" set is the new
  `src/ios/screenshots/appstore/` tree.

## ASC state VERIFIED 2026-08-12 (`asc versions list`)

**The ASC record exists** — app id `6791106082`, iOS 1.0 and macOS 1.0 both
`PREPARE_FOR_SUBMISSION`. Notes elsewhere saying "no ASC registration yet" are wrong.
Nothing is submitted, so nothing is rejected; this is the cleanest app in the fleet.

Freeze lifted 2026-08-18 (Guideline 5.6 suspension expired). Submitted that day and now
WAITING_FOR_REVIEW: Curvely iOS 1.2.0, Wiretext iOS 1.1.0, Wordroot iOS 1.0, Healstack iOS 2.3.4.
**Held pending those four verdicts — never a batch:** Sparkjar iOS+Mac, BCGD iOS+Mac, Wordroot Mac,
Lexly Mac. All six are `asc validate` clean (0 errors, 0 blocking) with a VALID build attached, so
each is one `asc review submit` away. Do not submit until the in-flight verdicts land.

## Done 2026-08-02
Merge doc comparison complete — verified bcgd.heyitsmejosh.com against bcgaragedoors.ca and found all major recommendations already shipped (hero booking form, pricing, stats bar, founder photo/bio, service pages for springs/cable/rollers/keypads/clickers/panels/weather-strips/hinge/maintenance). Only gap: track repair page. Added service entry to web/data/services.json, regenerated all pages via `node build.js`, deployed to Cloudflare Pages, and pushed. Commit e9f5c1c.

## Done 2026-07-27
Site/dashboard comparison against bcgaragedoors.ca, then the fixes:
- Booking form was discarding every lead (`alert()` + reset). Now inserts into
  `bcgd_leads` on the shared spark Supabase project; dashboard imports them as
  Lead jobs. Verified end to end via the REST API (anon insert 201, anon select
  denied, authed select returns the row).
- 11 service pages + 12 service-area pages + sitemap generated by
  `web/build.js`; JSON-LD, OG meta, robots.txt, real 404. Site previously had
  zero indexable URLs.
- Dashboard: Supabase auth replaced the 4-digit PIN gate, Today view, jobs
  carry a parts list deducted on Complete. Deleted orphaned `Dashboard.jsx`
  (was never imported -- dead code).
- **Deploy target was wrong in CLAUDE.md**: both sites are Cloudflare Pages,
  not Vercel. Corrected.

### Open follow-ups
> Session 2026-08-13 stopped here — usage limit near cap (`weekly_all 88% WARNING`).
> Everything still open below is untouched.

- [ ] Dashboard React wiring (sign-in -> lead import -> Today render) is only
      verified by build + headless render of the gate, not a full browser run.
      A CDP script was written at scratchpad `e2e.mjs` but not executed (usage
      cap). Re-run or click through once manually.
- [ ] Shop login is `shop@bcgaragedoors.ca`; password was generated and shown
      in chat 2026-07-27 -- change it via Settings > Security.
- [ ] Parts/jobs still localStorage; only leads are server-side. Migrate when
      the iOS app needs the same stock.
- [ ] Reorder is still per-part mailto; grouping by supplier with an
      ordered/received state was planned but not built.

## Source-site gap audit 2026-08-03
Rendered bcgaragedoors.ca live in Chrome (static curl is bot-protected/JS-rendered, confirmed dead end). Compared against `src/web/` (12 service pages + 12 service-area pages, already matches the source's city list 1:1 — Langley, Surrey, Vancouver, Burnaby, Coquitlam, New Westminster, Maple Ridge, Richmond, Delta, Abbotsford, North/West Vancouver). Homepage messaging (family-owned/repair-focused/no-pressure, LiftMaster-compatible parts) already carried over per the 2026-08-02 merge. Remaining real gaps, not yet ported:
- [ ] "Our Seamless Service Process" 5-step section (Thorough System Inspection → Clear Explanation and Service Plan → Precision Service Completion → Safety Testing and Performance Check → Final Review and Clean Completion) — bcgd's process copy is thinner than this on the homepage.
- [ ] "Practical Benefits" section (Reduced Repeat Issues, Improved Safety and Stability, Smoother and Quieter Operation, Less Strain on Mechanical Components, Clear Expectations and Professional Service) — not present on bcgd homepage.
- [ ] Source splits Cable/Roller service into separate Repair vs. Replacement pages (and has a standalone Torsion Spring Repair page); bcgd combines these into single `garage-door-cable`/`garage-door-rollers`/`garage-door-springs` pages — a deliberate simplification, not a bug, but flag if 1:1 replication is still the goal.
- [ ] Source FAQ has 10 specific Q&As (appointment duration, coverage area, emergency availability, booking method, pricing factors, maintenance frequency, spring/cable handling, panel repair, DIY-vs-pro) — bcgd has an FAQ section but content wasn't diffed line-by-line this pass; worth a follow-up check against bcgd's actual FAQ copy.

## App Privacy PUBLISHED — 2026-08-18

Closed with a live 2FA web session (Joshua supplied the code). The declaration existed locally but
had never been applied remotely, so `asc web privacy publish` returned
`409 STATE_ERROR.APP_DATA_USAGES_REQUIRED`. Correct sequence is **apply, then publish** — a bare
publish on an app that has no remote data-usage tuples always 409s:

```
asc web privacy plan   --app 6791106082 --file privacy.json   # adds: ||DATA_NOT_COLLECTED
asc web privacy apply  --app 6791106082 --file privacy.json
asc web privacy publish --app 6791106082 --confirm
```

where `privacy.json` is `{"schemaVersion":1,"dataUsages":[{"dataProtections":["DATA_NOT_COLLECTED"]}]}`
(identical to Wordroot's published declaration). Verified: `published: true`.

## Submit decision 2026-08-18 — HOLD, with one real defect to fix first

Both platforms are otherwise ready: App Privacy published, pricing set (free/CAN), iPhone 6.5" ×3
and Mac 1280×800 ×1 uploaded, `asc validate` 0 errors / 0 warnings / 1 info on each. Versions sit at
`PREPARE_FOR_SUBMISSION`.

Not submitted today, for two reasons:

- [ ] **`MARKETING_VERSION` is 0.1.0 in `src/ios/project.yml`** — the in-app Settings tab renders
      "Version 0.1.0" while the App Store listing says 1.0. That contradiction is the exact class of
      unpolished detail Apple cited under Guideline 5.6 across this account. Fix the yml, rebuild,
      re-upload (this replaces the currently VALID attached build), then submit.
      `src/macos/project.yml` is already correct.
- Queue discipline: `wiki/pages/ship-plan.md` § "Order of operations" step 5 — one app at a time.
  Wordroot went in today, and Curvely + Wiretext are already in review. Adding BCGD makes four.

Also worth doing before the macOS submit, not blocking: the Mac listing carries a single Dashboard
screenshot. Adding a selection binding to the `TabView` would allow capturing the other tabs.

**Note:** the earlier "App Privacy is the only remaining blocker" line above is superseded — it was
published 2026-08-18, see the section above it.

## Version defect fixed + both platforms rebuilt and uploaded — 2026-08-18

**The recorded diagnosis was half the story.** `MARKETING_VERSION: 0.1.0` in `src/ios/project.yml`
was real, but fixing it alone would NOT have fixed the Settings tab: the version was **hardcoded**
as a string literal in `Views.swift:167`, on **both** platforms:

```swift
LabeledContent("Version", value: "0.1.0")     // ios AND macos
```

So macOS displayed `0.1.0` too, despite its yml having always said `1.0` — the earlier note that
"`src/macos/project.yml` is already correct" was true and still left the Mac app showing the wrong
version. Both now read the bundle, so the displayed version tracks `MARKETING_VERSION` and cannot
drift again:

```swift
LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
```

- [x] `MARKETING_VERSION` corrected to `1.0` (iOS yml) and version display de-hardcoded (both platforms)
- [x] Both platforms rebuilt and uploaded as build `202608181253`, both verified `VALID`
      (iOS build `e4da322e-…`, macOS build `29b59afc-…`), both attached to version 1.0
- [x] Versions deliberately left in `PREPARE_FOR_SUBMISSION` — **not submitted**, per the
      one-app-at-a-time queue rule while Curvely / Wiretext / Wordroot iOS are in review

### macOS ITMS-90242 was present here too, and is now fixed
BCGD's Mac archive had the **same defect that blocked Wordroot's Mac build three times**: automatic
signing signed the `.app` with `Apple Development` while the installer was correctly signed with
`3rd Party Mac Developer Installer`. Verified with `codesign -dvvv` on the archive before uploading,
which is worth doing every time — the upload would otherwise have failed on Apple's side.

Fix was export-side only, no manual signing style and no provisioning profile juggling. Added to
`src/macos/ExportOptions.plist`:

```xml
<key>signingCertificate</key><string>3rd Party Mac Developer Application</string>
<key>installerSigningCertificate</key><string>3rd Party Mac Developer Installer</string>
```

Confirmed by expanding the exported `.pkg` (`pkgutil --expand-full`) and re-running `codesign -dvvv`
on the app inside: now `3rd Party Mac Developer Application: Joshua Trommel`. **This same fix should
unblock wordroot's macOS build** — it is the identical failure.

### Trap waiting for whoever submits this
- [ ] BCGD has a **stray empty review submission** `59cef0f7-188d-4ab8-bb6b-6c4c3f37239b`
      (`READY_FOR_REVIEW`, IOS, **0 items**), not created by this session. This is the same trap
      that hijacked Wordroot's submit earlier today: `asc review submit` reuses the existing empty
      submission and then fails its own validation with *"does not contain target version"*.
      Workaround that worked for Wordroot: `asc review submissions-submit --id <id> --confirm`.
      Also note `asc review submissions-list` misreports `Items 0` even when items exist — use
      `asc review items list --submission <id>` for the true count.

Not done, deliberately: no Settings screenshot was added. The uploaded set is Dashboard / Inventory /
Jobs, which already meets Apple's requirement, and there was no stale Settings shot to replace — a
settings screen is weak listing material. The Mac listing still carries only the one Dashboard shot;
capturing more still needs a selection binding on the `TabView`.
