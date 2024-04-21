class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.cash,
    required this.date,
  });

  final String id;
  final double? cash;
  final DateTime date;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      cash: json['cash'] as double?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
