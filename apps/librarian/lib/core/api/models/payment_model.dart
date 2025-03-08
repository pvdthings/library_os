class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.date,
  });

  final String id;
  final DateTime date;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
