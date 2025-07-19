import 'package:github_users/core/constants/app_constants.dart';
import 'package:github_users/core/data/base_remote_data_source.dart';
import 'package:github_users/features/github_users/data/models/github_user_model.dart';
import 'package:github_users/features/github_users/data/models/github_user_details_model.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:github_users/features/github_users/domain/entities/github_user_details.dart';
import 'package:injectable/injectable.dart';

abstract class IGithubRemoteDataSource {
  Future<List<GithubUser>> getGithubUsers({String query = ''});
  Future<List<GithubUserDetails>> getDetailedUsers(List<GithubUser> users);
}

@LazySingleton()
class GithubRemoteDataSource extends BaseRemoteDataSourceImp
    implements IGithubRemoteDataSource {
  GithubRemoteDataSource(super.dioService);

  @override
  Future<List<GithubUser>> getGithubUsers({String query = ''}) async =>
      await performGetListRequest<GithubUserModel>(
        AppConstants.searchUsersEndpoint,
        queryParameters: {
          if (query.isNotEmpty) 'q': query,
          'per_page': AppConstants.defaultPerPage,
        },
        fromJsonFactory: (json) => GithubUserModel.fromJson(json),
      );

  /// Fetches detailed information for a list of users
  @override
  Future<List<GithubUserDetails>> getDetailedUsers(
    List<GithubUser> users,
  ) async {
    try {
      final List<GithubUserDetails> detailedUsers = [];

      // Fetch detailed information for each user concurrently
      final futures = users.map((user) => _fetchUserDetails(user.login));
      final results = await Future.wait(futures);

      // Filter out any failed requests and create detailed user models
      for (int i = 0; i < results.length; i++) {
        if (results[i] != null) {
          detailedUsers.add(results[i]!);
        }
      }

      return detailedUsers;
    } catch (e) {
      // If detailed fetching fails, return empty list
      return [];
    }
  }

  /// Fetches detailed information for a specific user
  Future<GithubUserDetails?> _fetchUserDetails(String username) async =>
      await performGetRequest<GithubUserDetailsModel>(
        '${AppConstants.usersEndpoint}/$username',
        fromJsonFactory: (json) => GithubUserDetailsModel.fromJson(json),
      );
}
