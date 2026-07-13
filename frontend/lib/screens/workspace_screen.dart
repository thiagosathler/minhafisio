import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/workspace_service.dart';
import '../models/workspace.dart';
import '../providers/app_state.dart';
import 'dashboard_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacesAsyncValue = ref.watch(workspacesProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Decorativo
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              ),
            ),
          ),
          // Conteúdo principal
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meus Workspaces',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selecione a clínica para acessar o painel de gestão',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  if (context.mounted) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                  }
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text('SAIR DA CONTA'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add),
                                label: const Text('NOVA CLÍNICA'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: workspacesAsyncValue.when(
                        data: (workspaces) {
                          if (workspaces.isEmpty) {
                            return _buildEmptyState(context);
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            itemCount: workspaces.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: WorkspaceCard(workspace: workspaces[index]),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Erro: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_outlined, size: 80, color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'Nenhuma clínica encontrada',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkspaceCard extends ConsumerStatefulWidget {
  final Workspace workspace;

  const WorkspaceCard({super.key, required this.workspace});

  @override
  ConsumerState<WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends ConsumerState<WorkspaceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(_isHovered ? 0.15 : 0.05),
              blurRadius: _isHovered ? 30 : 15,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: InkWell(
              onTap: () {
                // Set the active workspace
                ref.read(activeWorkspaceProvider.notifier).setWorkspace(widget.workspace);
                // Navigate to dashboard
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardShell()),
                );
              },
              hoverColor: Colors.transparent,
              splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: const Center(
                        child: Icon(Icons.maps_home_work_rounded, color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.workspace.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: widget.workspace.status == 'ACTIVE' 
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.workspace.status == 'ACTIVE' ? 'Ativo' : 'Inativo',
                                  style: TextStyle(
                                    color: widget.workspace.status == 'ACTIVE' ? Colors.green[700] : Colors.orange[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.email_outlined, size: 16, color: Theme.of(context).colorScheme.outline),
                              const SizedBox(width: 6),
                              Text(
                                widget.workspace.email ?? 'Sem email cadastrado',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      transform: Matrix4.translationValues(_isHovered ? 8 : 0, 0, 0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isHovered ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded, 
                          color: _isHovered ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
