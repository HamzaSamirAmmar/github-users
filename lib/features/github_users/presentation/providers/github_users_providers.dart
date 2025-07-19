import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/core/utls/user_sorting_service.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/domain/repositories/github_users_repository.dart';
import 'package:github_users/locator.dart';

// Repository provider
final githubUsersRepositoryProvider = Provider<GithubUsersRepository>((ref) {
  return locator<GithubUsersRepository>();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// State notifier for GitHub users search
class GithubUsersNotifier
    extends StateNotifier<AsyncValue<List<GithubUserWithScore>>> {
  final GithubUsersRepository _repository;

  GithubUsersNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      // Get basic user information
      final basicUsersResult = await _repository.getGithubUsers(query: query);

      final basicUsers = basicUsersResult.fold(
        (failure) => throw failure,
        (users) => users,
      );

      // If we have basic users, fetch detailed information
      if (basicUsers.isNotEmpty) {
        final detailedUsersResult = await _repository.getDetailedUsers(
          basicUsers,
        );

        final detailedUsers = detailedUsersResult.fold(
          (failure) => throw failure,
          (users) => users,
        );

        // Apply sorting logic (returns GithubUserWithScore)
        final sortedUsers = UserSortingUtil.sortUsers(detailedUsers);

        state = AsyncValue.data(sortedUsers);
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}

// Provider for the notifier
final githubUsersNotifierProvider =
    StateNotifierProvider<
      GithubUsersNotifier,
      AsyncValue<List<GithubUserWithScore>>
    >((ref) {
      final repository = ref.watch(githubUsersRepositoryProvider);
      return GithubUsersNotifier(repository);
    });
