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
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        user.login,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
      titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
