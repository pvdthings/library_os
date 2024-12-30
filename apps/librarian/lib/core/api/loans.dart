part of 'api.dart';

Future<Response> extendAuthorization() async {
  return await DioClient.instance.head('/loans/extend');
}

Future<Response> extend({required String dueDate}) async {
  return await DioClient.instance.post('/loans/extend', data: {
    'dueDate': dueDate,
  });
}
