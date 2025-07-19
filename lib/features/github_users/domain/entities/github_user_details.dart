import 'package:github_users/features/github_users/domain/entities/github_user.dart';

class GithubUserDetails extends GithubUser {
  final int publicRepos;
  final DateTime? updatedAt;

  const GithubUserDetails({
    required super.id,
    required super.login,
    required super.avatarUrl,
    required super.htmlUrl,
    required this.publicRepos,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [...super.props, publicRepos, updatedAt];
}
