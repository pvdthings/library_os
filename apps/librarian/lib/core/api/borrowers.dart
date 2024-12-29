part of 'api.dart';

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
