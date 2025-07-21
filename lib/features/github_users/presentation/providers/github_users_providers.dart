import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/core/utils/user_sorting_util.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/domain/repositories/github_users_repository.dart';
import 'package:github_users/locator.dart';

final githubUsersRepositoryProvider = Provider<GithubUsersRepository>(
  (ref) => locator<GithubUsersRepository>(),
);

final searchQueryProvider = StateProvider<String>((ref) => '');

class GithubUsersNotifier extends AsyncNotifier<List<GithubUserWithScore>> {
  // Note: Caching is currently implemented within the provider for simplicity.
  // Ideally, the repository should be the single source of truth and handle caching,
  // as providers are UI-bound and their state may be lost when the widget tree changes.
  // For improved efficiency and persistence, consider moving the cache to the repository layer.
  // This approach could be optimized in the future.
  final Map<String, List<GithubUserWithScore>> _cache = {};

  @override
  Future<List<GithubUserWithScore>> build() async => [];

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    if (_cache.containsKey(query)) {
      state = AsyncValue.data(_cache[query]!);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(githubUsersRepositoryProvider);

      final basicUsers = (await repository.getGithubUsers(
        query: query,
      )).fold((failure) => throw failure, (users) => users);

      if (basicUsers.isEmpty) {
        state = const AsyncValue.data([]);
        _cache[query] = [];
        return;
      }

      final detailedUsers = (await repository.getDetailedUsers(
        basicUsers,
      )).fold((failure) => throw failure, (users) => users);

      final sortedUsers = UserSortingUtil.sortUsers(detailedUsers);

      _cache[query] = sortedUsers;

      state = AsyncValue.data(sortedUsers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final githubUsersNotifierProvider =
    AsyncNotifierProvider<GithubUsersNotifier, List<GithubUserWithScore>>(
      () => GithubUsersNotifier(),
    );
