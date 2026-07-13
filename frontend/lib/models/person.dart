class Person {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? crefito;
  final bool active;

  Person({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.crefito,
    required this.active,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      crefito: json['professional']?['crefito'],
      active: json['active'] ?? true,
    );
  }
}
