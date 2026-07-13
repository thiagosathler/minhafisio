import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/workspace_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const ProviderScope(child: MinhaFisioApp()));
}

class MinhaFisioApp extends StatelessWidget {
  const MinhaFisioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo as cores baseadas no Design System Mãos em concha + Coluna vertebral estilizada
    const primaryColor = Color(0xFF5B3DF5); // Roxo Vibrante
    const secondaryColor = Color(0xFF24245F); // Índigo Profundo
    const backgroundColor = Color(0xFFEEF0FF); // Lavanda Suave
    const surfaceColor = Color(0xFFFFFFFF); // Branco Puro
    const outlineColor = Color(0xFF72778A); // Cinza Neutro
    const successColor = Color(0xFF3FB950);
    const warningColor = Color(0xFFF2B705);
    const errorColor = Color(0xFFD93025);

    // Tipografia baseada na família Poppins
    final textTheme = GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: secondaryColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: secondaryColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: secondaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: secondaryColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: secondaryColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: secondaryColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: outlineColor,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 9.5,
        fontWeight: FontWeight.w600,
        height: 1.0,
      ),
    );

    return MaterialApp(
      title: 'Minha Fisio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: secondaryColor,
          onSecondary: Colors.white,
          error: errorColor,
          onError: Colors.white,
          surface: surfaceColor,
          onSurface: secondaryColor,
          outline: outlineColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: textTheme,
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.all(8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            textStyle: textTheme.labelLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Pílula ou 8px mínimo
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: secondaryColor,
            side: const BorderSide(color: secondaryColor),
            textStyle: textTheme.labelLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100], // Fundo cinza muito claro
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: outlineColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: outlineColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          labelStyle: textTheme.bodyMedium,
          floatingLabelStyle: textTheme.bodyMedium?.copyWith(color: primaryColor),
        ),
        dataTableTheme: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(secondaryColor),
          headingTextStyle: textTheme.titleMedium?.copyWith(color: Colors.white),
          dataTextStyle: textTheme.bodyMedium,
        ),
      ),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    if (!mounted) return;
    
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WorkspaceScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

