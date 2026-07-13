import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';
import 'app_state.dart';
import 'package:intl/intl.dart';

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService();
});

class ScheduleNotifier extends AsyncNotifier<List<Session>> {
  late ScheduleService _service;
  late String _workspaceId;
  DateTime _currentDate = DateTime.now();

  @override
  Future<List<Session>> build() async {
    final workspace = ref.watch(activeWorkspaceProvider);
    _service = ref.watch(scheduleServiceProvider);
    
    if (workspace == null) {
      _workspaceId = '';
      return [];
    }
    
    _workspaceId = workspace.id;
    return await fetchForDate(_currentDate);
  }

  Future<List<Session>> fetchForDate(DateTime date) async {
    _currentDate = date;
    // Puxa do dia primeiro ao ultimo do mes pra renderizar o calendario
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return await _service.getSessions(_workspaceId, start, end);
  }

  Future<void> changeMonth(DateTime newDate) async {
    state = const AsyncValue.loading();
    try {
      final sessions = await fetchForDate(newDate);
      state = AsyncValue.data(sessions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> scheduleAvulso(String offeringId, String profId, String clientId, DateTime date, int startMin) async {
    final success = await _service.createAvulsoSession(_workspaceId, offeringId, profId, clientId, date, startMin);
    if (success) {
      // Recarrega
      final sessions = await fetchForDate(_currentDate);
      state = AsyncValue.data(sessions);
      return true;
    }
    return false;
  }
}

final scheduleProvider = AsyncNotifierProvider<ScheduleNotifier, List<Session>>(() {
  return ScheduleNotifier();
});
