import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../../sdk_export.dart';
import '../../../../utils/utils_export.dart';

class DioBase extends HTTPConfig implements HTTP {
  BaseOptions options;
  late Dio dio;

  DioBase({
    required this.options,
  }) : super(options) {
    dio = Dio(options);

    // //TODO: onHttpClientCreate is deprecated and shouldn't be used.
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  @override
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await dio.get(
        url,
        queryParameters: queryParameters,
      );
      return _handleDioResponse(response);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(
        e,
      );
      throw NetworkException(
        errorMessage,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleDioResponse(response);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(
        e,
      );
      throw NetworkException(
        errorMessage,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleDioResponse(response);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(
        e,
      );
      throw NetworkException(
        errorMessage,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleDioResponse(response);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(
        e,
      );
      throw NetworkException(
        errorMessage,
      );
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleDioResponse(
    Response response,
  ) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          if (response.data is String) {
            return jsonDecode(response.data);
          }
        } catch (_) {}
        return response.data;
      default:
        throw NetworkException(
          'Error occurred: ${response.statusCode}',
        );
    }
  }

  String _handleDioError(
    DioException e,
  ) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Sent timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badCertificate:
        return 'Bad certificate';
      case DioExceptionType.badResponse:
        return 'Bad response';
      case DioExceptionType.cancel:
        return 'Cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.unknown:
        return 'Unknown error';
    }
  }
}
