import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/features/github_users/presentation/providers/github_users_providers.dart';

class SearchField extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  static const double _iconSize = 16.0;
  static const double _padding = 12.0;
  static const double _borderRadius = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(githubUsersNotifierProvider).isLoading;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: 'Search GitHub users...',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          suffixIcon: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(_padding),
                  child: SizedBox(
                    width: _iconSize,
                    height: _iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}
