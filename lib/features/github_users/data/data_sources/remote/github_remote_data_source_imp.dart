import 'package:github_users/core/data/base_remote_data_source.dart';
import 'package:github_users/core/constants/app_constants.dart';
import 'package:github_users/features/github_users/data/models/github_user_model.dart';
import 'package:github_users/features/github_users/data/models/github_user_details_model.dart';
import 'package:github_users/features/github_users/data/data_sources/remote/github_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GithubRemoteDataSource)
class GithubRemoteDataSourceImp extends BaseRemoteDataSourceImp
    implements GithubRemoteDataSource {
  GithubRemoteDataSourceImp(super.dioService);

  @override
  Future<List<GithubUserModel>> getGithubUsers({String query = ''}) async =>
      await performGetListRequest<GithubUserModel>(
        AppConstants.searchUsersEndpoint,
        queryParameters: {
          if (query.isNotEmpty) 'q': query,
          'per_page': AppConstants.defaultPerPage,
        },
        fromJsonFactory: (json) => GithubUserModel.fromJson(json),
      );

  @override
  Future<GithubUserDetailsModel> getUserDetails(
    String username,
  ) async => await performGetRequest<GithubUserDetailsModel>(
        '${AppConstants.usersEndpoint}/$username',
        fromJsonFactory: (json) => GithubUserDetailsModel.fromJson(json),
      );
}
