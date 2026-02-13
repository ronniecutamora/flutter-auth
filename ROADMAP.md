# flutter-auth MVP Roadmap

## Current Status: All Phases Complete

The MVP for [flutter-auth] follows the strict guidelines and architecture defined in claude.md.

The MVP includes:

- **Authentication:** Sign Up, Log In, and Sign Out using Supabase.
- **Profile Management:** A screen to View and Edit the user's profile data stored in `ronnie_profile_tbl`.

## Instructions for Incremental Development
Please break this down into manageable phases. Do not move to the next phase until I have reviewed and confirmed the previous one. For each phase, ensure you follow the MVVM pattern, add DartDocs, and use Material Design 3.

## Phase 1: The Foundation (Data Layer) - [x] Complete

- [x] Create the Profile model in `lib/domain/models/`.
- [x] Create the AuthService and ProfileService in `lib/data/services/` to handle direct Supabase calls.
- [x] Create the AuthRepository and ProfileRepository in `lib/data/repositories/` as the single source of truth.

## Phase 2: Logic Layer (View Models) - [x] Complete

- [x] Implement AuthViewModel and ProfileViewModel using ChangeNotifier.
- [x] Handle loading states and error messages as defined in the coding guidelines.

## Phase 3: Presentation Layer (UI) - [x] Complete

- [x] Create the Login/Signup views.
- [x] Create the Profile View and Edit screens.
- [x] Implement the Provider setup in main.dart.

## Phase 4: Routing & Integration - [x] Complete

- [x] Set up conditional logic to show the Auth screen vs. the Home/Profile screen based on the user's session state.
