# flutter-auth

A Flutter application handling user authentication and profile management using Supabase as a database backend with custom auth logic.

## Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter SDK ^3.10.8 |
| State Management | Provider ^6.1.5+1 (MVVM) |
| Backend | Supabase (Database only) |
| UI | Material Design 3 |

## Architecture

This project follows the [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide) using the **MVVM** (Model-View-ViewModel) pattern.

```
┌──────────────────────────────────────────────┐
│  VIEW  (auth_view.dart, profile_view.dart)   │  What the user sees & taps
│  Knows NOTHING about Supabase or databases.  │  Only talks to the ViewModel.
├──────────────────────────────────────────────┤
│  VIEW MODEL  (auth_view_model.dart, etc.)    │  Business logic + state
│  Holds isLoading, errorMessage, etc.         │  Only talks to the Repository.
├──────────────────────────────────────────────┤
│  REPOSITORY  (auth_repository.dart, etc.)    │  Single source of truth
│  Aggregates/coordinates Services.            │  Only talks to Services.
├──────────────────────────────────────────────┤
│  SERVICE  (auth_service.dart, etc.)          │  Raw API calls
│  Directly calls Supabase SDK.                │  Knows nothing about UI or state.
└──────────────────────────────────────────────┘
```

Each layer only knows about the layer directly below it. The View never touches Supabase. The Service never touches widgets.

## Project Structure

```
lib/
├── main.dart                              (MultiProvider + MaterialApp + AuthGate)
├── domain/models/
│   └── user.dart                          (User DTO — maps to ronnie_users_tbl)
├── data/
│   ├── services/
│   │   ├── auth_service.dart              (Custom auth via DB queries)
│   │   └── profile_service.dart           (Profile DB queries)
│   └── repositories/
│       ├── auth_repository.dart           (Auth source of truth)
│       └── profile_repository.dart        (Profile source of truth)
└── ui/
    ├── auth_gate.dart                     (Watches AuthViewModel for routing)
    └── features/
        ├── auth/
        │   ├── auth_view.dart             (Login/Signup screen)
        │   └── auth_view_model.dart       (Auth state + in-memory session)
        └── profile/
            ├── profile_view.dart          (Profile display screen)
            ├── profile_edit_view.dart      (Profile edit form)
            └── profile_view_model.dart    (Profile state management)
```

## Database Schema

Single table: `ronnie_users_tbl`

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | NO | uid() |
| created_at | timestamp with time zone | NO | now() |
| name | character varying | YES | '' |
| birthday | date | YES | null |
| gender | character varying | YES | '' |
| email | character varying | NO | null |
| password | character varying | YES | null |

## Features

- **Sign Up** — Creates a new row in `ronnie_users_tbl`
- **Sign In** — Queries the table for matching email + password
- **Sign Out** — Clears the in-memory session
- **View Profile** — Displays user data (name, email, birthday, gender)
- **Edit Profile** — Updates name, birthday, and gender fields

## How Authentication Works

This app does **not** use Supabase's built-in auth. Instead, it implements custom authentication by querying `ronnie_users_tbl` directly. The user session is held in memory inside `AuthViewModel`.

### Sign-In Flow (Full Round-Trip)

```
 User taps "Sign In"
       │
       ▼ (going DOWN)
  AuthView._submit()
       │  viewModel.signIn(email, password)
       ▼
  AuthViewModel.signIn()
       │  _authRepository.signIn(email, password)
       ▼
  AuthRepository.signIn()
       │  _authService.signIn(email, password)
       ▼
  AuthService.signIn()
       │  Supabase DB query → SELECT * FROM ronnie_users_tbl
       │                       WHERE email = ? AND password = ?
       │
       ▼ (response comes BACK UP)
       │
  AuthService returns    →  Map<String, dynamic>?  (raw JSON row)
       │
  AuthRepository returns →  User?                  (parsed model)
       │
  AuthViewModel receives →  _currentUser = user    (stores it)
       │                    notifyListeners()       ← FIRES HERE
       │
       ▼ (the redirect happens)
       │
  AuthGate.build() runs  →  isLoggedIn is now TRUE
       │                    returns ProfileView()   ← SCREEN SWAPS
       ▼
  User sees Profile screen
```

### How the Screen Swap Works

There is no explicit navigation (`Navigator.push`, redirect, etc.). The screen swap is entirely **reactive**:

1. `AuthViewModel` stores the user and calls `notifyListeners()`
2. `AuthGate` is watching via `context.watch<AuthViewModel>()`
3. Flutter rebuilds `AuthGate`, which now returns `ProfileView` instead of `AuthView`

Sign-out works the same way in reverse: `_currentUser` becomes `null` → `isLoggedIn` becomes `false` → `AuthGate` rebuilds → shows `AuthView`.

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.8
- A Supabase project with the `ronnie_users_tbl` table created

### Run the App

```bash
flutter run
```

### Other Commands

```bash
# Fix lint issues
dart fix --apply

# Run tests
flutter test
```
