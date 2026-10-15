# Ruralz Maths

MHT-CET Mathematics practice app for Android and Web.

## App features in the current source
- Light green theme and English-only UI
- 15 mathematics topics, with 20 tests per topic in Supabase
- 50 questions and 90 minutes per test
- Supabase email/password sign-in and sign-up
- Live topic, test, and question loading from Supabase
- Random question order each time a test is opened
- Score calculation, answer review, and explanations
- Attempt/result persistence is implemented in the client, but must be validated against the live policies before distribution
- Splash screen shows the Ruralz logo and “Developed by D. K. Chavan sir” for 10 seconds

## Supabase
The app source uses the project URL and a publishable key. The live database has 15 topics, 300 tests, and 15,000 questions. These counts do not certify that all answers are mathematically correct or that all questions are authentic PYQs.

A security audit found that the `handle_new_user()` trigger function was directly executable via RPC. Direct execution has been revoked for `PUBLIC`, `anon`, and `authenticated`; the database trigger can still invoke it as part of the auth-user insert flow. Sign-up must be tested end-to-end after any build.

## Build
The GitHub Actions workflow at `.github/workflows/build.yml` runs Flutter dependency installation, static analysis, a release APK build, and a web build. It uploads the APK and a ZIP of the web build as workflow artifacts.

**Distribution status:** Development build only until the workflow passes and sign-up, sign-in, test submission, and result persistence are manually verified on Android and Web. The current source does not yet provide PDF export or a result-history screen.


## Build verification
A push to `main` starts the Android and Web build workflow. Open the Actions page to see the latest run and download artifacts after a successful build: https://github.com/ruralzedu-creator/Ruralz-Maths/actions
