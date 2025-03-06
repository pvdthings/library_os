class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.date,
  });

  final String id;
  final DateTime date;

  factory PaymentModel.fromQuery(Map<String, dynamic> data) {
    return PaymentModel(
      id: data['id'].toString(),
      date: DateTime.parse(data['created_at'] as String),
    );
  }
}
