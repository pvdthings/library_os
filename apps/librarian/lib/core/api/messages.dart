part of 'api.dart';

Future<Response> sendReminderEmail({required int loanNumber}) async {
  return await DioClient.instance.post('/messages/loan-reminder', data: {
    'loanNumber': loanNumber,
  });
}
