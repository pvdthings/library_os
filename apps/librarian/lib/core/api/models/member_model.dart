import 'issue_model.dart';

class MemberModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Issue> issues;
  final DateTime? joinDate;
  final bool keyholder;
  final int volunteerHours;

  bool get active => issues.isEmpty;

  const MemberModel({
    required this.id,
    required this.name,
    required this.issues,
    this.email,
    this.joinDate,
    this.keyholder = false,
    this.phone,
    this.volunteerHours = 0,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String? ?? '???',
      name: json['name'] as String? ?? '???',
      email: json['contact']?['email'] as String?,
      phone: json['contact']?['phone'] as String?,
      issues: (json['issues'] as List? ?? [])
          .map((code) => Issue.fromCode(code))
          .toList(),
      joinDate: DateTime.tryParse(json['joinDate'] ?? ''),
      keyholder: json['keyholder'] as bool,
      volunteerHours: json['volunteerHours'] as int,
    );
  }

  factory MemberModel.fromQuery(Map<String, dynamic> data) {
    return MemberModel(
      id: data['id'].toString(),
      name: data['name'] as String,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      issues: [], // TODO
      joinDate: DateTime.tryParse(data['join_date']),
      keyholder: data['keyholder'] as bool,
      volunteerHours: 0, // TODO
    );
  }
}
