import 'package:flutter/material.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:url_launcher/url_launcher.dart';

class GithubUserCard extends StatelessWidget {
  final GithubUser user;

  const GithubUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(user.avatarUrl),
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image loading error
          },
        ),
        title: Text(
          user.login,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'ID: ${user.id}',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () => _openUserProfile(user.htmlUrl),
          tooltip: 'Open GitHub Profile',
        ),
        onTap: () => _openUserProfile(user.htmlUrl),
      ),
    );
  }

  Future<void> _openUserProfile(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
