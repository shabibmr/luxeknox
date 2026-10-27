# Codemagic iOS build

Build a signed LuxeKnox iOS release (`.ipa`) on Codemagic. The Flutter app is `app/` in this monorepo. It depends on `packages/api_client`, so Codemagic must clone the repository root.

This host is Linux. The IPA is produced on a Codemagic macOS builder, not by `deploy/build.sh` (that script builds the API and Flutter web only).

## App facts the workflow uses

| Item | Value |
| --- | --- |
| Workflow | `ios-release` in `codemagic.yaml` |
| Project path | `app` |
| Bundle id | `com.luxeknox.app` |
| Display name | LuxeKnox |
| Version name | `version` in `app/pubspec.yaml` (`1.0.0` until you change it) |
| Build number | Codemagic `$PROJECT_BUILD_NUMBER` (increments each build of this workflow) |
| `API_BASE_URL` | `https://api.luxeknox.com` (host only; the app appends `/v1`) |
| `ENV` | `production` |
| Signing | App Store distribution |

`API_BASE_URL` and `ENV` match `deploy/build.sh`. Firestore `config/app` can override the API host at runtime. The dart-define is the fallback.

Flutter stable is required. `app/pubspec.yaml` needs Dart `^3.12.2` (Flutter 3.44.0 or newer). Current stable satisfies that.

## One-time setup

1. Enroll in the Apple Developer Program.
2. In Apple Developer → Identifiers, register an App ID for `com.luxeknox.app`. Enable Push Notifications if this build should receive FCM.
3. In App Store Connect, create the app with the same bundle id before you upload to TestFlight.
4. In App Store Connect → Users and Access → Integrations → App Store Connect API, create a key with App Manager access. Download the `.p8` once. Keep the Issuer ID and Key ID.
5. In Codemagic → Team settings → Team integrations → Developer Portal, add that key. Do not commit the `.p8`.
6. In Codemagic → Team settings → codemagic.yaml settings → Code signing identities:
   - iOS certificates: generate or upload an Apple Distribution certificate for `com.luxeknox.app`.
   - iOS provisioning profiles: fetch or upload an App Store profile for `com.luxeknox.app`.
7. Add the GitHub repository in Codemagic. The configuration type is `codemagic.yaml` at the repository root. Check the file in on the branch you build.
8. Confirm `app/ios/Runner/GoogleService-Info.plist` is the Firebase iOS app for `com.luxeknox.app` (project `luxe-knox-app`). A placeholder plist still compiles. Push does not work until the real plist is in the app and an APNs key is uploaded in Firebase. See [fcm-setup.md](./fcm-setup.md).

## What the workflow does

`codemagic.yaml` workflow `ios-release`:

1. macOS instance `mac_mini_m2`, Flutter `stable`, Xcode `latest`, CocoaPods `default`.
2. Fetches the App Store certificate and profile for `com.luxeknox.app`.
3. `xcode-project use-profiles` in `app/ios` (writes `$HOME/export_options.plist`).
4. `flutter pub get` in `app`.
5. `flutter build ipa --release` with the export plist and the production dart-defines.
6. Saves `app/build/ios/ipa/*.ipa`, Xcode logs, and dSYMs.

It does not start on push. Start it yourself. TestFlight upload is commented out until the App Store Connect key is connected.

## Start a build

1. Codemagic → the LuxeKnox app → Start new build.
2. Branch: the branch that contains `codemagic.yaml`.
3. Workflow: **iOS release** (`ios-release`).
4. Start.

The finished build page has the `.ipa` under artifacts.

To change the API host or environment for one workflow, edit `API_BASE_URL` and `APP_ENV` under `environment.vars` in `codemagic.yaml`. Use the host only (`https://api.luxeknox.com`), not a `/v1` suffix.

## Upload to TestFlight

After steps 3–6 above succeed and a build has produced an IPA:

1. Uncomment the `publishing.app_store_connect` block in `codemagic.yaml`.
2. Push that change, then run **iOS release** again.

Codemagic uploads the IPA with the team’s App Store Connect integration and submits it to TestFlight. The first build for a new app still needs the App Store Connect record, export compliance, and any missing agreements completed in App Store Connect.

## Workflow editor (no yaml)

If a Codemagic app is configured in the Flutter workflow editor instead of `codemagic.yaml`:

1. Build for platforms: iOS, on a macOS machine.
2. After the first scan, set Project path to `app`.
3. Mode: Release. Use `flutter build ipa`.
4. Extra build arguments: `--dart-define=API_BASE_URL=https://api.luxeknox.com --dart-define=ENV=production`.
5. Enable automatic iOS code signing for App Store distribution and bundle id `com.luxeknox.app`.
