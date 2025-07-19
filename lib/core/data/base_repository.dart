import 'package:dartz/dartz.dart';
import 'package:github_users/core/errors/failure.dart';

typedef FutureEitherOr<T> = Future<Either<Failure, T>> Function();
typedef RequestBody<T> = Future<T> Function();

abstract class BaseRepository {
  Future<Either<Failure, T>> performRemoteRequest<T>(RequestBody<T> body);
}

class BaseRepositoryImp implements BaseRepository {
  // Here we can add and inject any dependencies we need
  // ex: NetworkInfo, LocalDataSource, etc.
  // we can check internet connection using networkInfo and if not connected, try to get data from localDataSource
  BaseRepositoryImp();

  @override
  Future<Either<Failure, T>> performRemoteRequest<T>(
    RequestBody<T> body,
  ) async {
    try {
      final result = await body();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
