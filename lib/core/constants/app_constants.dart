class AppConstants {
  // Sorting and Scoring Constants
  static const int commitBonusPoints = 5;
  static const int repoPointsPerRepository = 1;
  static const int minReposForPriority = 50;
  static const int monthsForRecentCommit = 6;

  // API Endpoints
  static const String baseUrl = 'https://api.github.com';
  static const String usersEndpoint = '/users';
  static const String searchUsersEndpoint = '/search/users';

  // API Parameters
  static const int defaultPerPage = 10;
  static const int maxPerPage = 100;

  // Debounce and Search Constants
  static const Duration searchDebounceDuration = Duration(milliseconds: 800);
  static const int minSearchLength = 2;

  // UI Constants
  static const double cardElevation = 2.0;
  static const double cardRadius = 8.0;
  static const double avatarRadius = 25.0;
}
