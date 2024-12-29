part of 'api.dart';

Future<Response> recordCashPayment({
  required double cash,
  required String borrowerId,
}) async {
  return await DioClient.instance.put('/payments/$borrowerId', data: {
    'cash': cash,
  });
}
