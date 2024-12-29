part of 'api.dart';

Future<Response> createLoan(NewLoan data) async {
  return await DioClient.instance.put('/loans', data: {
    'borrowerId': data.borrowerId,
    'thingIds': data.thingIds,
    'checkedOutDate': data.checkedOutDate,
    'dueBackDate': data.dueBackDate
  });
}

Future<Response> updateLoan(UpdatedLoan loanData) async {
  dynamic data = {
    'checkedInDate': loanData.checkedInDate,
    'dueBackDate': loanData.dueBackDate,
  };

  if (loanData.notes != null) {
    data['notes'] = loanData.notes;
  }

  return await DioClient.instance
      .patch('/loans/${loanData.loanId}/${loanData.thingId}', data: data);
}

Future<Response> extendAuthorization() async {
  return await DioClient.instance.head('/loans/extend');
}

Future<Response> extend({required String dueDate}) async {
  return await DioClient.instance.post('/loans/extend', data: {
    'dueDate': dueDate,
  });
}
