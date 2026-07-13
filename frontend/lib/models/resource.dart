class Resource {
  final String id;
  final String type;
  final String name;
  final int capacity;
  final String? color;
  final bool active;

  Resource({
    required this.id,
    required this.type,
    required this.name,
    required this.capacity,
    this.color,
    required this.active,
  });
}
