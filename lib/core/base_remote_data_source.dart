import 'package:dio/dio.dart';
import 'package:github_users/core/exception.dart';
import 'package:github_users/core/dio_client.dart';

class BaseRemoteDataSource {
  final DioService dioService;

  BaseRemoteDataSource(this.dioService);

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dioService.get(
        url,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Unexpected error');
    }
  }
}
