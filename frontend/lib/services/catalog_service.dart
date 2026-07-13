import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/catalog.dart';

class CatalogService {
  final String baseUrl = 'http://localhost:3333/api';

  Future<List<ServiceCategory>> getServices(String workspaceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/catalog/services?workspaceId=$workspaceId'),
        headers: {'Content-Type': 'application/json', 'workspace-id': workspaceId},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ServiceCategory.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar serviços: $e');
    }
    return [];
  }

  Future<ServiceCategory?> createService(String workspaceId, String name, String? color) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/catalog/services'),
        headers: {'Content-Type': 'application/json', 'workspace-id': workspaceId},
        body: jsonEncode({'workspaceId': workspaceId, 'name': name, 'color': color}),
      );
      if (response.statusCode == 201) {
        return ServiceCategory.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Erro ao criar serviço: $e');
    }
    return null;
  }

  Future<bool> createOffering(String workspaceId, String serviceId, String name, int durationMinutes, String mode, double? defaultPrice) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/catalog/offerings'),
        headers: {'Content-Type': 'application/json', 'workspace-id': workspaceId},
        body: jsonEncode({
          'serviceId': serviceId,
          'name': name,
          'durationMinutes': durationMinutes,
          'mode': mode,
          'defaultPrice': defaultPrice,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao criar oferecimento: $e');
    }
    return false;
  }
}
