# Project [flutter-auth]

## Project Overview
A Flutter application handling user authentication, user profile CRUD using Supabase.
- **State Management:** Provider (MVVM Architecture)
- **Backend:** Supabase (Auth & Database)

## Core Technology Stack
- **Flutter SDK:** ^3.10.8
- **State Management:** provider: ^6.1.5+1
- **Backend:** supabase_flutter: ^2.12.0
- **UI Components:** Material Design 3

## Database Schema
  column_name	data_type	is_nullable	column_default
  id	uuid	NO	uid()
  created_at	timestamp with time zone	NO	now()
  name	character varying	YES	''::character varying
  birthday	date	YES	null
  gender	character varying	YES	''::character varying

## Architecture & Project Structure
Follow the [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide):
- **UI Layer (`lib/ui/`)**: 
  - **Views**: Widgets that display data. strictly **passive** (no business logic).
  - **View Models**: `ChangeNotifier` classes that hold state and handle user input.
- **Data Layer (`lib/data/`)**: 
  - **Repositories**: Trusted source of truth. Aggregate data from multiple services.
  - **Services**: Direct API calls (Supabase clients) or local storage access.
- **Models (`lib/domain/`)**: Pure Dart classes (Data Transfer Objects).

**Folder Structure Preference:**
- `lib/ui/features/<feature_name>/` (contains `_view.dart` and `_view_model.dart`)
- `lib/data/repositories/`
- `lib/data/services/`
- `lib/utils/`

## Coding Guidelines
- **MVVM Pattern**: Always separate logic from UI. Widgets should only use `Consumer` or `context.watch/read` to interact with View Models.
- **Supabase**: Access Supabase via a Service class, never directly inside a UI Widget.
- **Documentation**: Always add DartDocs (`///`) to public classes and methods.
- **Styling**: Use `const` constructors wherever possible. Use Material Icons.
- **Error Handling**: Catch errors in the View Model and expose them via an error state string or object; do not let exceptions crash the UI.

## Important Commands
- **Run App**: `flutter run`
- **Fix Lint Issues**: `dart fix --apply`
- **Run Tests**: `flutter test`
- **Build Runner (if applicable)**: `dart run build_runner build --delete-conflicting-outputs`

## Maintenance Rules
- **Self-Update**: After completing a Phase in `ROADMAP.md`, update the file by marking tasks as `[x]` and updating the "Current Status."
- **Evolution**: If we decide on a new coding pattern or add a new library, immediately update the "Core Technology Stack" or "Coding Guidelines" in `claude.md`.
- **Consistency**: Before starting any task, check if the current plan in `ROADMAP.md` still aligns with the project goals.