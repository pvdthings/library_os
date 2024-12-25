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

  factory ItemSummaryModel.fromJson(Map<String, dynamic> json) {
    return ItemSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as int,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      lastLoanId: json['lastLoanId'] as String?,
    );
  }

  factory ItemSummaryModel.fromQuery(Map<String, dynamic> data) {
    return ItemSummaryModel(
      id: data['id'].toString(),
      name: data['name'] as String,
      number: data['number'] as int,
      images: [], // TODO
      lastLoanId: data['id'].toString(), // TODO
    );
  }
}
