import 'package:github_users/core/data/base_repository.dart';
import 'package:github_users/features/github_users/domain/repositories/github_users_repository.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_details.dart';
import 'package:github_users/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:github_users/features/github_users/data/data_sources/remote/github_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GithubUsersRepository)
class GithubRepositoryImp extends BaseRepositoryImp implements GithubUsersRepository   {
  final GithubRemoteDataSource githubRemoteDataSource;

  GithubRepositoryImp({required this.githubRemoteDataSource});

  @override
  Future<Either<Failure, List<GithubUser>>> getGithubUsers({
    String query = '',
  }) => performRemoteRequest(() => githubRemoteDataSource.getGithubUsers(query: query));

  @override
  Future<Either<Failure, List<GithubUserDetails>>> getDetailedUsers(
    List<GithubUser> users,
  ) => performRemoteRequest(() => githubRemoteDataSource.getDetailedUsers(users));
}
