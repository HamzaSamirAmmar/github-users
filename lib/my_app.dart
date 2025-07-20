import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/core/theme/github_theme.dart';
import 'package:github_users/features/github_users/presentation/pages/github_users_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'GitHub Users',
        theme: GitHubTheme.darkTheme,
        home: const GithubUsersPage(),
      ),
    );
  }
}
