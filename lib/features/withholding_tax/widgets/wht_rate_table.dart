import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../services/withholding_tax_service.dart';

/// Full reference rate table for all WHT types — mirrors TaxSlabTable
class WhtRateTable extends StatelessWidget {
  final String activeType;
  const WhtRateTable({super.key, required this.activeType});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rows = WithholdingTaxService.referenceRates;

    // Group rows by category
    final Map<String, List<WhtRateRow>> grouped = {};
    for (final r in rows) {
      grouped.putIfAbsent(r.category, () => []).add(r);
    }

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
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.whtGrad),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.whtOrange.withOpacity(0.35),
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
                    'WHT Reference Rates',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textWhite : AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.whtOrange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.whtOrange.withOpacity(0.28)),
                    ),
                    child: Text(
                      'FBR 2025-26',
                      style: GoogleFonts.sora(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.whtOrange),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Column headers
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text('Type',
                          style: GoogleFonts.sora(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textGrey2
                                  : AppColors.textGrey1,
                              letterSpacing: 0.4)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Section',
                          style: GoogleFonts.sora(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textGrey2
                                  : AppColors.textGrey1,
                              letterSpacing: 0.4)),
                    ),
                    SizedBox(
                      width: 52,
                      child: Text('Rate',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.sora(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textGrey2
                                  : AppColors.textGrey1,
                              letterSpacing: 0.4)),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.whtOrange.withOpacity(0.40),
                    AppColors.whtOrange.withOpacity(0.05),
                  ]),
                ),
              ),

              // Grouped rows
              ...grouped.entries.expand((entry) {
                return [
                  // Category header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 4),
                    child: Text(
                      entry.key.toUpperCase(),
                      style: GoogleFonts.sora(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isDark
                              ? AppColors.textGrey2
                              : AppColors.textGrey1),
                    ),
                  ),
                  ...entry.value.map((row) {
                    final isActive = row.label == activeType;
                    final isNonFiler = row.label.contains('Non-Filer');
                    return _RateRow(
                      row: row,
                      isActive: isActive,
                      isNonFiler: isNonFiler,
                      isDark: isDark,
                    );
                  }),
                  const SizedBox(height: 4),
                ];
              }),

              const SizedBox(height: 6),

              // Footer
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 10,
                      color:
                      isDark ? AppColors.textGrey2 : AppColors.textGrey1),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Non-filer rates are typically 2× filer rates. Consult FBR for threshold-based exemptions.',
                      style: GoogleFonts.sora(
                          fontSize: 9,
                          color: isDark
                              ? AppColors.textGrey2
                              : AppColors.textGrey1),
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

class _RateRow extends StatelessWidget {
  final WhtRateRow row;
  final bool isActive;
  final bool isNonFiler;
  final bool isDark;

  const _RateRow({
    required this.row,
    required this.isActive,
    required this.isNonFiler,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.whtOrange.withOpacity(0.14)
            : isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.025),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive
              ? AppColors.whtOrange.withOpacity(0.38)
              : Colors.transparent,
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                if (isActive)
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(
                        color: AppColors.whtOrange, shape: BoxShape.circle),
                  ),
                Expanded(
                  child: Text(
                    row.label,
                    style: GoogleFonts.sora(
                      fontSize: 11,
                      fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive
                          ? AppColors.whtOrange
                          : isDark
                          ? AppColors.textGrey1
                          : AppColors.textGrey2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              row.section,
              style: GoogleFonts.sora(
                fontSize: 10,
                color: isDark ? AppColors.textGrey2 : AppColors.textGrey1,
              ),
            ),
          ),
          SizedBox(
            width: 52,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isNonFiler
                      ? AppColors.accentRed.withOpacity(0.10)
                      : AppColors.accentGreen.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${row.ratePercent.toStringAsFixed(1)}%',
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? AppColors.whtOrange
                        : isNonFiler
                        ? AppColors.accentRed
                        : AppColors.accentGreen,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
