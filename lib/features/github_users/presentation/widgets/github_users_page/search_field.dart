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
  static const double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(githubUsersNotifierProvider).isLoading;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'Search GitHub users...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(_padding),
                child: SizedBox(
                  width: _iconSize,
                  height: _iconSize,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (_) => onChanged(),
    );
  }
}
