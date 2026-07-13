import 'workspace.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String status;
  final List<Workspace> workspaces;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    this.workspaces = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'] ?? 'ACTIVE',
      workspaces: (json['workspaces'] as List?)?.map((w) => Workspace.fromJson(w)).toList() ?? [],
    );
  }
}
