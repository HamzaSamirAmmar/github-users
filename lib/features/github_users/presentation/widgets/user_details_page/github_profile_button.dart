import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';

class GithubProfileButton extends StatelessWidget {
  final GithubUserWithScore user;

  const GithubProfileButton({super.key, required this.user});

  Future<void> _openGithubProfile() async {
    final Uri url = Uri.parse(user.htmlUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _openGithubProfile,
          icon: const Icon(Icons.open_in_new, size: 20),
          label: const Text(
            'Open GitHub Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }
}
