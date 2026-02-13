# flutter-auth MVP Roadmap

## Current Status: All Phases Complete

The MVP for [flutter-auth] is being rebuilt to use a **custom authentication system**
backed by the `ronnie_users_tbl` Supabase table instead of Supabase's built-in Auth SDK.

The MVP includes:

- **Authentication:** Sign Up, Log In, and Sign Out using direct DB queries on `ronnie_users_tbl`.
- **Profile Management:** View and Edit the user's profile data stored in `ronnie_users_tbl`.

## Instructions for Incremental Development
Follow the MVVM pattern, add DartDocs, and use Material Design 3 for each phase.

## Phase 1: Data Layer Rebuild - [x] Complete

- [x] Create `User` model in `lib/domain/models/` mapping to `ronnie_users_tbl` schema.
- [x] Rewrite `AuthService` to perform sign-up (insert) and sign-in (select) via Supabase DB queries.
- [x] Update `ProfileService` to use `ronnie_users_tbl` instead of `ronnie_profile_tbl`.
- [x] Update `AuthRepository` and `ProfileRepository` for the new service APIs.

## Phase 2: Logic Layer Rebuild - [x] Complete

- [x] Rewrite `AuthViewModel` with custom session management (hold current `User?` in memory).
- [x] Update `ProfileViewModel` to work with the new `User` model.

## Phase 3: Routing & UI Rebuild - [x] Complete

- [x] Rewrite `AuthGate` to watch `AuthViewModel` state instead of Supabase auth stream.
- [x] Update `AuthView`, `ProfileView`, and `ProfileEditView` for the new model/flow.
- [x] Update `main.dart` wiring.
