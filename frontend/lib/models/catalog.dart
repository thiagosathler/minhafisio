class Offering {
  final String id;
  final String serviceId;
  final String name;
  final String mode;
  final int durationMinutes;
  final int capacity;
  final double? defaultPrice;

  Offering({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.mode,
    required this.durationMinutes,
    required this.capacity,
    this.defaultPrice,
  });

  factory Offering.fromJson(Map<String, dynamic> json) {
    return Offering(
      id: json['id'],
      serviceId: json['serviceId'],
      name: json['name'],
      mode: json['mode'],
      durationMinutes: json['durationMinutes'],
      capacity: json['capacity'] ?? 1,
      defaultPrice: json['defaultPrice'] != null ? (json['defaultPrice'] as num).toDouble() : null,
    );
  }
}

class ServiceCategory {
  final String id;
  final String workspaceId;
  final String name;
  final String? color;
  final List<Offering> offerings;

  ServiceCategory({
    required this.id,
    required this.workspaceId,
    required this.name,
    this.color,
    required this.offerings,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'],
      workspaceId: json['workspaceId'],
      name: json['name'],
      color: json['color'],
      offerings: (json['offerings'] as List?)?.map((o) => Offering.fromJson(o)).toList() ?? [],
    );
  }
}
