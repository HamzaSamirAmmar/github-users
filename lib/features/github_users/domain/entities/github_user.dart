import 'package:equatable/equatable.dart';

class GithubUser extends Equatable {
  final int id;
  final String login;
  final String avatarUrl;
  final String htmlUrl;

  const GithubUser({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  @override
  List<Object?> get props => [id, login, avatarUrl, htmlUrl];
}
