import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/remittance_tax_controller.dart';
import '../models/remittance_tax_model.dart';
import '../services/remittance_tax_service.dart';
import '../widgets/remittance_breakdown_chart.dart';
import '../widgets/remittance_rate_table.dart';

class RemittanceTaxScreen extends StatelessWidget {
  const RemittanceTaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RemittanceTaxController(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = context.watch<RemittanceTaxController>();
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
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
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

                      // ── Section Label + pill ─────────────────────
                      Row(
                        children: [
                          Text(
                            'Remittance Results',
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
                          _StatusPill(
                            label: ctrl.result.isFiler ? 'Filer' : 'Non-Filer',
                            color: ctrl.result.isFiler
                                ? AppColors.accentGreen
                                : AppColors.accentRed,
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

                      const SizedBox(height: 12),

                      // ── Stat Grid Row 1 ─────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Tax Withheld',
                              value: _fmt(ctrl.result.taxWithheld),
                              color: AppColors.remitTeal,
                              icon: Icons.money_off_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: _StatCard(
                              label: ctrl.result.directionLabel,
                              value: _fmt(ctrl.result.netAmount),
                              color: AppColors.accentGreen,
                              icon: Icons.account_balance_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 260.ms),

                      const SizedBox(height: 11),

                      // ── Stat Grid Row 2 ─────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Applied Rate',
                              value:
                              '${ctrl.result.ratePercent.toStringAsFixed(1)}%',
                              color: AppColors.salaryBlue,
                              icon: Icons.percent_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: _StatCard(
                              label: 'Section',
                              value: ctrl.result.section.isEmpty
                                  ? '—'
                                  : ctrl.result.section,
                              color: AppColors.primaryViolet,
                              icon: Icons.gavel_rounded,
                              isDark: isDark,
                              sf: sf,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

                      const SizedBox(height: 14),

                      // ── Net Banner ───────────────────────────────
                      _NetBanner(ctrl: ctrl, sf: sf)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 340.ms),

                      const SizedBox(height: 14),

                      // ── Breakdown Chart ──────────────────────────
                      RemittanceBreakdownChart(result: ctrl.result)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 380.ms),

                      const SizedBox(height: 14),

                      // ── Rate Reference Table ─────────────────────
                      RemittanceRateTable(
                          activeChannelKey: ctrl.selectedChannel)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 420.ms),

                      const SizedBox(height: 12),

                      // ── Footer ───────────────────────────────────
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

// ── Background ───────────────────────────────────────────────────────────────
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
              Color(0xFFE6FFFB),
              Color(0xFFF0FFFD),
              Color(0xFFE8F8FF),
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
            colors: [Color(0xFF07071A), Color(0xFF0A0E20), Color(0xFF070718)],
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
              AppColors.remitTeal.withOpacity(0.18),
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
              AppColors.primaryViolet.withOpacity(0.10),
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
              AppColors.accentGreen.withOpacity(0.07),
              Colors.transparent
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Hero Header — matches salary / WHT / PTA screens exactly ────────────────
class _HeroHeader extends StatelessWidget {
  final bool isDark;
  final RemittanceTaxController ctrl;
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
            const Color(0xFF070D1F),
          ]
              : [
            const Color(0xFF00A896),
            const Color(0xFF00C4AA),
            const Color(0xFF00D4B8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.remitTeal.withOpacity(0.32),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative rings — same as other screens
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
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 22 * sf),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar: back + title chip + reset ──────────
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
                            child: const Icon(Icons.public_rounded,
                                color: Colors.white, size: 14),
                          ),
                          const SizedBox(width: 8),
                          Text('Remittance Tax',
                              style: GoogleFonts.sora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (ctrl.hasInput)
                      GestureDetector(
                        onTap: ctrl.reset,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: const Icon(Icons.refresh_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                  ],
                ).animate().fadeIn(duration: 350.ms),

                SizedBox(height: 20 * sf),

                // ── Subtitle + big title ─────────────────────────
                Text(
                  'Section 236AA / 236Y',
                  style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.60),
                      letterSpacing: 0.4),
                ),
                SizedBox(height: 5 * sf),
                Text(
                  'Remittance Tax\nCalculator',
                  style: GoogleFonts.sora(
                      fontSize: 28 * sf,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -1.2),
                ),
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

// ── Input Card ──────────────────────────────────────────────────────────────
class _InputCard extends StatelessWidget {
  final RemittanceTaxController ctrl;
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
              AppColors.remitTeal.withOpacity(0.10),
              AppColors.primaryViolet.withOpacity(0.05),
            ])
                : LinearGradient(colors: [
              Colors.white.withOpacity(0.92),
              Colors.white.withOpacity(0.80),
            ]),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? AppColors.remitTeal.withOpacity(0.28)
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
              // Card header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.remitGrad),
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.remitTeal.withOpacity(0.40),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.swap_horiz_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 11),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remittance Details',
                          style: GoogleFonts.sora(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0D0D1A),
                              letterSpacing: -0.2)),
                      Text('Select channel and enter amount',
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

              // ── Direction Tabs: Inward / Outward ─────────────────
              Text('Direction',
                  style: GoogleFonts.sora(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textGrey1
                          : AppColors.textGrey2,
                      letterSpacing: 0.3)),
              const SizedBox(height: 8),
              _DirectionTabs(ctrl: ctrl, isDark: isDark),

              const SizedBox(height: 14),

              // ── Channel dropdown ─────────────────────────────────
              Text('Channel',
                  style: GoogleFonts.sora(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textGrey1
                          : AppColors.textGrey2,
                      letterSpacing: 0.3)),
              const SizedBox(height: 8),
              _ChannelDropdown(ctrl: ctrl, isDark: isDark),

              const SizedBox(height: 14),

              // ── Filer toggle ─────────────────────────────────────
              _FilerToggle(ctrl: ctrl, isDark: isDark),

              const SizedBox(height: 14),

              // ── Amount input ─────────────────────────────────────
              Text('Remittance Amount (PKR)',
                  style: GoogleFonts.sora(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textGrey1
                          : AppColors.textGrey2,
                      letterSpacing: 0.3)),
              const SizedBox(height: 8),
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
                        ? AppColors.remitTeal.withOpacity(0.45)
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
                            color: AppColors.remitTeal)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: ctrl.amountController,
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
                          hintText: '500,000',
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
                    Text('PKR',
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
                        ? 'Live calculation active'
                        : 'Select channel above, then enter amount',
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

// ── Inward / Outward direction tabs ─────────────────────────────────────────
class _DirectionTabs extends StatelessWidget {
  final RemittanceTaxController ctrl;
  final bool isDark;
  const _DirectionTabs({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isInward = ctrl.isInward;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _Tab(
            label: 'Inward',
            icon: Icons.call_received_rounded,
            isSelected: isInward,
            color: AppColors.remitTeal,
            isDark: isDark,
            onTap: () => ctrl.setChannel(RemittanceTaxService.inwardBankFiler),
          ),
          const SizedBox(width: 4),
          _Tab(
            label: 'Outward',
            icon: Icons.call_made_rounded,
            isSelected: !isInward,
            color: AppColors.whtOrange,
            isDark: isDark,
            onTap: () =>
                ctrl.setChannel(RemittanceTaxService.outwardCardFiler),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(isDark ? 0.20 : 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: color.withOpacity(0.35), width: 1)
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 13,
                  color: isSelected
                      ? color
                      : (isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? color
                      : (isDark
                      ? AppColors.textGrey1
                      : AppColors.textGrey2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Channel Dropdown ─────────────────────────────────────────────────────────
class _ChannelDropdown extends StatelessWidget {
  final RemittanceTaxController ctrl;
  final bool isDark;
  const _ChannelDropdown({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final channels = ctrl.isInward
        ? ctrl.inwardChannels
        : ctrl.outwardChannels;
    final accent = ctrl.isInward ? AppColors.remitTeal : AppColors.whtOrange;

    // Ensure the selectedChannel is valid in current list
    final selectedValue = channels.contains(ctrl.selectedChannel)
        ? ctrl.selectedChannel
        : channels.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : AppColors.lightElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? accent.withOpacity(0.20)
                  : AppColors.lightBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              dropdownColor:
              isDark ? AppColors.darkElevated : AppColors.lightSurface,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: accent, size: 20),
              style: GoogleFonts.sora(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textWhite : AppColors.textDark,
              ),
              items: channels
                  .map((key) => DropdownMenuItem(
                value: key,
                child: Text(RemittanceTaxService.labelFor(key)),
              ))
                  .toList(),
              onChanged: (v) {
                if (v != null) ctrl.setChannel(v);
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── Filer / Non-Filer toggle chip ────────────────────────────────────────────
class _FilerToggle extends StatelessWidget {
  final RemittanceTaxController ctrl;
  final bool isDark;
  const _FilerToggle({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isFiler = ctrl.result.isFiler;
    return Row(
      children: [
        Text('Status:',
            style: GoogleFonts.sora(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color:
                isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: ctrl.toggleFilerStatus,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isFiler
                  ? AppColors.accentGreen.withOpacity(0.14)
                  : AppColors.accentRed.withOpacity(0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFiler
                    ? AppColors.accentGreen.withOpacity(0.35)
                    : AppColors.accentRed.withOpacity(0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isFiler
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isFiler ? 'Filer' : 'Non-Filer',
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isFiler
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.swap_horiz_rounded,
                    size: 13,
                    color: isFiler
                        ? AppColors.accentGreen
                        : AppColors.accentRed),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('tap to switch',
            style: GoogleFonts.sora(
                fontSize: 10,
                color: isDark
                    ? AppColors.textGrey2
                    : AppColors.textGrey1)),
      ],
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────────────────
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

// ── Net Amount Banner ─────────────────────────────────────────────────────────
class _NetBanner extends StatelessWidget {
  final RemittanceTaxController ctrl;
  final double sf;
  const _NetBanner({required this.ctrl, required this.sf});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: AppColors.remitGrad,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.remitTeal.withOpacity(0.35),
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
          // Top sheen line
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
                child: const Icon(Icons.account_balance_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ctrl.result.directionLabel,
                      style: GoogleFonts.sora(
                          fontSize: 11, color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(
                    'Rs ${_fmt(ctrl.result.netAmount)}',
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
                  Text('Tax',
                      style: GoogleFonts.sora(
                          fontSize: 10, color: Colors.white70)),
                  const SizedBox(height: 2),
                  Text('Rs ${_fmt(ctrl.result.taxWithheld)}',
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

// ── Status Pill ──────────────────────────────────────────────────────────────
class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});

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