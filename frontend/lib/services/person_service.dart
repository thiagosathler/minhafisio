import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class PersonService {
  final String baseUrl = 'http://localhost:3333/api';

  Future<List<Person>> getPatients(String workspaceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/persons?workspaceId=$workspaceId&isClient=true'),
        headers: {
          'Content-Type': 'application/json',
          'workspace-id': workspaceId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Person.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar pacientes: $e');
    }
    return [];
  }

  Future<Person?> createPatient(String workspaceId, String name, String email, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/persons'),
        headers: {
          'Content-Type': 'application/json',
          'workspace-id': workspaceId,
        },
        body: jsonEncode({
          'workspaceId': workspaceId,
          'name': name,
          'email': email,
          'phone': phone,
          'isClient': true,
        }),
      );

      if (response.statusCode == 201) {
        return Person.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Erro ao criar paciente: $e');
    }
    return null;
  }

  Future<List<Person>> getProfessionals(String workspaceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/persons?workspaceId=$workspaceId&isProfessional=true'),
        headers: {
          'Content-Type': 'application/json',
          'workspace-id': workspaceId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Person.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar profissionais: $e');
    }
    return [];
  }

  Future<Person?> createProfessional(String workspaceId, String name, String email, String phone, String crefito) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/persons'),
        headers: {
          'Content-Type': 'application/json',
          'workspace-id': workspaceId,
        },
        body: jsonEncode({
          'workspaceId': workspaceId,
          'name': name,
          'email': email,
          'phone': phone,
          'crefito': crefito,
          'isProfessional': true,
        }),
      );

      if (response.statusCode == 201) {
        return Person.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Erro ao criar profissional: $e');
    }
    return null;
  }
}
