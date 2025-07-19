import 'package:dio/dio.dart';
import 'package:github_users/core/constants/app_constants.dart';
import 'package:injectable/injectable.dart';

class DioService {
  final Dio dio;

  Dio get dioInstance => dio;

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(url, queryParameters: queryParameters);
  }

  DioService({required this.dio}) {
    dio.options.baseUrl = 'https://api.github.com';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}

@module
abstract class DioClient {
  @singleton
  DioService createDioClient() {
    final dio = Dio();
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    return DioService(dio: dio);
  }
}
