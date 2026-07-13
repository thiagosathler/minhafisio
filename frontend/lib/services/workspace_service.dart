import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workspace.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workspaceServiceProvider = Provider((ref) => WorkspaceService());

final workspacesProvider = FutureProvider<List<Workspace>>((ref) async {
  final service = ref.read(workspaceServiceProvider);
  return service.getWorkspaces();
});

class WorkspaceService {
  static const String baseUrl = 'http://localhost:3333/api';

  Future<List<Workspace>> getWorkspaces() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('$baseUrl/workspaces'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Workspace.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load workspaces: ${response.body}');
    }
  }
}
