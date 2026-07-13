import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state.dart';
import 'schedule_screen.dart';
import 'patients_screen.dart';
import 'professionals_screen.dart';
import 'catalog_screen.dart';

class DashboardShell extends ConsumerStatefulWidget {
  const DashboardShell({super.key});

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  int _selectedIndex = 0;

  final List<String> _menus = [
    'Dashboard',
    'Agenda',
    'Pacientes',
    'Equipe',
    'Financeiro',
    'Catálogo',
    'Configurações'
  ];

  final List<IconData> _icons = [
    Icons.space_dashboard_rounded,
    Icons.calendar_month_rounded,
    Icons.people_alt_rounded,
    Icons.medical_information_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.inventory_2_rounded,
    Icons.settings_suggest_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final activeWorkspace = ref.watch(activeWorkspaceProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    if (activeWorkspace == null) {
      return const Scaffold(body: Center(child: Text('Nenhuma clínica selecionada.')));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text(activeWorkspace.name, style: const TextStyle(fontSize: 16)),
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              elevation: 0,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContent(context, isMobile: true)),
      body: Stack(
        children: [
          // Fundo Orgânico
          Positioned(
            top: -150,
            left: -100,
            child: _buildBubble(context, 400, Theme.of(context).colorScheme.primary.withOpacity(0.15)),
          ),
          Positioned(
            bottom: -200,
            right: -100,
            child: _buildBubble(context, 500, const Color(0xFF8263FF).withOpacity(0.1)),
          ),
          
          // Layout Principal Flutuante
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Row(
                children: [
                  if (isDesktop) ...[
                    _buildSidebarContent(context, isMobile: false),
                    const SizedBox(width: 24),
                  ],
                  Expanded(
                    child: Column(
                      children: [
                        if (isDesktop) _buildTopBar(context, activeWorkspace.name),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                                  blurRadius: 40,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: _selectedIndex == 1 
                                  ? const ScheduleScreen()
                                  : _selectedIndex == 2
                                      ? const PatientsScreen()
                                      : _selectedIndex == 3
                                          ? const ProfessionalsScreen()
                                          : _selectedIndex == 5
                                              ? const CatalogScreen()
                                              : BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _icons[_selectedIndex],
                                        size: 80,
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Módulo: ${_menus[_selectedIndex]}',
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context, double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String workspaceName) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bem-vindo de volta,', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
                  Text(workspaceName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              Row(
                children: [
                  _buildIconButton(Icons.notifications_outlined),
                  const SizedBox(width: 16),
                  _buildIconButton(Icons.search_rounded),
                  const SizedBox(width: 24),
                  Container(width: 1, height: 32, color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                  const SizedBox(width: 24),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'), // Placeholder Premium
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ana', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Administradora', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, {required bool isMobile}) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/logo/logo_minha_fisio.png', height: 48),
              const SizedBox(height: 48),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _menus.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIndex == index;
                    return _SidebarItem(
                      icon: _icons[index],
                      title: _menus[index],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        if (isMobile) Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 1),
              ),
              const SizedBox(height: 16),
              _SidebarItem(
                icon: Icons.logout_rounded,
                title: 'Sair da Conta',
                isSelected: false,
                isLogout: true,
                onTap: () {
                  // TODO: Logout logic
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final bool isLogout;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final error = theme.colorScheme.error;
    
    final color = widget.isLogout 
        ? error 
        : (widget.isSelected ? primary : secondary.withOpacity(0.6));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? LinearGradient(
                      colors: [
                        primary.withOpacity(0.15),
                        primary.withOpacity(0.05),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : (_isHovering ? LinearGradient(
                      colors: [
                        color.withOpacity(0.05),
                        color.withOpacity(0.02),
                      ],
                    ) : null),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected 
                    ? primary.withOpacity(0.3) 
                    : (_isHovering ? color.withOpacity(0.1) : Colors.transparent),
              ),
            ),
            transform: Matrix4.identity()..translate(_isHovering && !widget.isSelected ? 4.0 : 0.0),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.isSelected ? primary : color,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: widget.isSelected ? primary : color,
                    fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                if (widget.isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
