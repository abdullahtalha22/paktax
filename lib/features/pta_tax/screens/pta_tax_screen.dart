import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/pta_tax_controller.dart';
import '../widgets/pta_brand_registration_card.dart';
import '../widgets/pta_model_selector.dart';
import '../widgets/pta_result_panel.dart';

class PtaTaxScreen extends StatelessWidget {
  const PtaTaxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PtaTaxController(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = context.watch<PtaTaxController>();
    final size = MediaQuery.of(context).size;
    final sf = (size.height / 844).clamp(0.80, 1.15);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A1F) : const Color(0xFFF0F0FF),
      body: Stack(children: [
        _Background(isDark: isDark, size: size),
        Column(children: [
          _HeroHeader(isDark: isDark, ctrl: ctrl, sf: sf),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Step 1 & 2: Brand + Registration ────────────────
                  PtaBrandRegistrationCard(ctrl: ctrl, isDark: isDark)
                      .animate().fadeIn(duration: 350.ms, delay: 80.ms)
                      .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),

                  // ── Step 3: Model Selector (shows only after brand selected) ──
                  if (ctrl.selectedBrand != null) ...[
                    const SizedBox(height: 14),
                    PtaModelSelector(ctrl: ctrl, isDark: isDark)
                        .animate().fadeIn(duration: 300.ms)
                        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
                  ],

                  // ── Results: auto-shown when device is selected ──────
                  if (ctrl.hasCalculated && ctrl.result != null) ...[
                    const SizedBox(height: 16),

                    // Section header
                    Row(children: [
                      Text('Tax Results', style: GoogleFonts.sora(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0D0D1A),
                          letterSpacing: -0.3)),
                      const Spacer(),
                      PtaSlabPill(label: ctrl.result!.slabLabel),
                    ]).animate().fadeIn(duration: 250.ms, delay: 40.ms),

                    const SizedBox(height: 12),

                    // Total banner
                    PtaTotalBanner(result: ctrl.result!)
                        .animate().fadeIn(duration: 300.ms, delay: 80.ms)
                        .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),

                    const SizedBox(height: 12),

                    // 2×2 stat grid
                    PtaTaxStatGrid(result: ctrl.result!, isDark: isDark)
                        .animate().fadeIn(duration: 300.ms, delay: 120.ms)
                        .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),

                    const SizedBox(height: 12),

                    // Breakdown bar
                    PtaBreakdownChart(result: ctrl.result!, isDark: isDark)
                        .animate().fadeIn(duration: 300.ms, delay: 160.ms)
                        .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),

                    const SizedBox(height: 10),

                    // Device info compact card
                    PtaDeviceInfoCard(result: ctrl.result!, isDark: isDark)
                        .animate().fadeIn(duration: 300.ms, delay: 200.ms),

                    const SizedBox(height: 10),

                    // Slab table (collapsible)
                    PtaSlabTable(isDark: isDark, isPassport: ctrl.registrationType == 'Passport')
                        .animate().fadeIn(duration: 300.ms, delay: 230.ms),

                    const SizedBox(height: 10),

                    // How to register (collapsible)
                    PtaHowToRegisterCard(isDark: isDark)
                        .animate().fadeIn(duration: 300.ms, delay: 260.ms),

                    const SizedBox(height: 14),
                  ],

                  // Footer
                  Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.verified_rounded, size: 11,
                          color: isDark ? AppColors.textGrey2 : AppColors.textGrey1),
                      const SizedBox(width: 4),
                      Text('FBR Valuation Ruling 1999/2025 & 2035/2026',
                          style: GoogleFonts.sora(fontSize: 9.5,
                              color: isDark ? AppColors.textGrey2 : AppColors.textGrey1)),
                    ]),
                  ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                ],
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ── Background ─────────────────────────────────────────────────────────────
class _Background extends StatelessWidget {
  final bool isDark;
  final Size size;
  const _Background({required this.isDark, required this.size});

  @override
  Widget build(BuildContext context) {
    if (!isDark) {
      return Container(decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFFEBEDFF), Color(0xFFF6F0FF), Color(0xFFE8F0FF)])));
    }
    return Stack(children: [
      Container(decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFF07071A), Color(0xFF0B0B28), Color(0xFF070718)]))),
      Positioned(top: -size.height * 0.05, right: -size.width * 0.15,
          child: Container(width: size.width * 0.80, height: size.width * 0.80,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.ptaPurple.withOpacity(0.20), Colors.transparent])))),
      Positioned(bottom: size.height * 0.15, left: -size.width * 0.20,
          child: Container(width: size.width * 0.50, height: size.width * 0.50,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.ptaPurple2.withOpacity(0.12), Colors.transparent])))),
    ]);
  }
}

// ── Hero Header ─────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final bool isDark;
  final PtaTaxController ctrl;
  final double sf;
  const _HeroHeader({required this.isDark, required this.ctrl, required this.sf});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF2A0A4A), const Color(0xFF1A0830), const Color(0xFF0A0A1F)]
                : [AppColors.ptaPurple2, AppColors.ptaPurple, const Color(0xFFD4A0FF)]),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        boxShadow: [BoxShadow(color: AppColors.ptaPurple.withOpacity(0.35),
            blurRadius: 36, offset: const Offset(0, 14))],
      ),
      child: Stack(children: [
        // Decorative circles
        Positioned(top: topPad + 4, right: -18,
            child: Container(width: 130, height: 130,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.06), width: 26)))),
        Positioned(top: topPad + 50, right: 36,
            child: Container(width: 65, height: 65,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.05), width: 13)))),
        Padding(
          padding: EdgeInsets.fromLTRB(18, topPad + 12, 18, 20 * sf),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Top nav row
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: ClipRRect(borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(width: 38, height: 38,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withOpacity(0.22))),
                            child: const Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white, size: 16)))),
              ),
              const SizedBox(width: 12),
              Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: Colors.white.withOpacity(0.26))),
                  child: const Icon(Icons.phone_android_rounded, color: Colors.white, size: 17)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PTA Device Tax', style: GoogleFonts.sora(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: Colors.white, letterSpacing: -0.3)),
                Text('DIRBS Registration — FBR 2025-26', style: GoogleFonts.sora(
                    fontSize: 10, color: Colors.white.withOpacity(0.68))),
              ])),
              if (ctrl.selectedBrand != null)
                GestureDetector(
                  onTap: ctrl.reset,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.22))),
                    child: Text('Reset', style: GoogleFonts.sora(
                        fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
            ]).animate().fadeIn(duration: 350.ms),

            SizedBox(height: 18 * sf),

            // Title block
            Text('PTA TAX', style: GoogleFonts.sora(
                fontSize: 10, fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.60), letterSpacing: 1.0)),
            SizedBox(height: 4 * sf),
            Text('Device Calculator', style: GoogleFonts.sora(
                fontSize: 26 * sf, fontWeight: FontWeight.w800,
                color: Colors.white, height: 1.1, letterSpacing: -1.0)),
            SizedBox(height: 6 * sf),
            Text('Select brand → model → get instant CNIC & Passport duties.',
                style: GoogleFonts.sora(fontSize: 11.5, height: 1.5,
                    color: Colors.white.withOpacity(0.68))),
            SizedBox(height: 14 * sf),

            // 3 stat pills
            Row(children: [
              _HeroPill(label: '60 Days', sub: 'Register Window', icon: Icons.timer_rounded),
              const SizedBox(width: 8),
              _HeroPill(label: '17% GST', sub: 'Ad Valorem', icon: Icons.receipt_long_rounded),
              const SizedBox(width: 8),
              _HeroPill(label: 'DIRBS', sub: 'PTA System', icon: Icons.verified_rounded),
            ]).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          ]),
        ).animate().fadeIn(duration: 400.ms, delay: 60.ms)
            .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
      ]),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label, sub;
  final IconData icon;
  const _HeroPill({required this.label, required this.sub, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white.withOpacity(0.18))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: Colors.white.withOpacity(0.80), size: 13),
        const SizedBox(height: 3),
        Text(label, style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w800,
            color: Colors.white, letterSpacing: -0.3)),
        Text(sub, style: GoogleFonts.sora(fontSize: 8, color: Colors.white.withOpacity(0.58))),
      ]),
    ));
  }
}