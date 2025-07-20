import 'package:flutter/material.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/presentation/widgets/user_details_page/user_stats_card.dart';

class UserStatsSection extends StatelessWidget {
  final GithubUserWithScore user;

  const UserStatsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Public Repos Card
        Expanded(
          child: UserStatsCard(
            icon: Icons.folder,
            title: 'Public Repos',
            value: user.publicRepos.toString(),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 16),

        // Score Card
        Expanded(
          child: UserStatsCard(
            icon: Icons.star,
            title: 'Search Score',
            value: user.score.toString(),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}
