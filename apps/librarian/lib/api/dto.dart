part of 'api.dart';

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
