import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/features/github_users/presentation/providers/github_users_providers.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_users_list.dart';
import 'package:github_users/features/github_users/presentation/widgets/search_widget.dart';

class GithubUsersPage extends ConsumerStatefulWidget {
  const GithubUsersPage({super.key});

  @override
  ConsumerState<GithubUsersPage> createState() => _GithubUsersPageState();
}

class _GithubUsersPageState extends ConsumerState<GithubUsersPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initial data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(githubUsersNotifierProvider.notifier).fetchGithubUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GitHub Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(githubUsersNotifierProvider.notifier).refresh();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchWidget(),
          const Expanded(child: GithubUsersList()),
        ],
      ),
    );
  }
}
