import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _selectedIndex = -1;
  List<GithubUserWithScore> _currentSuggestions = [];
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _textFieldFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_textFieldFocusNode.hasFocus) {
      setState(() {
        _selectedIndex = -1;
      });
    }
  }

  Future<List<GithubUserWithScore>> _getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _currentSuggestions = [];
        _selectedIndex = -1;
      });
      return [];
    }

    await ref.read(githubUsersNotifierProvider.notifier).searchUsers(query);
    final suggestions = ref
        .read(githubUsersNotifierProvider)
        .when(
          data: (users) => users,
          loading: () => <GithubUserWithScore>[],
          error: (_, __) => <GithubUserWithScore>[],
        );

    setState(() {
      _currentSuggestions = suggestions;
      _selectedIndex = -1;
    });

    return suggestions;
  }

  void _onSuggestionSelected(GithubUserWithScore user) {
    _searchController.clear();
    setState(() {
      _currentSuggestions = [];
      _selectedIndex = -1;
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserDetailsPage(user: user)),
    );
  }

  Widget _buildSuggestionItem(
    BuildContext context,
    GithubUserWithScore user,
    int index,
  ) {
    return UserSuggestionItem(user: user, isSelected: index == _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(githubUsersNotifierProvider).isLoading;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Focus(
            focusNode: _textFieldFocusNode,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent && _currentSuggestions.isNotEmpty) {
                switch (event.logicalKey) {
                  case LogicalKeyboardKey.arrowDown:
                    setState(() {
                      _selectedIndex =
                          (_selectedIndex + 1) % _currentSuggestions.length;
                    });
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.arrowUp:
                    setState(() {
                      _selectedIndex = _selectedIndex <= 0
                          ? _currentSuggestions.length - 1
                          : _selectedIndex - 1;
                    });
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.enter:
                    if (_selectedIndex >= 0 &&
                        _selectedIndex < _currentSuggestions.length) {
                      _onSuggestionSelected(
                        _currentSuggestions[_selectedIndex],
                      );
                      return KeyEventResult.handled;
                    }
                    break;
                }
              }
              return KeyEventResult.ignored;
            },
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
                onChanged: (value) {
                  // Reset selection when text changes
                  setState(() {
                    _selectedIndex = -1;
                  });
                },
              ),
              suggestionsCallback: _getSuggestions,
              itemBuilder: (context, user) {
                final index = _currentSuggestions.indexOf(user);
                return _buildSuggestionItem(context, user, index);
              },
              onSelected: _onSuggestionSelected,
              debounceDuration: AppConstants.searchDebounceDuration,
              // Enhanced keyboard navigation settings
              animationDuration: const Duration(milliseconds: 200),
              // Ensure suggestions are shown when typing
              hideOnLoading: false,
              hideOnEmpty: false,
              hideOnError: false,
            ),
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
                  SizedBox(height: 8),
                  Text(
                    'Use arrow keys to navigate suggestions',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
