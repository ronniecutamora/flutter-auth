"I want to build the MVP for [flutter-auth] following the strict guidelines and architecture defined in my claude.md file.

The MVP must include:

Authentication: Sign Up, Log In, and Sign Out using Supabase.

Profile Management: A screen to View and Edit the user's profile data stored in ronnie_profile_tbl.

Instructions for Incremental Development:
Please break this down into manageable phases. Do not move to the next phase until I have reviewed and confirmed the previous one. For each phase, ensure you follow the MVVM pattern, add DartDocs, and use Material Design 3.

Phase 1: The Foundation (Data Layer)

Create the Profile model in lib/domain/models/.

Create the AuthService and ProfileService in lib/data/services/ to handle direct Supabase calls.

Create the AuthRepository and ProfileRepository in lib/data/repositories/ as the single source of truth.

Phase 2: Logic Layer (View Models)

Implement AuthViewModel and ProfileViewModel using ChangeNotifier.

Handle loading states and error messages as defined in the coding guidelines.

Phase 3: Presentation Layer (UI)

Create the Login/Signup views.

Create the Profile View and Edit screens.

Implement the Provider setup in main.dart.

Phase 4: Routing & Integration

Set up a basic router or conditional logic to show the Auth screen vs. the Home/Profile screen based on the user's session state.

Let's start with Phase 1. Please generate the code for the Data Layer (Models, Services, and Repositories) based on the ronnie_profile_tbl schema. Ensure all Supabase interactions are isolated in the Services."