import 'package:dio/dio.dart';

class HTTPConfig {
  static const connectTimeout = 24000;
  static const receiveTimeout = 120000;
  static const sendTimeout = 60000;
  static const baseURL = 'https://maps.googleapis.com/maps';

  HTTPConfig(
    BaseOptions options,
  ) {
    options.baseUrl = _getBaseURL();
    options.connectTimeout = const Duration(milliseconds: connectTimeout);
    options.receiveTimeout = const Duration(milliseconds: receiveTimeout);
    options.sendTimeout = const Duration(milliseconds: sendTimeout);
  }

  String _getBaseURL() {
    return baseURL;
  }
}
