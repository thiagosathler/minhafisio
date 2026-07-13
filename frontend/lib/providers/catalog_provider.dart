import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/catalog.dart';
import '../services/catalog_service.dart';
import 'app_state.dart';

final catalogServiceProvider = Provider<CatalogService>((ref) {
  return CatalogService();
});

class CatalogNotifier extends AsyncNotifier<List<ServiceCategory>> {
  late CatalogService _service;
  late String _workspaceId;

  @override
  Future<List<ServiceCategory>> build() async {
    final workspace = ref.watch(activeWorkspaceProvider);
    _service = ref.watch(catalogServiceProvider);
    
    if (workspace == null) {
      _workspaceId = '';
      return [];
    }
    
    _workspaceId = workspace.id;
    return await _service.getServices(_workspaceId);
  }

  Future<bool> addService(String name, String? color) async {
    final newService = await _service.createService(_workspaceId, name, color);
    if (newService != null) {
      if (state.hasValue) {
        final currentList = state.value!;
        state = AsyncValue.data([...currentList, newService]..sort((a, b) => a.name.compareTo(b.name)));
      } else {
        state = AsyncValue.data([newService]);
      }
      return true;
    }
    return false;
  }

  Future<bool> addOffering(String serviceId, String name, int durationMinutes, String mode, double? price) async {
    final success = await _service.createOffering(_workspaceId, serviceId, name, durationMinutes, mode, price);
    if (success) {
      // Recarregar a lista inteira do backend para simplificar a injeção do offering no state
      final refreshed = await _service.getServices(_workspaceId);
      state = AsyncValue.data(refreshed);
      return true;
    }
    return false;
  }
}

final catalogProvider = AsyncNotifierProvider<CatalogNotifier, List<ServiceCategory>>(() {
  return CatalogNotifier();
});
