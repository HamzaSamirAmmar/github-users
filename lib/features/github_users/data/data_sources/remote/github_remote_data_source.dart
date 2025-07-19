import 'package:github_users/features/github_users/data/models/github_user_details_model.dart';
import 'package:github_users/features/github_users/data/models/github_user_model.dart';

abstract class GithubRemoteDataSource {
  Future<List<GithubUserModel>> getGithubUsers({String query = ''});
  Future<GithubUserDetailsModel> getUserDetails(String username);
}
