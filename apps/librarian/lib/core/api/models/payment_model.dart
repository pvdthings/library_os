class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.cash,
    required this.date,
  });

  final String id;
  final double? cash;
  final DateTime date;

  factory PaymentModel.fromQuery(Map<String, dynamic> data) {
    return PaymentModel(
      id: data['id'].toString(),
      cash: data['cash'] as double,
      date: DateTime.parse(data['created_at'] as String),
    );
  }
}
