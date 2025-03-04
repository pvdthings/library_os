part of 'api.dart';

Future<Response> fetchPayments({
  required String borrowerId,
}) async {
  return await DioClient.instance.get('/payments/$borrowerId');
}

Future<Response> recordCashPayment({
  required String borrowerId,
}) async {
  return await DioClient.instance.put('/payments/$borrowerId');
}
