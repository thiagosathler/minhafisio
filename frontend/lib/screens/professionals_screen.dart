import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/person_provider.dart';
import '../models/person.dart';

class ProfessionalsScreen extends ConsumerStatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  ConsumerState<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends ConsumerState<ProfessionalsScreen> {
  void _showAddDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const _AddProfessionalDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profsAsync = ref.watch(professionalsProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Equipe (Profissionais)', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Novo Profissional'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: profsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erro: $err')),
            data: (profs) {
              if (profs.isEmpty) return _buildEmptyState();
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 1.3,
                ),
                itemCount: profs.length,
                itemBuilder: (context, index) => _buildCard(profs[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_information_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text('Nenhum profissional cadastrado', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCard(Person prof) {
    final theme = Theme.of(context);
    final initials = prof.name.trim().split(' ').take(2).map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').join('');

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.tertiary.withOpacity(0.15),
                      child: Text(initials, style: TextStyle(color: theme.colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(prof.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const Spacer(),
                if (prof.crefito != null && prof.crefito!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.badge_outlined, size: 16, color: theme.colorScheme.outline),
                      const SizedBox(width: 8),
                      Text('CREFITO: ${prof.crefito!}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                if (prof.email != null && prof.email!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.email_outlined, size: 16, color: theme.colorScheme.outline),
                      const SizedBox(width: 8),
                      Expanded(child: Text(prof.email!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddProfessionalDialog extends ConsumerStatefulWidget {
  const _AddProfessionalDialog();

  @override
  ConsumerState<_AddProfessionalDialog> createState() => _AddProfessionalDialogState();
}

class _AddProfessionalDialogState extends ConsumerState<_AddProfessionalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _crefitoController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    final success = await ref.read(professionalsProvider.notifier).addProfessional(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _phoneController.text.trim(),
      _crefitoController.text.trim(),
    );

    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profissional adicionado!'), backgroundColor: Colors.green));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao adicionar.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 20))],
          ),
          child: Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Novo Profissional', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome Completo', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), filled: true),
                    validator: (val) => val == null || val.isEmpty ? 'Nome obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _crefitoController,
                    decoration: InputDecoration(labelText: 'CREFITO / Registro', prefixIcon: const Icon(Icons.badge), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), filled: true),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'E-mail', prefixIcon: const Icon(Icons.email), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), filled: true),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Telefone', prefixIcon: const Icon(Icons.phone), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), filled: true),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.onPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar Profissional', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
