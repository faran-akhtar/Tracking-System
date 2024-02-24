import 'package:dio/dio.dart';
import '../../../../sdk_export.dart';
import '../../../../../utils/utils_export.dart';

const googleApiKey = "AIzaSyAxY4CAApKqTGc4EnqvT8-MDGvRaJdDod0";

class UserApi {
  UserApi({
    this.dioBase,
  }) {
    dioBase ??= DioBase(
      options: BaseOptions(),
    );
  }

  DioBase? dioBase;

  Future<dynamic> getLocationDetails({
    required double originLat,
    required double originLong,
    required double destLat,
    required double destLong
  }) async {
    try {
      var response = await dioBase?.get(
        '/api/directions/json?origin=$originLat,$originLong&destination=$destLat,$destLong&key=$googleApiKey',
      );

      if (response != null) {
        return response;
      } else {
        throw NetworkException(
          'No response data from server',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
