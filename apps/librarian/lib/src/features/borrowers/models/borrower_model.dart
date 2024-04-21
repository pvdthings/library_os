import 'issue_model.dart';

class BorrowerModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Issue> issues;

  bool get active => issues.isEmpty;

  BorrowerModel({
    required this.id,
    required this.name,
    required this.issues,
    this.email,
    this.phone,
  });

  factory BorrowerModel.fromJson(Map<String, dynamic> json) {
    return BorrowerModel(
      id: json['id'] as String? ?? '???',
      name: json['name'] as String? ?? '???',
      email: json['contact']?['email'] as String?,
      phone: json['contact']?['phone'] as String?,
      issues: (json['issues'] as List? ?? [])
          .map((code) => Issue.fromCode(code))
          .toList(),
    );
  }
}
