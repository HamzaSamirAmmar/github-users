import 'package:github_users/features/github_users/domain/entities/github_user_details.dart';

class GithubUserWithScore extends GithubUserDetails {
  final int score;

  const GithubUserWithScore({
    required super.id,
    required super.login,
    required super.avatarUrl,
    required super.htmlUrl,
    required super.publicRepos,
    super.updatedAt,
    required this.score,
  });

  @override
  List<Object?> get props => [...super.props, score];

  // Factory method to create from GithubUserDetails with score
  factory GithubUserWithScore.fromDetails(
    GithubUserDetails details,
    int score,
  ) {
    return GithubUserWithScore(
      id: details.id,
      login: details.login,
      avatarUrl: details.avatarUrl,
      htmlUrl: details.htmlUrl,
      publicRepos: details.publicRepos,
      updatedAt: details.updatedAt,
      score: score,
    );
  }
}
