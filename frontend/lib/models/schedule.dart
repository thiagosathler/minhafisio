import 'person.dart';
import 'catalog.dart';

class Session {
  final String id;
  final String workspaceId;
  final String offeringId;
  final String professionalId;
  final DateTime sessionDate;
  final int startMinute;
  final int endMinute;
  final String status;
  final List<Attendance> attendances;
  final Offering? offering;
  final Person? professional;

  Session({
    required this.id,
    required this.workspaceId,
    required this.offeringId,
    required this.professionalId,
    required this.sessionDate,
    required this.startMinute,
    required this.endMinute,
    required this.status,
    required this.attendances,
    this.offering,
    this.professional,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      workspaceId: json['workspaceId'],
      offeringId: json['offeringId'],
      professionalId: json['professionalId'],
      sessionDate: DateTime.parse(json['sessionDate']),
      startMinute: json['startMinute'],
      endMinute: json['endMinute'],
      status: json['status'],
      attendances: (json['attendances'] as List?)?.map((a) => Attendance.fromJson(a)).toList() ?? [],
      offering: json['offering'] != null ? Offering.fromJson(json['offering']) : null,
      professional: json['professional'] != null ? Person.fromJson(json['professional']) : null,
    );
  }
}

class Attendance {
  final String id;
  final String sessionId;
  final String personId;
  final String status;
  final Person? person;

  Attendance({
    required this.id,
    required this.sessionId,
    required this.personId,
    required this.status,
    this.person,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      sessionId: json['sessionId'],
      personId: json['personId'],
      status: json['status'],
      person: json['person'] != null ? Person.fromJson(json['person']) : null,
    );
  }
}
