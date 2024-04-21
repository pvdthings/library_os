import 'package:dio/dio.dart';
import 'package:librarian_app/src/api/dio_client.dart';

class LendingApi {
  static Future<Response> getCategories() async {
    return await DioClient.instance.get('/things/categories');
  }

  static Future<Response> fetchLoans() async {
    return await DioClient.instance.get('/loans');
  }

  static Future<Response> fetchLoan({
    required String id,
    required String thingId,
  }) async {
    return await DioClient.instance.get('/loans/$id/$thingId');
  }

  static Future<Response> createLoan(NewLoan data) async {
    return await DioClient.instance.put('/loans', data: {
      'borrowerId': data.borrowerId,
      'thingIds': data.thingIds,
      'checkedOutDate': data.checkedOutDate,
      'dueBackDate': data.dueBackDate
    });
  }

  static Future<Response> updateLoan(UpdatedLoan loanData) async {
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

  static Future<Response> fetchBorrower(String id) async {
    return await DioClient.instance.get('/borrowers/$id');
  }

  static Future<Response> fetchBorrowers() async {
    return await DioClient.instance.get('/borrowers');
  }

  static Future<Response> updateBorrower(
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

  static Future<Response> fetchThings() async {
    return await DioClient.instance.get('/things');
  }

  static Future<Response> fetchThing({required String id}) async {
    return await DioClient.instance.get('/things/$id');
  }

  static Future<Response> createThing({
    required String name,
    String? spanishName,
  }) async {
    return await DioClient.instance.put('/things', data: {
      'name': name,
      'spanishName': spanishName,
    });
  }

  static Future<Response> updateThing(
    String thingId, {
    String? name,
    String? spanishName,
    bool? hidden,
    bool? eyeProtection,
    ImageDTO? image,
  }) async {
    return await DioClient.instance.patch('/things/$thingId', data: {
      'name': name,
      'spanishName': spanishName,
      'hidden': hidden,
      'eyeProtection': eyeProtection,
      'image': image != null ? {'url': image.url} : null,
    });
  }

  static Future<Response> deleteThing(String id) async {
    return await DioClient.instance.delete('/things/$id');
  }

  static Future<Response> updateThingCategories(
    String id, {
    required List<String> categories,
  }) async {
    return await DioClient.instance.patch('/things/$id/categories', data: {
      'categories': categories,
    });
  }

  static Future<Response> deleteThingImage(String thingId) async {
    return await DioClient.instance.delete('/things/$thingId/image');
  }

  static Future<Response> fetchInventoryItem({required int number}) async {
    return await DioClient.instance.get('/inventory/$number');
  }

  static Future<Response> createInventoryItems(
    String thingId, {
    required int quantity,
    required String? brand,
    String? condition,
    required String? description,
    required double? estimatedValue,
    bool? hidden,
    ImageDTO? image,
    List<ImageDTO>? manuals,
  }) async {
    return await DioClient.instance.put('/inventory', data: {
      'thingId': thingId,
      'quantity': quantity,
      'brand': brand,
      'condition': condition,
      'description': description,
      'estimatedValue': estimatedValue,
      'hidden': hidden,
      'image': {
        'url': image?.url,
      },
      'manuals':
          manuals?.map((m) => {'url': m.url, 'filename': m.name}).toList(),
    });
  }

  static Future<Response> updateInventoryItem(
    String id, {
    String? brand,
    String? condition,
    String? description,
    double? estimatedValue,
    bool? hidden,
    ImageDTO? image,
    List<ImageDTO>? manuals,
  }) async {
    return await DioClient.instance.patch('/inventory/$id', data: {
      'brand': brand,
      'condition': condition,
      'description': description,
      'estimatedValue': estimatedValue,
      'hidden': hidden,
      'image': image != null ? {'url': image.url} : null,
      'manuals':
          manuals?.map((m) => {'url': m.url, 'filename': m.name}).toList(),
    });
  }

  static Future<Response> deleteInventoryItem(String id) async {
    return await DioClient.instance.delete('/inventory/$id');
  }

  static Future<Response> fetchPayments({
    required String borrowerId,
  }) async {
    return await DioClient.instance.get('/payments/$borrowerId');
  }

  static Future<Response> recordCashPayment({
    required double cash,
    required String borrowerId,
  }) async {
    return await DioClient.instance.put('/payments/$borrowerId', data: {
      'cash': cash,
    });
  }

  static Future<Response> sendReminderEmail({required int loanNumber}) async {
    return await DioClient.instance.post('/messages/loan-reminder', data: {
      'loanNumber': loanNumber,
    });
  }
}

class ImageDTO {
  final String? name;
  final String? url;

  const ImageDTO({required this.url, this.name});
}

class NewLoan {
  String borrowerId;
  List<String> thingIds;
  String checkedOutDate;
  String dueBackDate;
  String? notes;

  NewLoan({
    required this.borrowerId,
    required this.thingIds,
    required this.checkedOutDate,
    required this.dueBackDate,
    this.notes,
  });
}

class UpdatedLoan {
  String loanId;
  String thingId;
  String? dueBackDate;
  String? checkedInDate;
  String? notes;

  UpdatedLoan({
    required this.loanId,
    required this.thingId,
    this.dueBackDate,
    this.checkedInDate,
    this.notes,
  });
}
