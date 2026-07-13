import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/schedule.dart';
import '../providers/schedule_provider.dart';
import '../providers/person_provider.dart';
import '../providers/catalog_provider.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _showAddSessionDialog() {
    if (_selectedDay == null) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _AddSessionDialog(selectedDate: _selectedDay!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheduleAsync = ref.watch(scheduleProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Calendar
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Agenda', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: _showAddSessionDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Agendar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: scheduleAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, st) => Center(child: Text('Erro: $err')),
                    data: (sessions) {
                      return TableCalendar<Session>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        calendarFormat: CalendarFormat.month,
                        eventLoader: (day) => sessions.where((s) => isSameDay(s.sessionDate, day)).toList(),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          setState(() => _focusedDay = focusedDay);
                          ref.read(scheduleProvider.notifier).changeMonth(focusedDay);
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final daySessions = sessions.where((s) => isSameDay(s.sessionDate, day)).toList();
                            if (daySessions.isNotEmpty) {
                              return Container(
                                margin: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(child: Text('${day.day}')),
                              );
                            }
                            return null;
                          },
                        ),
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.3), shape: BoxShape.circle),
                          markersMaxCount: 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Right Column: Timeline / Events
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.only(top: 24, bottom: 24, right: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedDay != null ? DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(_selectedDay!) : 'Selecione um dia',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(height: 32),
                Expanded(
                  child: scheduleAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, st) => const Center(child: Text('Erro')),
                    data: (sessions) {
                      final daySessions = sessions.where((s) => _selectedDay != null && isSameDay(s.sessionDate, _selectedDay!)).toList();
                      if (daySessions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy, size: 64, color: theme.colorScheme.outline.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              Text('Nenhum atendimento.', style: TextStyle(color: theme.colorScheme.outline)),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: daySessions.length,
                        itemBuilder: (context, index) {
                          final session = daySessions[index];
                          final startH = (session.startMinute ~/ 60).toString().padLeft(2, '0');
                          final startM = (session.startMinute % 60).toString().padLeft(2, '0');
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                                child: Text('$startH:$startM', style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                              title: Text(session.offering?.name ?? 'Sessão', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Prof: ${session.professional?.name ?? '-'}'),
                              trailing: Chip(
                                label: Text(session.status, style: const TextStyle(fontSize: 10)),
                                backgroundColor: session.status == 'SCHEDULED' ? theme.colorScheme.primary.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddSessionDialog extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  const _AddSessionDialog({required this.selectedDate});

  @override
  ConsumerState<_AddSessionDialog> createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends ConsumerState<_AddSessionDialog> {
  String? _selectedPatientId;
  String? _selectedProfId;
  String? _selectedOfferingId;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_selectedPatientId == null || _selectedProfId == null || _selectedOfferingId == null) return;
    setState(() => _isLoading = true);
    
    final startMin = _selectedTime.hour * 60 + _selectedTime.minute;
    final success = await ref.read(scheduleProvider.notifier).scheduleAvulso(
      _selectedOfferingId!,
      _selectedProfId!,
      _selectedPatientId!,
      widget.selectedDate,
      startMin,
    );

    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agendado com sucesso!'), backgroundColor: Colors.green));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final patientsAsync = ref.watch(patientsProvider);
    final profsAsync = ref.watch(professionalsProvider);
    final catalogAsync = ref.watch(catalogProvider);

    return Center(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(12)),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Novo Agendamento', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 24),
              Text('Data: ${DateFormat('dd/MM/yyyy').format(widget.selectedDate)}', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Horário: ${_selectedTime.format(context)}', style: theme.textTheme.titleMedium),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final time = await showTimePicker(context: context, initialTime: _selectedTime);
                      if (time != null) setState(() => _selectedTime = time);
                    },
                    child: const Text('Mudar Hora'),
                  )
                ],
              ),
              const SizedBox(height: 24),
              // Patient Dropdown
              patientsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text('Erro: $e'),
                data: (patients) => DropdownButtonFormField<String>(
                  value: _selectedPatientId,
                  decoration: const InputDecoration(labelText: 'Paciente', border: OutlineInputBorder()),
                  items: patients.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                  onChanged: (val) => setState(() => _selectedPatientId = val),
                ),
              ),
              const SizedBox(height: 16),
              // Prof Dropdown
              profsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text('Erro: $e'),
                data: (profs) => DropdownButtonFormField<String>(
                  value: _selectedProfId,
                  decoration: const InputDecoration(labelText: 'Profissional', border: OutlineInputBorder()),
                  items: profs.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                  onChanged: (val) => setState(() => _selectedProfId = val),
                ),
              ),
              const SizedBox(height: 16),
              // Offering Dropdown
              catalogAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text('Erro: $e'),
                data: (categories) {
                  final allOfferings = categories.expand((c) => c.offerings).toList();
                  return DropdownButtonFormField<String>(
                    value: _selectedOfferingId,
                    decoration: const InputDecoration(labelText: 'Serviço / Oferta', border: OutlineInputBorder()),
                    items: allOfferings.map((o) => DropdownMenuItem(value: o.id, child: Text(o.name))).toList(),
                    onChanged: (val) => setState(() => _selectedOfferingId = val),
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.surface),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Confirmar Agendamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
