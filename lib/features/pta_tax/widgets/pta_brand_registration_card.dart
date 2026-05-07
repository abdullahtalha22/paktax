import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/pta_tax_controller.dart';

// ── Step Label ────────────────────────────────────────────────────────────
class PtaStepLabel extends StatelessWidget {
  final String step, label;
  final Color color;
  const PtaStepLabel({super.key, required this.step, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(children: [
      Container(
        width: 22, height: 22,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.40)),
        ),
        child: Center(child: Text(step, style: GoogleFonts.sora(
            fontSize: 11, fontWeight: FontWeight.w800, color: color))),
      ),
      const SizedBox(width: 8),
      Text(label, style: GoogleFonts.sora(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textWhite : AppColors.textDark)),
    ]);
  }
}

// ── Brand & Registration Combined Card ───────────────────────────────────
class PtaBrandRegistrationCard extends StatelessWidget {
  final PtaTaxController ctrl;
  final bool isDark;
  const PtaBrandRegistrationCard({super.key, required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.ptaPurple.withOpacity(0.08) : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: isDark ? AppColors.ptaPurple.withOpacity(0.18) : AppColors.lightBorder),
            boxShadow: [BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.28) : Colors.black.withOpacity(0.06),
                blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PtaStepLabel(step: '1', label: 'Select Brand', color: AppColors.ptaPurple),
            const SizedBox(height: 12),
            _BrandGrid(ctrl: ctrl, isDark: isDark),
            const SizedBox(height: 18),
            PtaStepLabel(step: '2', label: 'Registration Type', color: AppColors.ptaPurple),
            const SizedBox(height: 12),
            _RegistrationToggle(ctrl: ctrl, isDark: isDark),
          ]),
        ),
      ),
    );
  }
}

// ── Brand Grid ────────────────────────────────────────────────────────────
class _BrandGrid extends StatelessWidget {
  final PtaTaxController ctrl;
  final bool isDark;
  const _BrandGrid({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final brands = ctrl.brands;
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: brands.map((b) {
        final isSelected = ctrl.selectedBrand == b;
        return GestureDetector(
          onTap: () => ctrl.selectBrand(b),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected ? const LinearGradient(colors: AppColors.ptaGrad) : null,
              color: isSelected ? null : (isDark ? AppColors.darkElevated : AppColors.lightElevated),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.transparent
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              boxShadow: isSelected ? [BoxShadow(
                  color: AppColors.ptaPurple.withOpacity(0.35),
                  blurRadius: 10, offset: const Offset(0, 4))] : [],
            ),
            child: Text(b, style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white
                    : (isDark ? AppColors.textGrey1 : AppColors.textGrey2))),
          ),
        );
      }).toList(),
    );
  }
}

// ── Registration Toggle ───────────────────────────────────────────────────
class _RegistrationToggle extends StatelessWidget {
  final PtaTaxController ctrl;
  final bool isDark;
  const _RegistrationToggle({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _RegOption(
          label: 'CNIC', sublabel: 'Pakistani National',
          icon: Icons.badge_rounded,
          isSelected: ctrl.registrationType == 'CNIC',
          onTap: () => ctrl.setRegistrationType('CNIC'), isDark: isDark)),
      const SizedBox(width: 10),
      Expanded(child: _RegOption(
          label: 'Passport', sublabel: 'Overseas / Traveler',
          icon: Icons.flight_rounded,
          isSelected: ctrl.registrationType == 'Passport',
          onTap: () => ctrl.setRegistrationType('Passport'), isDark: isDark)),
    ]);
  }
}

class _RegOption extends StatelessWidget {
  final String label, sublabel;
  final IconData icon;
  final bool isSelected, isDark;
  final VoidCallback onTap;
  const _RegOption({required this.label, required this.sublabel, required this.icon,
    required this.isSelected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? const LinearGradient(colors: AppColors.ptaGrad) : null,
          color: isSelected ? null : (isDark ? AppColors.darkElevated : AppColors.lightElevated),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? Colors.transparent
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
          boxShadow: isSelected ? [BoxShadow(
              color: AppColors.ptaPurple.withOpacity(0.35),
              blurRadius: 12, offset: const Offset(0, 4))] : [],
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white
              : (isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white
                    : (isDark ? AppColors.textWhite : AppColors.textDark))),
            Text(sublabel, style: GoogleFonts.sora(fontSize: 9,
                color: isSelected ? Colors.white.withOpacity(0.75)
                    : (isDark ? AppColors.textGrey2 : AppColors.textGrey1))),
          ])),
          if (isSelected)
            Container(width: 16, height: 16,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 10, color: Colors.white)),
        ]),
      ),
    );
  }
}