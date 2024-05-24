import 'package:dio/dio.dart';

import 'dio_client.dart';

class LoansApi {
  static Future<Response> extendAuthorization() async {
    return await DioClient.instance.head('/loans/extend');
  }

  static Future<Response> extend({required String dueDate}) async {
    return await DioClient.instance.post('/loans/extend', data: {
      'dueDate': dueDate,
    });
  }
}
