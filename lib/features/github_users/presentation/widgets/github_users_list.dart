import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/features/github_users/presentation/providers/github_users_providers.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_user_card.dart';
import 'package:github_users/features/github_users/presentation/widgets/error_widget.dart';

class GithubUsersList extends ConsumerWidget {
  const GithubUsersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(filteredGithubUsersProvider);

    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.read(githubUsersNotifierProvider.notifier).refresh();
          },
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return GithubUserCard(user: users[index]);
            },
          ),
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading GitHub users...'),
          ],
        ),
      ),
      error: (error, stackTrace) => CustomErrorWidget(
        message: 'Error: ${error.toString()}',
        onRetry: () {
          ref.read(githubUsersNotifierProvider.notifier).refresh();
        },
      ),
    );
  }
}
