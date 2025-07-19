import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/core/constants/app_constants.dart';
import 'package:github_users/features/github_users/presentation/providers/github_users_providers.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_user_card.dart';
import 'package:github_users/features/github_users/presentation/widgets/error_widget.dart';
import 'dart:async';

class DebouncedSearchWidget extends ConsumerStatefulWidget {
  const DebouncedSearchWidget({super.key});

  @override
  ConsumerState<DebouncedSearchWidget> createState() =>
      _DebouncedSearchWidgetState();
}

class _DebouncedSearchWidgetState extends ConsumerState<DebouncedSearchWidget> {
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Update the search query
    ref.read(searchQueryProvider.notifier).state = query;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set new timer for debounced search
    _debounceTimer = Timer(AppConstants.searchDebounceDuration, () {
      ref.read(githubUsersNotifierProvider.notifier).searchUsers(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(githubUsersNotifierProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final usersAsync = ref.watch(githubUsersNotifierProvider);

    return Column(
      children: [
        // Search TextField
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search GitHub users...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        // Results List
        Expanded(
          child: usersAsync.when(
            data: (users) {
              if (searchQuery.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Search for GitHub users',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

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

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return GithubUserCard(user: users[index]);
                },
              );
            },
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Searching...'),
                ],
              ),
            ),
            error: (error, stackTrace) => CustomErrorWidget(
              message: 'Error: ${error.toString()}',
              onRetry: () {
                final query = ref.read(searchQueryProvider);
                if (query.isNotEmpty) {
                  ref
                      .read(githubUsersNotifierProvider.notifier)
                      .searchUsers(query);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
