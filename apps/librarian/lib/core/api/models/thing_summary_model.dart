class ThingSummaryModel {
  final String id;
  final String name;
  final int number;
  final List<String> images;
  final String? lastLoanId;

  const ThingSummaryModel({
    required this.id,
    required this.name,
    required this.number,
    required this.images,
    this.lastLoanId,
  });

  factory ThingSummaryModel.fromJson(Map<String, dynamic> json) {
    return ThingSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as int,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      lastLoanId: json['lastLoanId'] as String?,
    );
  }
}
