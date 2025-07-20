import 'package:flutter/material.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';

class UserSuggestionItem extends StatelessWidget {
  final GithubUserWithScore user;
  final bool isSelected;

  const UserSuggestionItem({
    super.key,
    required this.user,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(user.avatarUrl),
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image loading error silently
          },
        ),
        title: Text(
          user.login,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected ? Colors.blue[800] : null,
          ),
        ),
        subtitle: Row(
          children: [
            // Score
            if (user.score > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Score: ${user.score}',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // 50+ repos indicator
            if (user.publicRepos >= 50)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '50+ repos',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Add a subtle border when selected
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected
              ? BorderSide(color: Colors.blue.withOpacity(0.3), width: 1)
              : BorderSide.none,
        ),
      ),
    );
  }
}
