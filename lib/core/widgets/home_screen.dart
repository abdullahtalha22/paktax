import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Top row ──────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.salaryGrad),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Center(
                      child: Text('₨',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('PakTax',
                      style: GoogleFonts.dmSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textWhite : AppColors.textDark,
                        letterSpacing: -0.5,
                      )),
                  const Spacer(),
                  GestureDetector(
                    onTap: onThemeToggle,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkElevated
                            : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        size: 17,
                        color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 22),

              // ── Hero banner ───────────────────────────────
              _heroBanner()
                  .animate()
                  .fadeIn(duration: 350.ms, delay: 50.ms)
                  .slideY(begin: 0.06, end: 0),

              const SizedBox(height: 22),

              // ── Section label ─────────────────────────────
              Row(
                children: [
                  Text('Calculators',
                      style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                          isDark ? AppColors.textWhite : AppColors.textDark,
                          letterSpacing: -0.2)),
                  const Spacer(),
                  _pill('FBR 2025–26', AppColors.salaryBlue),
                ],
              ).animate().fadeIn(duration: 300.ms, delay: 80.ms),

              const SizedBox(height: 14),

              // ── Cards grid ───────────────────────────────
              Expanded(
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.02,
                  ),
                  children: [
                    _Card(
                      title: 'Salary Tax',
                      subtitle: 'Income tax on salary',
                      icon: Icons.account_balance_wallet_rounded,
                      colors: AppColors.salaryGrad,
                      tag: 'Most Used',
                      delay: 0,
                      isDark: isDark,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.salaryTax),
                    ),
                    _Card(
                      title: 'Withholding',
                      subtitle: 'WHT on payments',
                      icon: Icons.percent_rounded,
                      colors: AppColors.whtGrad,
                      tag: 'Sec 153/155',
                      delay: 60,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.withholdingTax),
                    ),
                    _Card(
                      title: 'PTA Device',
                      subtitle: 'Imported phone tax',
                      icon: Icons.phone_android_rounded,
                      colors: AppColors.ptaGrad,
                      tag: 'DIRBS',
                      delay: 120,
                      isDark: isDark,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.ptaTax),
                    ),
                    _Card(
                      title: 'Remittance',
                      subtitle: 'Foreign transfer tax',
                      icon: Icons.send_rounded,
                      colors: AppColors.remitGrad,
                      tag: 'Overseas',
                      delay: 180,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.remittanceTax),
                    ),
                  ],
                ),
              ),

              // ── Disclaimer ────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 12,
                        color: isDark ? AppColors.textGrey2 : AppColors.textGrey1),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Based on FBR Finance Act 2025. Verify with your tax consultant.',
                        style: GoogleFonts.dmSans(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textGrey2
                                : AppColors.textGrey1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1B1B2E), const Color(0xFF13131A)]
              : [const Color(0xFFECEEFF), const Color(0xFFE5E8FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.salaryBlue.withOpacity(0.18)
              : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pakistan's\nSmart Tax App",
                  style: GoogleFonts.dmSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textWhite : AppColors.textDark,
                    height: 1.3,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'FBR Tax Year 2025–26',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  _pill('4 Calculators', AppColors.salaryBlue),
                  const SizedBox(width: 8),
                  _pill('Free', AppColors.accentGreen),
                ]),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.salaryGrad,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.salaryBlue.withOpacity(0.30),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.calculate_rounded,
                color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Text(label,
          style: GoogleFonts.dmSans(
              fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

// ── Feature Card ─────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final String title, subtitle, tag;
  final IconData icon;
  final List<Color> colors;
  final int delay;
  final bool isDark;
  final VoidCallback onTap;

  const _Card({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.tag,
    required this.delay,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 19),
            ),
            const Spacer(),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors.first.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tag,
                  style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.first)),
            ),
            const SizedBox(height: 6),
            Text(title,
                style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textWhite : AppColors.textDark,
                    letterSpacing: -0.2)),
            const SizedBox(height: 3),
            Text(subtitle,
                style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
                    height: 1.4)),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: delay))
          .fadeIn(duration: 350.ms)
          .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),
    );
  }
}