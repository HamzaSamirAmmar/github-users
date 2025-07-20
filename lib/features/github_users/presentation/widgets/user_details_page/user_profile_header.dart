import 'package:flutter/material.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';

class UserProfileHeader extends StatelessWidget {
  final GithubUserWithScore user;

  const UserProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildAvatar(context),
            const SizedBox(height: 20),
            _buildUserInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          user.avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.outline,
              child: Icon(
                Icons.person,
                size: 60,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          user.login,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'ID: ${user.id}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
