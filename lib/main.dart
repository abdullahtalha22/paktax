import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/home_screen.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const PakTaxApp());
}

class PakTaxApp extends StatefulWidget {
  const PakTaxApp({super.key});

  @override
  State<PakTaxApp> createState() => _PakTaxAppState();
}

class _PakTaxAppState extends State<PakTaxApp> {
  bool _isDark = true;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PakTax',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      routes: AppRoutes.routes,
      home: HomeScreen(
        onThemeToggle: _toggleTheme,
        isDark: _isDark,
      ),
    );
  }
}
