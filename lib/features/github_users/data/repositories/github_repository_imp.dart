import 'package:github_users/features/github_users/domain/repositories/github_users_repository.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:github_users/core/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:github_users/features/github_users/data/data_sources/remote/github_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GithubUsersRepository)
class GithubRepositoryImp extends GithubUsersRepository {
  final GithubRemoteDataSource githubRemoteDataSource;

  GithubRepositoryImp({required this.githubRemoteDataSource});

  @override
  Future<Either<Failure, List<GithubUser>>> getGithubUsers() async {
    try {
      final users = await githubRemoteDataSource.getGithubUsers();
      return Right(users);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
