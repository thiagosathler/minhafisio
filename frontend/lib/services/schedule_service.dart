import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule.dart';

class ScheduleService {
  final String baseUrl = 'http://localhost:3333/api';

  Future<List<Session>> getSessions(String workspaceId, DateTime startDate, DateTime endDate) async {
    try {
      final start = startDate.toIso8601String();
      final end = endDate.toIso8601String();
      final response = await http.get(
        Uri.parse('$baseUrl/schedule/sessions?workspaceId=$workspaceId&startDate=$start&endDate=$end'),
        headers: {'Content-Type': 'application/json', 'workspace-id': workspaceId},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Session.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar sessões: $e');
    }
    return [];
  }

  Future<bool> createAvulsoSession(
    String workspaceId,
    String offeringId,
    String professionalId,
    String personId,
    DateTime sessionDate,
    int startMinute,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/schedule/sessions'),
        headers: {'Content-Type': 'application/json', 'workspace-id': workspaceId},
        body: jsonEncode({
          'workspaceId': workspaceId,
          'offeringId': offeringId,
          'professionalId': professionalId,
          'personId': personId,
          'sessionDate': sessionDate.toIso8601String(),
          'startMinute': startMinute,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao criar sessão avulsa: $e');
    }
    return false;
  }
}
