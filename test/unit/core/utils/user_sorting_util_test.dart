import 'package:flutter_test/flutter_test.dart';
import 'package:github_users/core/constants/app_constants.dart';
import 'package:github_users/core/utils/user_sorting_util.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_details.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';

void main() {
  group('UserSortingUtil', () {
    group('calculateUserScore', () {
      test('should calculate score based on public repositories only', () {
        // Arrange
        final user = GithubUserDetails(
          id: 1,
          login: 'testuser',
          avatarUrl: 'https://example.com/avatar.jpg',
          htmlUrl: 'https://github.com/testuser',
          publicRepos: 10,
          updatedAt: null, // No recent activity
        );

        // Act
        final score = UserSortingUtil.calculateUserScore(user);

        // Assert
        expect(score, equals(10 * AppConstants.repoPointsPerRepository));
      });

      test('should add bonus points for recent activity', () {
        // Arrange
        final recentDate = DateTime.now().subtract(const Duration(days: 30));
        final user = GithubUserDetails(
          id: 1,
          login: 'testuser',
          avatarUrl: 'https://example.com/avatar.jpg',
          htmlUrl: 'https://github.com/testuser',
          publicRepos: 5,
          updatedAt: recentDate,
        );

        // Act
        final score = UserSortingUtil.calculateUserScore(user);

        // Assert
        final expectedScore =
            (5 * AppConstants.repoPointsPerRepository) +
            AppConstants.commitBonusPoints;
        expect(score, equals(expectedScore));
      });

      test('should not add bonus points for old activity', () {
        // Arrange
        final oldDate = DateTime.now().subtract(
          Duration(days: (AppConstants.monthsForRecentCommit * 30) + 10),
        );
        final user = GithubUserDetails(
          id: 1,
          login: 'testuser',
          avatarUrl: 'https://example.com/avatar.jpg',
          htmlUrl: 'https://github.com/testuser',
          publicRepos: 5,
          updatedAt: oldDate,
        );

        // Act
        final score = UserSortingUtil.calculateUserScore(user);

        // Assert
        expect(score, equals(5 * AppConstants.repoPointsPerRepository));
      });

      test('should handle zero repositories', () {
        // Arrange
        final user = GithubUserDetails(
          id: 1,
          login: 'testuser',
          avatarUrl: 'https://example.com/avatar.jpg',
          htmlUrl: 'https://github.com/testuser',
          publicRepos: 0,
          updatedAt: DateTime.now(),
        );

        // Act
        final score = UserSortingUtil.calculateUserScore(user);

        // Assert
        expect(score, equals(AppConstants.commitBonusPoints));
      });

      test('should handle large number of repositories', () {
        // Arrange
        final user = GithubUserDetails(
          id: 1,
          login: 'testuser',
          avatarUrl: 'https://example.com/avatar.jpg',
          htmlUrl: 'https://github.com/testuser',
          publicRepos: 1000,
          updatedAt: DateTime.now(),
        );

        // Act
        final score = UserSortingUtil.calculateUserScore(user);

        // Assert
        final expectedScore =
            (1000 * AppConstants.repoPointsPerRepository) +
            AppConstants.commitBonusPoints;
        expect(score, equals(expectedScore));
      });
    });

    group('isRecentlyActive', () {
      test('should return true for activity within 6 months', () {
        // Arrange
        final recentDate = DateTime.now().subtract(const Duration(days: 30));

        // Act
        final isRecent = UserSortingUtil.isRecentlyActive(recentDate);

        // Assert
        expect(isRecent, isTrue);
      });

      test('should return false for activity older than 6 months', () {
        // Arrange
        final oldDate = DateTime.now().subtract(
          Duration(days: (AppConstants.monthsForRecentCommit * 30) + 10),
        );

        // Act
        final isRecent = UserSortingUtil.isRecentlyActive(oldDate);

        // Assert
        expect(isRecent, isFalse);
      });

      test('should return false for activity exactly 6 months ago', () {
        // Arrange
        final exactDate = DateTime.now().subtract(
          Duration(days: AppConstants.monthsForRecentCommit * 30),
        );

        // Act
        final isRecent = UserSortingUtil.isRecentlyActive(exactDate);

        // Assert
        expect(isRecent, isFalse);
      });

      test('should return true for current date', () {
        // Arrange
        final currentDate = DateTime.now();

        // Act
        final isRecent = UserSortingUtil.isRecentlyActive(currentDate);

        // Assert
        expect(isRecent, isTrue);
      });

      test('should return true for activity just before 6 months', () {
        // Arrange
        final justBeforeDate = DateTime.now().subtract(
          Duration(days: (AppConstants.monthsForRecentCommit * 30) - 1),
        );

        // Act
        final isRecent = UserSortingUtil.isRecentlyActive(justBeforeDate);

        // Assert
        expect(isRecent, isTrue);
      });

      test('should return false for activity just after 6 months', () {
        // Arrange
        final justAfterDate = DateTime.now().subtract(
          Duration(days: (AppConstants.monthsForRecentCommit * 30) + 1),
        );

        // Act
        final isRecent = UserSortingUtil.isRecentlyActive(justAfterDate);

        // Assert
        expect(isRecent, isFalse);
      });
    });

    group('sortUsers', () {
      test('should sort users with 50+ repos first', () {
        // Arrange
        final users = [
          GithubUserDetails(
            id: 1,
            login: 'user1',
            avatarUrl: 'https://example.com/avatar1.jpg',
            htmlUrl: 'https://github.com/user1',
            publicRepos: 30,
            updatedAt: DateTime.now(),
          ),
          GithubUserDetails(
            id: 2,
            login: 'user2',
            avatarUrl: 'https://example.com/avatar2.jpg',
            htmlUrl: 'https://github.com/user2',
            publicRepos: 60,
            updatedAt: DateTime.now(),
          ),
          GithubUserDetails(
            id: 3,
            login: 'user3',
            avatarUrl: 'https://example.com/avatar3.jpg',
            htmlUrl: 'https://github.com/user3',
            publicRepos: 20,
            updatedAt: DateTime.now(),
          ),
        ];

        // Act
        final sortedUsers = UserSortingUtil.sortUsers(users);

        // Assert
        expect(sortedUsers.length, equals(3));
        expect(sortedUsers[0].login, equals('user2')); // 60 repos
        expect(sortedUsers[1].login, equals('user1')); // 30 repos
        expect(sortedUsers[2].login, equals('user3')); // 20 repos
      });

      test('should prioritize recent activity among users with 50+ repos', () {
        // Arrange
        final recentDate = DateTime.now().subtract(const Duration(days: 30));
        final oldDate = DateTime.now().subtract(
          Duration(days: (AppConstants.monthsForRecentCommit * 30) + 10),
        );

        final users = [
          GithubUserDetails(
            id: 1,
            login: 'user1',
            avatarUrl: 'https://example.com/avatar1.jpg',
            htmlUrl: 'https://github.com/user1',
            publicRepos: 60,
            updatedAt: oldDate, // Old activity
          ),
          GithubUserDetails(
            id: 2,
            login: 'user2',
            avatarUrl: 'https://example.com/avatar2.jpg',
            htmlUrl: 'https://github.com/user2',
            publicRepos: 55,
            updatedAt: recentDate, // Recent activity
          ),
        ];

        // Act
        final sortedUsers = UserSortingUtil.sortUsers(users);

        // Assert
        expect(sortedUsers[0].login, equals('user2')); // Recent activity
        expect(sortedUsers[1].login, equals('user1')); // Old activity
      });

      test(
        'should sort by score when both repo count and activity are same',
        () {
          // Arrange
          final sameDate = DateTime.now().subtract(const Duration(days: 30));
          final users = [
            GithubUserDetails(
              id: 1,
              login: 'user1',
              avatarUrl: 'https://example.com/avatar1.jpg',
              htmlUrl: 'https://github.com/user1',
              publicRepos: 60,
              updatedAt: sameDate,
            ),
            GithubUserDetails(
              id: 2,
              login: 'user2',
              avatarUrl: 'https://example.com/avatar2.jpg',
              htmlUrl: 'https://github.com/user2',
              publicRepos: 65, // Higher score
              updatedAt: sameDate,
            ),
          ];

          // Act
          final sortedUsers = UserSortingUtil.sortUsers(users);

          // Assert
          expect(sortedUsers[0].login, equals('user2')); // Higher score
          expect(sortedUsers[1].login, equals('user1')); // Lower score
        },
      );

      test('should handle empty list', () {
        // Arrange
        final users = <GithubUserDetails>[];

        // Act
        final sortedUsers = UserSortingUtil.sortUsers(users);

        // Assert
        expect(sortedUsers, isEmpty);
      });

      test('should handle single user', () {
        // Arrange
        final users = [
          GithubUserDetails(
            id: 1,
            login: 'user1',
            avatarUrl: 'https://example.com/avatar1.jpg',
            htmlUrl: 'https://github.com/user1',
            publicRepos: 50,
            updatedAt: DateTime.now(),
          ),
        ];

        // Act
        final sortedUsers = UserSortingUtil.sortUsers(users);

        // Assert
        expect(sortedUsers.length, equals(1));
        expect(sortedUsers[0].login, equals('user1'));
        expect(
          sortedUsers[0].score,
          equals(50 + AppConstants.commitBonusPoints),
        );
      });

      test('should handle users with null updatedAt', () {
        // Arrange
        final users = [
          GithubUserDetails(
            id: 1,
            login: 'user1',
            avatarUrl: 'https://example.com/avatar1.jpg',
            htmlUrl: 'https://github.com/user1',
            publicRepos: 60,
            updatedAt: null,
          ),
          GithubUserDetails(
            id: 2,
            login: 'user2',
            avatarUrl: 'https://example.com/avatar2.jpg',
            htmlUrl: 'https://github.com/user2',
            publicRepos: 55,
            updatedAt: DateTime.now(),
          ),
        ];

        // Act
        final sortedUsers = UserSortingUtil.sortUsers(users);

        // Assert
        expect(sortedUsers[0].login, equals('user2')); // Has recent activity
        expect(sortedUsers[1].login, equals('user1')); // No activity info
      });

      test('should create GithubUserWithScore objects with correct scores', () {
        // Arrange
        final users = [
          GithubUserDetails(
            id: 1,
            login: 'user1',
            avatarUrl: 'https://example.com/avatar1.jpg',
            htmlUrl: 'https://github.com/user1',
            publicRepos: 10,
            updatedAt: DateTime.now(),
          ),
        ];

        // Act
        final sortedUsers = UserSortingUtil.sortUsers(users);

        // Assert
        expect(sortedUsers[0], isA<GithubUserWithScore>());
        expect(
          sortedUsers[0].score,
          equals(10 + AppConstants.commitBonusPoints),
        );
        expect(sortedUsers[0].id, equals(1));
        expect(sortedUsers[0].login, equals('user1'));
      });

      test('should handle complex sorting scenario', () {
        // Arrange
        final recentDate = DateTime.now().subtract(const Duration(days: 30));
        final oldDate = DateTime.now().subtract(
          Duration(days: (AppConstants.monthsForRecentCommit * 30) + 10),
        );

        final users = [
          // User with 50+ repos and recent activity (should be first)
          GithubUserDetails(
            id: 1,
            login: 'high_repo_recent',
            avatarUrl: 'https://example.com/avatar1.jpg',
            htmlUrl: 'https://github.com/high_repo_recent',
            publicRepos: 80,
            updatedAt: recentDate,
          ),
          // User with 50+ repos but old activity (should be second)
          GithubUserDetails(
            id: 2,
            login: 'high_repo_old',
            avatarUrl: 'https://example.com/avatar2.jpg',
            htmlUrl: 'https://github.com/high_repo_old',
            publicRepos: 90,
            updatedAt: oldDate,
          ),
          // User with fewer repos but recent activity (should be third)
          GithubUserDetails(
            id: 3,
            login: 'low_repo_recent',
            avatarUrl: 'https://example.com/avatar3.jpg',
            htmlUrl: 'https://github.com/low_repo_recent',
            publicRepos: 30,
            updatedAt: recentDate,
          ),
          // User with fewer repos and old activity (should be last)
          GithubUserDetails(
            id: 4,
            login: 'low_repo_old',
            avatarUrl: 'https://example.com/avatar4.jpg',
            htmlUrl: 'https://github.com/low_repo_old',
            publicRepos: 25,
            updatedAt: oldDate,
          ),
        ];

        // Act
        final sortedUsers = UserSortingUtil.sortUsers(users);

        // Assert
        expect(sortedUsers.length, equals(4));
        expect(sortedUsers[0].login, equals('high_repo_recent'));
        expect(sortedUsers[1].login, equals('high_repo_old'));
        expect(sortedUsers[2].login, equals('low_repo_recent'));
        expect(sortedUsers[3].login, equals('low_repo_old'));
      });
    });
  });
}
