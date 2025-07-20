import 'package:flutter/material.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';
import 'package:github_users/features/github_users/presentation/widgets/user_details_page/github_profile_button.dart';
import 'package:github_users/features/github_users/presentation/widgets/user_details_page/user_last_updated_card.dart';
import 'package:github_users/features/github_users/presentation/widgets/user_details_page/user_profile_header.dart';
import 'package:github_users/features/github_users/presentation/widgets/user_details_page/user_stats_section.dart';

class UserDetailsPage extends StatelessWidget {
  final GithubUserWithScore user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              UserProfileHeader(user: user),
              const SizedBox(height: 24),
              UserStatsSection(user: user),
              const SizedBox(height: 24),
              GithubProfileButton(user: user),
              const SizedBox(height: 24),
              UserLastUpdatedCard(user: user),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.login,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      titleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
