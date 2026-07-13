import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workspace.dart';

class ActiveWorkspaceNotifier extends Notifier<Workspace?> {
  @override
  Workspace? build() => null;

  void setWorkspace(Workspace workspace) {
    state = workspace;
  }
}

// Gerencia a clínica ativa selecionada pelo usuário
final activeWorkspaceProvider = NotifierProvider<ActiveWorkspaceNotifier, Workspace?>(() {
  return ActiveWorkspaceNotifier();
});
