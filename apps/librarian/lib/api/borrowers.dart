part of 'api.dart';

Future<Response> fetchBorrower(String id) async {
  return await DioClient.instance.get('/borrowers/$id');
}

Future<Response> fetchBorrowers() async {
  return await DioClient.instance.get('/borrowers');
}

Future<Response> updateBorrower(
  String id, {
  String? email,
  String? phone,
}) async {
  dynamic data = {};

  if (email != null) {
    data['email'] = email;
  }

  if (phone != null) {
    data['phone'] = phone;
  }

  return await DioClient.instance.patch('/borrowers/$id/contact', data: data);
}
