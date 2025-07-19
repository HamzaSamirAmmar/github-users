# GitHub Users App

A Flutter application that displays GitHub users using the GitHub API, built with Riverpod for state management and following clean architecture principles.

## Features

- **GitHub Users List**: Displays a list of GitHub users fetched from the GitHub API
- **Search Functionality**: Filter users by their username
- **Pull to Refresh**: Refresh the user list by pulling down
- **Error Handling**: Proper error states with retry functionality
- **Modern UI**: Material Design 3 with beautiful user cards
- **External Links**: Tap on users to open their GitHub profile

## Architecture

The app follows Clean Architecture principles with the following layers:

### Domain Layer
- **Entities**: `GithubUser` - Core business objects
- **Repositories**: `GithubUsersRepository` - Abstract repository interface

### Data Layer
- **Models**: `GithubUserModel` - Data models with JSON serialization
- **Data Sources**: `GithubRemoteDataSource` - API data source
- **Repository Implementation**: `GithubRepositoryImp` - Concrete repository implementation

### Presentation Layer
- **Providers**: Riverpod providers for state management
- **Pages**: `GithubUsersPage` - Main page
- **Widgets**: Reusable UI components
  - `GithubUserCard` - Individual user card
  - `SearchWidget` - Search functionality
  - `GithubUsersList` - Users list with states
  - `CustomErrorWidget` - Error display

## State Management

The app uses **Riverpod** for state management with the following providers:

- `githubUsersRepositoryProvider` - Repository dependency injection
- `githubUsersNotifierProvider` - Main state notifier for users data
- `filteredGithubUsersProvider` - Filtered users based on search
- `searchQueryProvider` - Search query state
- `githubUsersInitializerProvider` - Initial data fetch

## Dependencies

### Core Dependencies
- `flutter_riverpod` - State management
- `dio` - HTTP client for API calls
- `dartz` - Functional programming utilities
- `equatable` - Value equality
- `json_annotation` - JSON serialization
- `injectable` - Dependency injection
- `get_it` - Service locator
- `url_launcher` - External URL handling

### Development Dependencies
- `build_runner` - Code generation
- `json_serializable` - JSON serialization code generation
- `injectable_generator` - Dependency injection code generation

## Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd github_users
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## API

The app uses the GitHub API to fetch users:
- **Endpoint**: `https://api.github.com/users`
- **Method**: GET
- **Authentication**: Not required for public user data

## Project Structure

```
lib/
├── core/
│   ├── dio_client.dart
│   ├── exception.dart
│   └── failure.dart
├── features/
│   └── github_users/
│       ├── data/
│       │   ├── data_sources/
│       │   │   └── remote/
│       │   │       └── github_remote_data_source.dart
│       │   ├── models/
│       │   │   ├── github_user_model.dart
│       │   │   └── github_user_model.g.dart
│       │   └── repositories/
│       │       └── github_repository_imp.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── github_user.dart
│       │   └── repositories/
│       │       └── github_users_repository.dart
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           │   └── github_users_page.dart
│           ├── providers/
│           │   └── github_users_providers.dart
│           └── widgets/
│               ├── github_user_card.dart
│               ├── github_users_list.dart
│               ├── search_widget.dart
│               └── error_widget.dart
├── locator.dart
├── main.dart
└── my_app.dart
```

## Key Features Implementation

### Riverpod State Management
- Uses `StateNotifierProvider` for managing user data state
- Implements proper loading, error, and success states
- Provides filtered data based on search queries

### Clean Architecture
- Clear separation of concerns between layers
- Dependency injection using Injectable
- Repository pattern for data access

### Error Handling
- Comprehensive error handling at all layers
- User-friendly error messages
- Retry functionality for failed requests

### UI/UX
- Material Design 3 components
- Responsive layout
- Loading states and error states
- Pull-to-refresh functionality
- Search with real-time filtering

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
