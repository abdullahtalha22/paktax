import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/remittance_tax_model.dart';
import '../services/remittance_tax_service.dart';

/// Full reference rate table for remittance tax — mirrors WhtRateTable.
/// Fixes: uses channelKey matching (no indexOf) to avoid RangeError.
class RemittanceRateTable extends StatelessWidget {
  final String activeChannelKey;
  const RemittanceRateTable({super.key, required this.activeChannelKey});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inwardRows  = _buildRows(RemittanceTaxService.inwardChannels);
    final outwardRows = _buildRows(RemittanceTaxService.outwardChannels);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.04)
                : Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.92),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.20)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Table Header ─────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.remitGrad),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.remitTeal.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.table_chart_rounded,
                        color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Remittance Tax Rates',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.remitTeal.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.remitTeal.withOpacity(0.28)),
                    ),
                    child: Text(
                      'FBR 2025-26',
                      style: GoogleFonts.sora(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.remitTeal),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Inward Section (236AA) ────────────────────────────────────
              _SectionHeader(
                label: 'Inward Remittances',
                sectionRef: 'Section 236AA',
                icon: Icons.call_received_rounded,
                color: AppColors.remitTeal,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              ...inwardRows.map((e) => _RateRow(
                row: e.row,
                isActive: e.channelKey == activeChannelKey,
                isDark: isDark,
              )),

              const SizedBox(height: 14),
              Divider(
                color: isDark
                    ? Colors.white.withOpacity(0.07)
                    : Colors.black.withOpacity(0.06),
                height: 1,
              ),
              const SizedBox(height: 14),

              // ── Outward Section (236Y) ────────────────────────────────────
              _SectionHeader(
                label: 'Outward (Card) Remittances',
                sectionRef: 'Section 236Y',
                icon: Icons.call_made_rounded,
                color: AppColors.whtOrange,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              ...outwardRows.map((e) => _RateRow(
                row: e.row,
                isActive: e.channelKey == activeChannelKey,
                isDark: isDark,
              )),

              const SizedBox(height: 14),

              // ── Section 111(4) Inward Exemption notice ───────────────────
              _InwardExemptionBanner(isDark: isDark),

              const SizedBox(height: 10),

              // ── Finance Act 2025 change notice ───────────────────────────
              _FA2025Banner(isDark: isDark),

              const SizedBox(height: 12),

              // ── Adjustable tax disclaimer ─────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded,
                        size: 12,
                        color: isDark
                            ? AppColors.textGrey1
                            : AppColors.textGrey2),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tax under both 236AA and 236Y is adjustable — set off against your annual income tax liability when you file your return.',
                        style: GoogleFonts.sora(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textGrey1
                              : AppColors.textGrey2,
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
    );
  }

  /// Build rows paired with their channel key — avoids the indexOf() RangeError.
  static List<_RowEntry> _buildRows(List<String> channelKeys) {
    final allRates = RemittanceTaxService.referenceRates;
    return channelKeys.map((key) {
      final label = RemittanceTaxService.labelFor(key);
      final row = allRates.firstWhere(
            (r) => r.label == label,
        orElse: () => allRates.first,
      );
      return _RowEntry(channelKey: key, row: row);
    }).toList();
  }
}

// ── Internal helper ───────────────────────────────────────────────────────────
class _RowEntry {
  final String channelKey;
  final RemittanceRateRow row;
  const _RowEntry({required this.channelKey, required this.row});
}

// ── Section 111(4) Inward Exemption Banner ───────────────────────────────────
class _InwardExemptionBanner extends StatelessWidget {
  final bool isDark;
  const _InwardExemptionBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.remitTeal.withOpacity(isDark ? 0.08 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.remitTeal.withOpacity(0.25), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.remitTeal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(Icons.shield_outlined,
                size: 12, color: AppColors.remitTeal),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inward Remittance — Section 111(4) Exemption',
                  style: GoogleFonts.sora(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.remitTeal,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Personal and family remittances received through official banking channels are exempt from income tax under Sec 111(4) ITO 2001 — up to approx. USD \$100,000 per year with no source disclosure required.',
                  style: GoogleFonts.sora(
                    fontSize: 10,
                    height: 1.45,
                    color: isDark
                        ? AppColors.textGrey1
                        : AppColors.textGrey2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '⚠ The bank still deducts 236AA at source. Since it is adjustable, file your annual return to reclaim the full amount.',
                  style: GoogleFonts.sora(
                    fontSize: 10,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textGrey1
                        : AppColors.textGrey2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── FA 2025 change notice banner ──────────────────────────────────────────────
class _FA2025Banner extends StatelessWidget {
  final bool isDark;
  const _FA2025Banner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.whtOrange.withOpacity(isDark ? 0.08 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.whtOrange.withOpacity(0.25), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.whtOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(Icons.info_outline_rounded,
                size: 12, color: AppColors.whtOrange),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Finance Act 2025 — Section 236Y Update',
                  style: GoogleFonts.sora(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whtOrange,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'The non-filer rate on outward card remittances (236Y) was reduced from 10% back to 2%, effective 1 July 2025 under Finance Act 2025. Becoming a Filer (ATL) reduces your rate to 1%.',
                  style: GoogleFonts.sora(
                    fontSize: 10,
                    height: 1.45,
                    color: isDark
                        ? AppColors.textGrey1
                        : AppColors.textGrey2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final String sectionRef;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _SectionHeader({
    required this.label,
    required this.sectionRef,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.sora(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textWhite : AppColors.textDark,
          ),
        ),
        const Spacer(),
        Text(
          sectionRef,
          style: GoogleFonts.sora(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
          ),
        ),
      ],
    );
  }
}

// ── Rate Row ──────────────────────────────────────────────────────────────────
class _RateRow extends StatelessWidget {
  final RemittanceRateRow row;
  final bool isActive;
  final bool isDark;

  const _RateRow({
    required this.row,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accent = row.direction == RemittanceDirection.inward
        ? AppColors.remitTeal
        : AppColors.whtOrange;
    final isFiler = !row.label.contains('Non-Filer');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? accent.withOpacity(0.10)
            : (isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.02)),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
          isActive ? accent.withOpacity(0.30) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Filer / Non-Filer pill
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isFiler
                      ? AppColors.accentGreen.withOpacity(0.12)
                      : AppColors.accentRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isFiler ? 'F' : 'NF',
                  style: GoogleFonts.sora(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isFiler
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  row.label,
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isDark
                        ? (isActive
                        ? AppColors.textWhite
                        : AppColors.textGrey1)
                        : (isActive
                        ? AppColors.textDark
                        : AppColors.textGrey2),
                  ),
                ),
              ),
              // Rate badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withOpacity(isActive ? 0.18 : 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${row.ratePercent.toStringAsFixed(1)}%',
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          // Note line (only shown if note is not empty)
          if (row.note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                row.note,
                style: GoogleFonts.sora(
                  fontSize: 9.5,
                  color: isDark
                      ? AppColors.textGrey2
                      : AppColors.textGrey1,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}