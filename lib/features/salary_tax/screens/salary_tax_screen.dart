import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/salary_tax_controller.dart';
import '../widgets/tax_breakdown_chart.dart';
import '../widgets/tax_slab_table.dart';

class SalaryTaxScreen extends StatelessWidget {
  const SalaryTaxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalaryTaxController(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = context.watch<SalaryTaxController>();
    final size = MediaQuery.of(context).size;
    final sf = (size.height / 844).clamp(0.80, 1.15);

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0A0A1F) : const Color(0xFFF0F0FF),
      body: Stack(
        children: [
          _Background(isDark: isDark, size: size),
          Column(
            children: [
              _HeroHeader(isDark: isDark, ctrl: ctrl, sf: sf),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.fromLTRB(18, 16, 18, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Input Card ──────────────────────────────
                      _InputCard(ctrl: ctrl, isDark: isDark, sf: sf)
                          .animate()
                          .fadeIn(duration: 350.ms, delay: 100.ms)
                          .slideY(
                          begin: 0.07,
                          end: 0,
                          curve: Curves.easeOutCubic),

                      const SizedBox(height: 18),

                      // ── Section Label ───────────────────────────
                      Row(
                        children: [
                          Text(
                            'Tax Results',
                            style: GoogleFonts.sora(
                              fontSize: 16 * sf,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0D0D1A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          _SlabPill(
                              label: ctrl.result.taxSlab,
                              color: ctrl.result.isTaxExempt
                                  ? AppColors.accentGreen
                                  : AppColors.salaryBlue),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 200.ms),

                      const SizedBox(height: 12),

                      // ── Stat Grid ───────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Monthly Tax',
                              value: _fmt(ctrl.result.monthlyTax),
                              color: AppColors.salaryBlue,
                              icon: Icons.calendar_month_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: _StatCard(
                              label: 'Annual Tax',
                              value: _fmt(ctrl.result.annualTax),
                              color: AppColors.accentRed,
                              icon: Icons.receipt_long_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 260.ms),

                      const SizedBox(height: 11),

                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Net Monthly',
                              value: _fmt(ctrl.result.netMonthly),
                              color: AppColors.accentGreen,
                              icon: Icons.account_balance_wallet_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: _StatCard(
                              label: 'Effective Rate',
                              value:
                              '${ctrl.result.effectiveTaxRate.toStringAsFixed(1)}%',
                              color: AppColors.whtOrange,
                              icon: Icons.percent_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 300.ms),

                      const SizedBox(height: 14),

                      // ── Net Banner ──────────────────────────────
                      _NetBanner(ctrl: ctrl, sf: sf)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 340.ms),

                      const SizedBox(height: 14),

                      // ── Breakdown Chart ─────────────────────────
                      TaxBreakdownChart(result: ctrl.result)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 380.ms),

                      const SizedBox(height: 14),

                      // ── Slab Table ──────────────────────────────
                      const TaxSlabTable()
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 420.ms),

                      const SizedBox(height: 12),

                      // ── Footer note ─────────────────────────────
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded,
                                size: 11,
                                color: isDark
                                    ? AppColors.textGrey2
                                    : AppColors.textGrey1),
                            const SizedBox(width: 4),
                            Text(
                              'FBR Finance Act 2025. Verify with your tax consultant.',
                              style: GoogleFonts.sora(
                                fontSize: 10,
                                color: isDark
                                    ? AppColors.textGrey2
                                    : AppColors.textGrey1,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: 460.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v == 0) return '0';
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(2)} L';
    return v
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},');
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
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEBEDFF),
              Color(0xFFF6F0FF),
              Color(0xFFE8F0FF)
            ],
          ),
        ),
      );
    }
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF07071A), Color(0xFF0B0B28), Color(0xFF070718)],
          ),
        ),
      ),
      Positioned(
        top: -size.height * 0.05,
        right: -size.width * 0.15,
        child: Container(
          width: size.width * 0.80,
          height: size.width * 0.80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColors.salaryBlue.withOpacity(0.22),
              Colors.transparent
            ]),
          ),
        ),
      ),
      Positioned(
        top: size.height * 0.42,
        left: -size.width * 0.20,
        child: Container(
          width: size.width * 0.55,
          height: size.width * 0.55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColors.primaryViolet.withOpacity(0.14),
              Colors.transparent
            ]),
          ),
        ),
      ),
      Positioned(
        bottom: size.height * 0.08,
        right: -size.width * 0.10,
        child: Container(
          width: size.width * 0.45,
          height: size.width * 0.45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColors.accentGreen.withOpacity(0.10),
              Colors.transparent
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Hero Header (matches Home screen hero style) ───────────────────────────
class _HeroHeader extends StatelessWidget {
  final bool isDark;
  final SalaryTaxController ctrl;
  final double sf;
  const _HeroHeader(
      {required this.isDark, required this.ctrl, required this.sf});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            const Color(0xFF0D0A2A),
            const Color(0xFF0A1232),
            const Color(0xFF070D1F)
          ]
              : [
            const Color(0xFF4A6CF7),
            const Color(0xFF6C8EFF),
            const Color(0xFF8AA8FF)
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.salaryBlue.withOpacity(0.32),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative rings
          Positioned(
            top: topPad - 10,
            right: -22,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.07), width: 28),
              ),
            ),
          ),
          Positioned(
            top: topPad + 55,
            right: 42,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.06), width: 14),
              ),
            ),
          ),
          Padding(
            padding:
            EdgeInsets.fromLTRB(20, topPad + 14, 20, 22 * sf),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar: back + title chip
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1),
                        ),
                        child: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 38,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 14),
                          ),
                          const SizedBox(width: 8),
                          Text('Salary Tax',
                              style: GoogleFonts.sora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3)),
                        ],
                      ),
                    ),
                    const Spacer(),

                  ],
                ).animate().fadeIn(duration: 350.ms),

                SizedBox(height: 20 * sf),

                Text('Salaried Persons',
                    style: GoogleFonts.sora(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.60),
                        letterSpacing: 0.4)),
                SizedBox(height: 5 * sf),
                Text('Income Tax\nCalculator',
                    style: GoogleFonts.sora(
                        fontSize: 28 * sf,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                        letterSpacing: -1.2)),
                SizedBox(height: 8 * sf),

              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 60.ms)
              .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

// ── Input Card ─────────────────────────────────────────────────────────────
class _InputCard extends StatelessWidget {
  final SalaryTaxController ctrl;
  final bool isDark;
  final double sf;
  const _InputCard(
      {required this.ctrl, required this.isDark, required this.sf});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(colors: [
              AppColors.salaryBlue.withOpacity(0.10),
              AppColors.primaryViolet.withOpacity(0.06),
            ])
                : LinearGradient(colors: [
              Colors.white.withOpacity(0.92),
              Colors.white.withOpacity(0.80),
            ]),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? AppColors.salaryBlue.withOpacity(0.28)
                  : Colors.white.withOpacity(0.95),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.28)
                    : Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.salaryGrad),
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.salaryBlue.withOpacity(0.40),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 16),
                  ),
                  const SizedBox(width: 11),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monthly Gross Salary',
                          style: GoogleFonts.sora(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0D0D1A),
                              letterSpacing: -0.2)),
                      Text('Enter amount below',
                          style: GoogleFonts.sora(
                              fontSize: 10.5,
                              color: isDark
                                  ? AppColors.textGrey1
                                  : AppColors.textGrey2)),
                    ],
                  ),
                  const Spacer(),
                  if (ctrl.hasInput)
                    GestureDetector(
                      onTap: ctrl.reset,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.accentRed.withOpacity(0.25),
                              width: 1),
                        ),
                        child: Text('Clear',
                            style: GoogleFonts.sora(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accentRed)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Input field
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.04)
                      : AppColors.lightElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ctrl.hasInput
                        ? AppColors.salaryBlue.withOpacity(0.45)
                        : isDark
                        ? Colors.white.withOpacity(0.10)
                        : AppColors.lightBorder,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Rs',
                        style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.salaryBlue)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: ctrl.salaryController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: GoogleFonts.sora(
                          fontSize: 24 * sf,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0D0D1A),
                          letterSpacing: -0.8,
                        ),
                        decoration: InputDecoration(
                          hintText: '150,000',
                          hintStyle: GoogleFonts.sora(
                              fontSize: 20 * sf,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white.withOpacity(0.18)
                                  : Colors.black.withOpacity(0.15),
                              letterSpacing: -0.8),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Text('/ mo',
                        style: GoogleFonts.sora(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textGrey1
                                : AppColors.textGrey2,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Hint row
              Row(
                children: [
                  Icon(
                    ctrl.hasInput
                        ? Icons.bolt_rounded
                        : Icons.touch_app_rounded,
                    size: 12,
                    color: ctrl.hasInput
                        ? AppColors.accentGreen
                        : isDark
                        ? AppColors.textGrey2
                        : AppColors.textGrey1,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    ctrl.hasInput
                        ? 'Calculated '
                        : 'Type your monthly salary above',
                    style: GoogleFonts.sora(
                      fontSize: 10.5,
                      color: ctrl.hasInput
                          ? AppColors.accentGreen
                          : isDark
                          ? AppColors.textGrey2
                          : AppColors.textGrey1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  final bool isDark;
  final double sf;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.isDark,
    required this.sf,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isDark
                ? color.withOpacity(0.08)
                : Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? color.withOpacity(0.22)
                  : Colors.white.withOpacity(0.92),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.20)
                    : color.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, color: color, size: 13),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(label,
                        style: GoogleFonts.sora(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textGrey1
                                : AppColors.textGrey2,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: GoogleFonts.sora(
                    fontSize: 18 * sf,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: -0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Net Take-Home Banner ───────────────────────────────────────────────────
class _NetBanner extends StatelessWidget {
  final SalaryTaxController ctrl;
  final double sf;
  const _NetBanner({required this.ctrl, required this.sf});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: AppColors.greenGrad,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withOpacity(0.32),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -14,
            top: -14,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.white.withOpacity(0.40),
                  Colors.transparent
                ]),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22)),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.verified_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Annual Net Take-Home',
                      style: GoogleFonts.sora(
                          fontSize: 11, color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(
                    'Rs ${_fmt(ctrl.result.netAnnual)}',
                    style: GoogleFonts.sora(
                        fontSize: 22 * sf,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.8),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Monthly',
                      style: GoogleFonts.sora(
                          fontSize: 10, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('Rs ${_fmt(ctrl.result.netMonthly)}',
                      style: GoogleFonts.sora(
                          fontSize: 14 * sf,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.4)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v == 0) return '0';
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(2)} L';
    return v
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},');
  }
}

// ── Slab Pill ──────────────────────────────────────────────────────────────
class _SlabPill extends StatelessWidget {
  final String label;
  final Color color;
  const _SlabPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.30), width: 1),
      ),
      child: Text(label,
          style: GoogleFonts.sora(
              fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}