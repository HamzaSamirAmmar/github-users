import 'package:dartz/dartz.dart';
import 'package:github_users/core/errors/exception.dart';
import 'package:github_users/core/errors/failure.dart';

typedef FutureEitherOr<T> = Future<Either<Failure, T>> Function();
typedef RequestBody<T> = Future<T> Function();

abstract class BaseRepository {
  Future<Either<Failure, T>> performRemoteRequest<T>(RequestBody<T> body);

  Future<Either<Failure, List<T>>> performMultipleRemoteRequests<T>(
    List<FutureEitherOr<T>> requests,
  );
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

  @override
  Future<Either<Failure, List<T>>> performMultipleRemoteRequests<T>(
    List<FutureEitherOr<T>> requests,
  ) async {
    try {
      List<T> results = [];
      for (final request in requests) {
        final result = await request();
        if (result.isRight()) {
          results.add(
            result.getOrElse(() => throw ServerException('Unexpected error')),
          );
        } else {
          return result.map((_) => <T>[]).leftMap((l) => l);
        }
      }
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
