class ItemSummaryModel {
  final String id;
  final String name;
  final int number;
  final List<String> images;
  final String? lastLoanId;

  const ItemSummaryModel({
    required this.id,
    required this.name,
    required this.number,
    required this.images,
    this.lastLoanId,
  });

  factory ItemSummaryModel.fromQuery(Map<String, dynamic> data) {
    return ItemSummaryModel(
      id: data['id'].toString(),
      name: data['name'] as String,
      number: data['number'] as int,
      images: [],
      lastLoanId: null, // TODO
    );
  }
}
