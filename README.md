# GitHub Users Search

A modern Flutter application that provides an intuitive search experience for discovering GitHub users with intelligent sorting and ranking algorithms. Built with clean architecture principles and optimized for both mobile and web platforms.

## 🎯 Project Purpose

GitHub Users Search is designed to help developers and recruiters efficiently discover and evaluate GitHub users based on their activity, repository contributions, and recent engagement. The application leverages GitHub's public API to provide real-time search results with intelligent scoring and prioritization.

### Key Features
- **Real-time Search**: Instant search suggestions with debounced API calls
- **Intelligent Sorting**: Advanced scoring algorithm based on repository count and recent activity
- **Cross-platform**: Native mobile apps (iOS/Android) and web application
- **Keyboard Navigation**: Full keyboard support for web users
- **Responsive Design**: Optimized UI for all screen sizes
- **Clean Architecture**: Maintainable and scalable codebase

## 🏗️ Project Structure

```
lib/
├── core/                          # Core functionality and utilities
│   ├── constants/                 # Application constants
│   ├── data/                      # Base data layer abstractions
│   ├── errors/                    # Error handling
│   ├── network/                   # Network client configuration
│   └── utils/                     # Utility classes (sorting, etc.)
├── features/                      # Feature-based modules
│   └── github_users/              # GitHub users feature
│       ├── data/                  # Data layer
│       │   ├── data_sources/      # Remote and local data sources
│       │   ├── models/            # Data models
│       │   └── repositories/      # Repository implementations
│       ├── domain/                # Business logic layer
│       │   ├── entities/          # Domain entities
│       │   └── repositories/      # Repository interfaces
│       └── presentation/          # UI layer
│           ├── pages/             # Screen widgets
│           ├── providers/         # State management
│           └── widgets/           # Reusable UI components
├── locator.dart                   # Dependency injection setup
└── main.dart                      # Application entry point
```

## 📦 Top Used Packages

### State Management
- **flutter_riverpod** (^2.6.1): Modern state management solution with provider pattern
- **get_it** (^8.0.3): Dependency injection container
- **injectable** (^2.5.0): Code generation for dependency injection

### Networking & Data
- **dio** (^5.8.0+1): HTTP client for API requests
- **dartz** (^0.10.1): Functional programming utilities for error handling
- **json_annotation** (^4.9.0): JSON serialization support
- **json_serializable** (^6.9.5): Code generation for JSON serialization

### UI & UX
- **flutter_typeahead** (^5.2.0): Autocomplete search field with suggestions
- **url_launcher** (^6.3.1): Launch external URLs (GitHub profiles)
- **equatable** (^2.0.7): Value equality for objects

### Development Tools
- **build_runner** (^2.5.4): Code generation runner
- **flutter_lints** (^5.0.0): Linting rules
- **flutter_launcher_icons** (^0.13.1): App icon generation

## 🧮 Sorting Algorithm

The application implements a sophisticated scoring and sorting algorithm to prioritize the most relevant GitHub users:

### Scoring System
```dart
// Constants from app_constants.dart
static const int commitBonusPoints = 5;
static const int repoPointsPerRepository = 1;
static const int minReposForPriority = 50;
static const int monthsForRecentCommit = 6;
```

### Algorithm Logic
1. **Base Score Calculation**:
   - 1 point per public repository
   - 5 bonus points for recent activity (within 6 months)

2. **Priority Rules**:
   - **Primary**: Users with 50+ repositories get top priority
   - **Secondary**: Among high-repo users, those with recent commits appear first
   - **Tertiary**: Final sorting by calculated score (descending)

3. **Recent Activity Detection**:
   - Considers users active if they have commits within the last 6 months
   - Uses the `updatedAt` field from GitHub API

### Implementation
The sorting logic is implemented in `UserSortingUtil` class with the following key methods:
- `calculateUserScore()`: Computes individual user scores
- `isRecentlyActive()`: Determines if user has recent activity
- `sortUsers()`: Applies the complete sorting algorithm

## ⌨️ Keyboard Navigation (Web)

The application provides comprehensive keyboard navigation support for web users:

### Navigation Controls
- **Arrow Down (↓)**: Navigate to next suggestion
- **Arrow Up (↑)**: Navigate to previous suggestion
- **Enter**: Select highlighted suggestion
- **Escape**: Clear search and reset selection

### Implementation Details
- Uses Flutter's `Focus` widget with `onKeyEvent` handler
- Maintains selection state with `_selectedIndex` variable
- Visual feedback with highlighted suggestions
- Automatic focus management and state reset

### Code Example
```dart
KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
  switch (event.logicalKey) {
    case LogicalKeyboardKey.arrowDown:
      // Navigate down
    case LogicalKeyboardKey.arrowUp:
      // Navigate up
    case LogicalKeyboardKey.enter:
      // Select item
  }
}
```

## 💾 Caching Strategy

The application implements a multi-layered caching approach for optimal performance:

### Architecture
- **Repository Pattern**: Centralized data access with caching logic
- **Dependency Injection**: Injectable services for easy testing and maintenance
- **Error Handling**: Graceful fallbacks with Either type from dartz

### Caching Layers
1. **In-Memory Caching**: Recent search results stored in state
2. **API Response Caching**: Dio client with built-in caching
3. **State Persistence**: Riverpod providers maintain state across navigation

### Implementation
- Uses `BaseRepository` pattern for consistent caching behavior
- Leverages Riverpod's built-in caching mechanisms
- Implements debounced search to reduce API calls
- Graceful error handling with user-friendly fallbacks

## 📱 Download Links

### Mobile Applications
- **Android APK**: [Download APK](https://drive.google.com/file/d/1tuFJaZgL9PsFlLRSf90pNrPIqExA1vBT/view?usp=sharing)

### Web Application
- **Live Demo**: [PWA Link](https://loquacious-griffin-3fa7c4.netlify.app)