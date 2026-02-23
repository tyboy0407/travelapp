# travelapp - Gemini Project Context

This document serves as the primary instructional context for Gemini CLI when working within the `travelapp` project. It describes the project's purpose, architecture, and development standards.

## Project Overview

`travelapp` is a modern Flutter application designed to assist users with travel planning and management. The app focuses on a seamless user experience, starting from a robust authentication flow to a feature-rich dashboard.

### Main Technologies
- **Framework:** Flutter (SDK ^3.7.2)
- **Language:** Dart
- **Localization:** Supports Traditional Chinese (`zh-TW`) and English (`en-US`).
- **Styling:** Custom Material 3-inspired UI with a focus on clean, modern aesthetics and dark/light contrast.

## Architecture

The project follows standard Flutter architectural patterns, separating UI (widgets/pages) from business logic.

### Key Directories
- `lib/`: Contains all Dart source code.
  - `main.dart`: Entry point of the application, sets up localization and initial routes.
  - `auth_controller.dart`: Handles authentication logic (currently using mock implementations).
  - Pages:
    - `login_page.dart`: User login with email/password and social login placeholders.
    - `register_page.dart`: Initial email entry for registration.
    - `verification_page.dart`: Email verification code entry.
    - `register_details_page.dart`: Detailed user information collection.
    - `register_success_page.dart`: Registration completion screen.
    - `home_page.dart`: The main dashboard after login.
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`: Platform-specific configurations for multi-platform support.

## Building and Running

### Prerequisites
- Flutter SDK (v3.7.2 or higher)
- Android Studio / Xcode (for mobile development)

### Key Commands
- **Get Dependencies:** `flutter pub get`
- **Run Application:** `flutter run`
- **Run Tests:** `flutter test`
- **Analyze Code:** `flutter analyze`
- **Build Release (Android):** `flutter build apk`
- **Build Release (iOS):** `flutter build ios`

## Development Conventions

### Coding Style
- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- Use `flutter_lints` for static analysis. Ensure `flutter analyze` passes before committing.
- Prefer `const` constructors wherever possible for better performance.
- Use meaningful names for widgets and private members (prefixed with `_`).

### UI & Styling
- Maintain consistency with the established color palette (e.g., `Colors.deepPurple` seed, dark bottom navigation bars).
- Use `SafeArea` to ensure compatibility across various mobile devices with notches or home indicators.
- Localization strings should be managed through the standard Flutter localization delegates.

### Testing
- Widget tests are located in the `test/` directory.
- Aim to add tests for new UI components and business logic in `AuthController`.

## TODOs / Roadmap
- [ ] Implement real backend integration in `AuthController`.
- [ ] Complete the "Account Ledger/Planning" feature.
- [ ] Add real social login (Google/Apple) implementation.
- [ ] Expand localization to more languages if needed.
