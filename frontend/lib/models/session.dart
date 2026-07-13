class Session {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String professionalName;
  final String clientName;

  Session({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.professionalName,
    required this.clientName,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    final sessionDate = DateTime.parse(json['sessionDate']);
    final startMinute = json['startMinute'] as int;
    final endMinute = json['endMinute'] as int;
    
    final startTime = sessionDate.add(Duration(minutes: startMinute));
    final endTime = sessionDate.add(Duration(minutes: endMinute));

    String cName = 'Paciente';
    if (json['attendances'] != null && json['attendances'].isNotEmpty) {
      cName = json['attendances'][0]['person']?['name'] ?? 'Paciente';
    }

    return Session(
      id: json['id'] ?? '',
      title: json['offering']?['name'] ?? 'Atendimento',
      startTime: startTime,
      endTime: endTime,
      status: json['status'] ?? 'SCHEDULED',
      professionalName: json['professional']?['name'] ?? 'Fisioterapeuta',
      clientName: cName,
    );
  }
}
