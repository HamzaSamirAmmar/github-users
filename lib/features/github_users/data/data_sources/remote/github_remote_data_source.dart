import 'package:github_users/core/dio_client.dart';
import 'package:github_users/features/github_users/data/models/github_user_model.dart';
import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GithubRemoteDataSource {
  final DioService dioService;

  GithubRemoteDataSource({required this.dioService});

  Future<List<GithubUser>> getGithubUsers() async {
    try {
      final response = await dioService.get('/users');
      final List<dynamic> data = response.data;
      return data.map((e) => GithubUserModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch GitHub users: $e');
    }
  }
}
