import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:github_users/features/github_users/domain/repositories/github_users_repository.dart';
import 'package:github_users/locator.dart';

// Repository provider
final githubUsersRepositoryProvider = Provider<GithubUsersRepository>((ref) {
  return locator<GithubUsersRepository>();
});

// State notifier for GitHub users
class GithubUsersNotifier extends StateNotifier<AsyncValue<List<GithubUser>>> {
  final GithubUsersRepository _repository;

  GithubUsersNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchGithubUsers() async {
    state = const AsyncValue.loading();

    final result = await _repository.getGithubUsers();

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (users) => state = AsyncValue.data(users),
    );
  }

  void refresh() {
    fetchGithubUsers();
  }
}

// Provider for the notifier
final githubUsersNotifierProvider =
    StateNotifierProvider<GithubUsersNotifier, AsyncValue<List<GithubUser>>>((
      ref,
    ) {
      final repository = ref.watch(githubUsersRepositoryProvider);
      return GithubUsersNotifier(repository);
    });

// Provider for filtered users (for search functionality)
final filteredGithubUsersProvider = Provider<AsyncValue<List<GithubUser>>>((
  ref,
) {
  final usersAsync = ref.watch(githubUsersNotifierProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return usersAsync.when(
    data: (users) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(users);
      }

      final filteredUsers = users
          .where(
            (user) =>
                user.login.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();

      return AsyncValue.data(filteredUsers);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider to trigger initial data fetch
final githubUsersInitializerProvider = FutureProvider<void>((ref) async {
  final notifier = ref.read(githubUsersNotifierProvider.notifier);
  await notifier.fetchGithubUsers();
});
