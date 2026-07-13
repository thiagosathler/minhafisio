import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/person.dart';
import '../services/person_service.dart';
import 'app_state.dart';

final personServiceProvider = Provider<PersonService>((ref) {
  return PersonService();
});

class PatientsNotifier extends AsyncNotifier<List<Person>> {
  late PersonService _personService;
  late String _workspaceId;

  @override
  Future<List<Person>> build() async {
    final workspace = ref.watch(activeWorkspaceProvider);
    _personService = ref.watch(personServiceProvider);
    
    if (workspace == null) {
      _workspaceId = '';
      return [];
    }
    
    _workspaceId = workspace.id;
    return await _personService.getPatients(_workspaceId);
  }

  Future<bool> addPatient(String name, String email, String phone) async {
    final newPatient = await _personService.createPatient(_workspaceId, name, email, phone);
    if (newPatient != null) {
      if (state.hasValue) {
        final currentList = state.value!;
        state = AsyncValue.data([...currentList, newPatient]..sort((a, b) => a.name.compareTo(b.name)));
      } else {
        state = AsyncValue.data([newPatient]);
      }
      return true;
    }
    return false;
  }
}

final patientsProvider = AsyncNotifierProvider<PatientsNotifier, List<Person>>(() {
  return PatientsNotifier();
});

class ProfessionalsNotifier extends AsyncNotifier<List<Person>> {
  late PersonService _personService;
  late String _workspaceId;

  @override
  Future<List<Person>> build() async {
    final workspace = ref.watch(activeWorkspaceProvider);
    _personService = ref.watch(personServiceProvider);
    
    if (workspace == null) {
      _workspaceId = '';
      return [];
    }
    
    _workspaceId = workspace.id;
    return await _personService.getProfessionals(_workspaceId);
  }

  Future<bool> addProfessional(String name, String email, String phone, String crefito) async {
    final newProf = await _personService.createProfessional(_workspaceId, name, email, phone, crefito);
    if (newProf != null) {
      if (state.hasValue) {
        final currentList = state.value!;
        state = AsyncValue.data([...currentList, newProf]..sort((a, b) => a.name.compareTo(b.name)));
      } else {
        state = AsyncValue.data([newProf]);
      }
      return true;
    }
    return false;
  }
}

final professionalsProvider = AsyncNotifierProvider<ProfessionalsNotifier, List<Person>>(() {
  return ProfessionalsNotifier();
});
