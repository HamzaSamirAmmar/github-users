import 'package:github_users/core/constants/app_constants.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_details.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';

class UserSortingUtil {
  /// Calculates the score for a GitHub user based on the specified criteria
  static int calculateUserScore(GithubUserDetails user) {
    int score = 0;

    // Add points for public repositories (1 point per repo)
    score += user.publicRepos * AppConstants.repoPointsPerRepository;

    // Add bonus points for recent activity (commits in last 6 months)
    if (user.updatedAt != null && isRecentlyActive(user.updatedAt!)) {
      score += AppConstants.commitBonusPoints;
    }

    return score;
  }

  /// Checks if a user has been active in the last 6 months
  static bool isRecentlyActive(DateTime updatedAt) {
    final monthsAgoSinceLastCommit = DateTime.now().subtract(
      Duration(days: AppConstants.monthsForRecentCommit * 30),
    );
    return updatedAt.isAfter(monthsAgoSinceLastCommit);
  }

  /// Sorts users according to the specified priority rules and returns users with scores:
  /// 1. Users with 50+ repos are prioritized
  /// 2. Among those, users with recent commits (6 months) appear first
  /// 3. If both conditions are the same, sort by score
  static List<GithubUserWithScore> sortUsers(List<GithubUserDetails> users) {
    // Calculate scores and create users with scores
    final usersWithScores = users.map((user) {
      final score = calculateUserScore(user);
      return GithubUserWithScore.fromDetails(user, score);
    }).toList();

    // Sort users based on the priority rules
    usersWithScores.sort((a, b) {
      // Rule 1: Users with 50+ repos get priority
      final aHasManyRepos = a.publicRepos >= AppConstants.minReposForPriority;
      final bHasManyRepos = b.publicRepos >= AppConstants.minReposForPriority;

      if (aHasManyRepos && !bHasManyRepos) return -1;
      if (!aHasManyRepos && bHasManyRepos) return 1;

      // If both have same repo priority, check recent activity
      if (aHasManyRepos && bHasManyRepos) {
        final aIsRecent =
            a.updatedAt != null && isRecentlyActive(a.updatedAt!);
        final bIsRecent =
            b.updatedAt != null && isRecentlyActive(b.updatedAt!);

        if (aIsRecent && !bIsRecent) return -1;
        if (!aIsRecent && bIsRecent) return 1;
      }

      // If both conditions are the same, sort by score (descending)
      return b.score.compareTo(a.score);
    });

    return usersWithScores;
  }
}
