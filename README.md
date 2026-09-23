# Ruralz Maths

MHT-CET Mathematics practice app for Android and Web.

## Current scope
- Light green, English-only interface
- 15 mathematics topics
- 20 planned tests per topic
- 50 questions and 90 minutes per test
- Supabase integration planned for authenticated question and result storage
- GitHub Actions workflow for Android APK build

## Build
The repository includes a GitHub Actions workflow at `.github/workflows/build.yml`. The workflow runs Flutter dependency installation, static analysis, and a release APK build, then uploads the APK as an artifact.

**Status:** Development scaffold. Supabase schema mapping, authentication, live question loading, answer submission, result persistence, and production validation remain to be completed before distribution.
