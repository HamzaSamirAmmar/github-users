import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:github_users/core/constants/app_constants.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/presentation/pages/user_details_page.dart';
import 'package:github_users/features/github_users/presentation/providers/github_users_providers.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_users_page/empty_state.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_users_page/search_field.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_users_page/suggestion_item_wrapper.dart';

class GithubUsersSearchBar extends ConsumerStatefulWidget {
  const GithubUsersSearchBar({super.key});

  @override
  ConsumerState<GithubUsersSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<GithubUsersSearchBar> {
  static const Duration _animationDuration = Duration(milliseconds: 200);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  int _selectedIndex = -1;
  List<GithubUserWithScore> _currentSuggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _resetSelection();
    }
  }

  void _resetSelection() {
    setState(() => _selectedIndex = -1);
  }

  void _resetState() {
    setState(() {
      _currentSuggestions = [];
      _selectedIndex = -1;
    });
  }

  Future<List<GithubUserWithScore>> _getSuggestions(String query) async {
    if (query.isEmpty) {
      _resetState();
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
    _resetState();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserDetailsPage(user: user)),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _currentSuggestions.isEmpty) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % _currentSuggestions.length;
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
          _onSuggestionSelected(_currentSuggestions[_selectedIndex]);
          return KeyEventResult.handled;
        }
        break;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Focus(
            focusNode: _focusNode,
            onKeyEvent: _handleKeyEvent,
            child: TypeAheadField<GithubUserWithScore>(
              controller: _searchController,
              builder: (context, controller, focusNode) => SearchField(
                controller: controller,
                focusNode: focusNode,
                onChanged: _resetSelection,
              ),
              suggestionsCallback: _getSuggestions,
              itemBuilder: (context, user) => SuggestionItemWrapper(
                user: user,
                selectedIndex: _selectedIndex,
                currentSuggestions: _currentSuggestions,
              ),
              onSelected: _onSuggestionSelected,
              debounceDuration: AppConstants.searchDebounceDuration,
              animationDuration: _animationDuration,
              hideOnLoading: false,
              hideOnEmpty: false,
              hideOnError: false,
            ),
          ),
        ),
        if (_searchController.text.isEmpty) const EmptyState(),
      ],
    );
  }
}
