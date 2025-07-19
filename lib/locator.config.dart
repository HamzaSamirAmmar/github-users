// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:github_users/core/dio_client.dart' as _i959;
import 'package:github_users/features/github_users/data/data_sources/remote/github_remote_data_source.dart'
    as _i543;
import 'package:github_users/features/github_users/data/repositories/github_repository_imp.dart'
    as _i1033;
import 'package:github_users/features/github_users/domain/repositories/github_users_repository.dart'
    as _i230;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioClient = _$DioClient();
    gh.singleton<_i959.DioService>(() => dioClient.createDioClient());
    gh.lazySingleton<_i543.GithubRemoteDataSource>(
      () => _i543.GithubRemoteDataSource(dioService: gh<_i959.DioService>()),
    );
    gh.lazySingleton<_i230.GithubUsersRepository>(
      () => _i1033.GithubRepositoryImp(
        githubRemoteDataSource: gh<_i543.GithubRemoteDataSource>(),
      ),
    );
    return this;
  }
}

class _$DioClient extends _i959.DioClient {}
