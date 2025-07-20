import 'package:flutter/material.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_with_score.dart';

class UserLastUpdatedCard extends StatelessWidget {
  final GithubUserWithScore user;

  const UserLastUpdatedCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.updatedAt == null) return const SizedBox.shrink();

    return Card(
      elevation: 1,
      shadowColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildDateText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.update, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
        const SizedBox(width: 8),
        Text(
          'Last Updated',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDateText(BuildContext context) {
    return Text(
      _formatDate(user.updatedAt!),
      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
