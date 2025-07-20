import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_users_page/github_users_search_bar.dart';

class GithubUsersPage extends ConsumerWidget {
  const GithubUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/pngs/logo.png', height: 32, width: 32),
            const SizedBox(width: 12),
            const Text(
              'GitHub Users',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: const GithubUsersSearchBar(),
      ),
    );
  }
}
