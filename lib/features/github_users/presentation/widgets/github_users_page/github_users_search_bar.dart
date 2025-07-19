import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:github_users/core/constants/app_constants.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/presentation/pages/user_details_page.dart';
import 'package:github_users/features/github_users/presentation/providers/github_users_providers.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_users_page/user_suggestion_item.dart';

class GithubUsersSearchBar extends ConsumerStatefulWidget {
  const GithubUsersSearchBar({super.key});

  @override
  ConsumerState<GithubUsersSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<GithubUsersSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<GithubUserWithScore>> _getSuggestions(String query) async {
    if (query.isEmpty) return [];

    await ref.read(githubUsersNotifierProvider.notifier).searchUsers(query);
    return ref
        .read(githubUsersNotifierProvider)
        .when(
          data: (users) => users,
          loading: () => <GithubUserWithScore>[],
          error: (_, __) => <GithubUserWithScore>[],
        );
  }

  void _onSuggestionSelected(GithubUserWithScore user) {
    _searchController.clear();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserDetailsPage(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(githubUsersNotifierProvider).isLoading;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TypeAheadField<GithubUserWithScore>(
            controller: _searchController,
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Search GitHub users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            suggestionsCallback: _getSuggestions,
            itemBuilder: (context, user) => UserSuggestionItem(user: user),
            onSelected: _onSuggestionSelected,
            debounceDuration: AppConstants.searchDebounceDuration,
          ),
        ),
        if (_searchController.text.isEmpty)
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Start typing to search GitHub users',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
