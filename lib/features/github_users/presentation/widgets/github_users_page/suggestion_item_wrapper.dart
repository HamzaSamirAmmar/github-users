import 'package:flutter/material.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/presentation/widgets/github_users_page/user_suggestion_item.dart';

class SuggestionItemWrapper extends StatelessWidget {
  final GithubUserWithScore user;
  final int selectedIndex;
  final List<GithubUserWithScore> currentSuggestions;

  const SuggestionItemWrapper({
    super.key,
    required this.user,
    required this.selectedIndex,
    required this.currentSuggestions,
  });

  @override
  Widget build(BuildContext context) {
    final index = currentSuggestions.indexOf(user);
    return UserSuggestionItem(user: user, isSelected: index == selectedIndex);
  }
}
