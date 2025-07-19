import 'package:dio/dio.dart';
import 'package:github_users/core/errors/exception.dart';
import 'package:github_users/core/network/dio_client.dart';

abstract class BaseRemoteDataSource {
  /// Get a single item of type T
  Future<T> performGetRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJsonFactory,
  });

  /// Get a list of items of type T
  Future<List<T>> performGetListRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJsonFactory,
  });
}

class BaseRemoteDataSourceImp implements BaseRemoteDataSource {
  final DioService dioService;

  BaseRemoteDataSourceImp(this.dioService);

  @override
  Future<T> performGetRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJsonFactory,
  }) async {
    try {
      final response = await dioService.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      return fromJsonFactory(response.data);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Unexpected error');
    } catch (e) {
      throw ServerException('Failed to parse response: $e');
    }
  }

  @override
  Future<List<T>> performGetListRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJsonFactory,
  }) async {
    try {
      final response = await dioService.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      // Handle both array and object with items property
      List<dynamic> dataList;
      if (response.data is List) {
        dataList = response.data;
      } else if (response.data is Map && response.data['items'] != null) {
        dataList = response.data['items'];
      } else {
        throw ServerException('Unexpected response format');
      }

      return dataList.map((item) => fromJsonFactory(item)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Unexpected error');
    } catch (e) {
      throw ServerException('Failed to parse response: $e');
    }
  }
}
