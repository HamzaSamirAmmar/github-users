import 'package:dartz/dartz.dart';
import 'package:github_users/core/data/base_repository.dart';
import 'package:github_users/core/errors/failure.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_details.dart';

abstract class GithubUsersRepository extends BaseRepository {
  /// Get basic user information from search results
  Future<Either<Failure, List<GithubUser>>> getGithubUsers({String query = ''});

  /// Get detailed user information (without sorting)
  Future<Either<Failure, List<GithubUserDetails>>> getDetailedUsers(
    List<GithubUser> users,
  );
}
