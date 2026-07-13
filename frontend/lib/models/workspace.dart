class Workspace {
  final String id;
  final String name;
  final String? legalName;
  final String? document;
  final String? email;
  final String? phone;
  final String? logo;
  final String timezone;
  final String status;
  final DateTime createdAt;

  Workspace({
    required this.id,
    required this.name,
    this.legalName,
    this.document,
    this.email,
    this.phone,
    this.logo,
    required this.timezone,
    required this.status,
    required this.createdAt,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'],
      name: json['name'],
      legalName: json['legalName'],
      document: json['document'],
      email: json['email'],
      phone: json['phone'],
      logo: json['logo'],
      timezone: json['timezone'] ?? 'America/Sao_Paulo',
      status: json['status'] ?? 'ACTIVE',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
