import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_provider.dart';
import '../models/catalog.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  void _showAddServiceDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const _AddServiceDialog(),
    );
  }

  void _showAddOfferingDialog(ServiceCategory service) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _AddOfferingDialog(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(catalogProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Catálogo de Serviços', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
              ElevatedButton.icon(
                onPressed: _showAddServiceDialog,
                icon: const Icon(Icons.add),
                label: const Text('Nova Categoria'),
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
          child: catalogAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erro: $err')),
            data: (services) {
              if (services.isEmpty) return _buildEmptyState();
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                itemCount: services.length,
                itemBuilder: (context, index) => _buildServiceGroup(services[index]),
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
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text('Nenhum serviço cadastrado', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildServiceGroup(ServiceCategory service) {
    final theme = Theme.of(context);
    final color = service.color != null && service.color!.length == 7
        ? Color(int.parse(service.color!.replaceAll('#', '0xFF')))
        : theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: color.withOpacity(0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(service.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
                    TextButton.icon(
                      onPressed: () => _showAddOfferingDialog(service),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Adicionar Oferta'),
                      style: TextButton.styleFrom(foregroundColor: color),
                    )
                  ],
                ),
              ),
              if (service.offerings.isEmpty)
                const Padding(padding: EdgeInsets.all(24), child: Text('Nenhuma oferta cadastrada para esta categoria.', style: TextStyle(color: Colors.grey))),
              if (service.offerings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: service.offerings.map((offering) => _buildOfferingChip(offering, color)).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferingChip(Offering offering, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(offering.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${offering.durationMinutes} min', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              if (offering.defaultPrice != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.attach_money, size: 14, color: Colors.green[700]),
                Text(offering.defaultPrice!.toStringAsFixed(2), style: TextStyle(color: Colors.green[700], fontSize: 13, fontWeight: FontWeight.bold)),
              ]
            ],
          )
        ],
      ),
    );
  }
}

class _AddServiceDialog extends ConsumerStatefulWidget {
  const _AddServiceDialog();
  @override
  ConsumerState<_AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends ConsumerState<_AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    final success = await ref.read(catalogProvider.notifier).addService(_nameController.text.trim(), '#8263FF');

    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Categoria adicionada!'), backgroundColor: Colors.green));
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
          decoration: BoxDecoration(color: theme.colorScheme.surface.withOpacity(0.9), borderRadius: BorderRadius.circular(32)),
          child: Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Nova Categoria', style: theme.textTheme.headlineSmall), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop())]),
                  const SizedBox(height: 24),
                  TextFormField(controller: _nameController, decoration: InputDecoration(labelText: 'Nome da Categoria', filled: true), validator: (val) => val == null || val.isEmpty ? 'Obrigatório' : null),
                  const SizedBox(height: 32),
                  SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _isLoading ? null : _submit, child: _isLoading ? const CircularProgressIndicator() : const Text('Salvar')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddOfferingDialog extends ConsumerStatefulWidget {
  final ServiceCategory service;
  const _AddOfferingDialog({required this.service});
  @override
  ConsumerState<_AddOfferingDialog> createState() => _AddOfferingDialogState();
}

class _AddOfferingDialogState extends ConsumerState<_AddOfferingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    final priceStr = _priceController.text.trim();
    final price = priceStr.isEmpty ? null : double.tryParse(priceStr.replaceAll(',', '.'));
    
    final success = await ref.read(catalogProvider.notifier).addOffering(
      widget.service.id,
      _nameController.text.trim(),
      int.parse(_durationController.text.trim()),
      'IN_PERSON',
      price,
    );

    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oferta adicionada!'), backgroundColor: Colors.green));
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
          decoration: BoxDecoration(color: theme.colorScheme.surface.withOpacity(0.9), borderRadius: BorderRadius.circular(32)),
          child: Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Nova Oferta', style: theme.textTheme.headlineSmall), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop())]),
                  const SizedBox(height: 24),
                  TextFormField(controller: _nameController, decoration: InputDecoration(labelText: 'Nome (Ex: Sessão 1h)', filled: true), validator: (val) => val == null || val.isEmpty ? 'Obrigatório' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _durationController, decoration: InputDecoration(labelText: 'Duração (Minutos)', filled: true), keyboardType: TextInputType.number, validator: (val) => val == null || val.isEmpty ? 'Obrigatório' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _priceController, decoration: InputDecoration(labelText: 'Preço Opcional (Ex: 150.00)', filled: true), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 32),
                  SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _isLoading ? null : _submit, child: _isLoading ? const CircularProgressIndicator() : const Text('Salvar')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
