import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/core/utils/user_sorting_service.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/domain/repositories/github_users_repository.dart';
import 'package:github_users/locator.dart';

final githubUsersRepositoryProvider = Provider<GithubUsersRepository>(
  (ref) => locator<GithubUsersRepository>(),
);

final searchQueryProvider = StateProvider<String>((ref) => '');

class GithubUsersNotifier extends AsyncNotifier<List<GithubUserWithScore>> {
  @override
  Future<List<GithubUserWithScore>> build() async => [];

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
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
        return;
      }

      final detailedUsers = (await repository.getDetailedUsers(
        basicUsers,
      )).fold((failure) => throw failure, (users) => users);

      state = AsyncValue.data(UserSortingUtil.sortUsers(detailedUsers));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clearSearch() => state = const AsyncValue.data([]);
}

final githubUsersNotifierProvider =
    AsyncNotifierProvider<GithubUsersNotifier, List<GithubUserWithScore>>(
      () => GithubUsersNotifier(),
    );
