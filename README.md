# GitHub Users Flutter App

A Flutter application that allows users to search and view GitHub user profiles with detailed information.

## Features

- Search GitHub users by username
- View detailed user profiles
- User statistics and information
- Modern and responsive UI
- Web, Android, and iOS support

## Live Demo

🌐 **Live Application**: [View on GitHub Pages](https://[your-username].github.io/github_users/)

## Getting Started

### Prerequisites

- Flutter SDK (3.19.0 or higher)
- Dart SDK
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/[your-username]/github_users.git
cd github_users
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### Building for Web

To build the web version:
```bash
flutter build web --base-href "/github_users/"
```

## Deployment

This project is automatically deployed to GitHub Pages using GitHub Actions. The deployment workflow:

1. Triggers on pushes to the `main` branch
2. Sets up Flutter environment
3. Installs dependencies
4. Builds the web application
5. Deploys to GitHub Pages

## Project Structure

```
lib/
├── core/           # Core utilities, constants, and base classes
├── features/       # Feature-based modules
│   └── github_users/
│       ├── data/   # Data layer (models, repositories, data sources)
│       ├── domain/ # Domain layer (entities, repositories interfaces)
│       └── presentation/ # Presentation layer (pages, widgets, providers)
└── main.dart       # Application entry point
```

## Technologies Used

- **Flutter** - UI framework
- **Riverpod** - State management
- **Dio** - HTTP client
- **Injectable** - Dependency injection
- **JSON Serialization** - Data serialization
- **Lottie** - Animations

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
