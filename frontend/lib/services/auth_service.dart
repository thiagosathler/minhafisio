import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  static const String baseUrl = 'http://localhost:3333/api/auth';

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];
      final userJson = body['user'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      
      return User.fromJson(userJson);
    } else {
      throw Exception('Falha no login: ${response.body}');
    }
  }

  Future<void> register(String name, String email, String password, String workspaceName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'workspaceName': workspaceName,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha no cadastro: ${response.body}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
