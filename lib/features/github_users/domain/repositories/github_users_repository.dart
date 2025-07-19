import 'package:dartz/dartz.dart';
import 'package:github_users/core/failure.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';

abstract class GithubUsersRepository {
  Future<Either<Failure, List<GithubUser>>> getGithubUsers();
}
