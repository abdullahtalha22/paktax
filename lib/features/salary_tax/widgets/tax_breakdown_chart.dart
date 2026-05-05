import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/salary_tax_model.dart';

class TaxBreakdownChart extends StatelessWidget {
  final SalaryTaxModel result;
  const TaxBreakdownChart({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taxPct = result.effectiveTaxRate / 100;
    final netPct = 1 - taxPct;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Breakdown',
            style: GoogleFonts.sora(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: (netPct * 100).round(),
                  child: Container(height: 10, color: AppColors.accentGreen),
                ),
                Expanded(
                  flex: (taxPct * 100).round().clamp(1, 100),
                  child: Container(height: 10, color: AppColors.accentRed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _dot(AppColors.accentGreen, 'Net Salary',
                  'Rs ${_fmt(result.netMonthly)}/mo'),
              const Spacer(),
              _dot(AppColors.accentRed, 'Tax',
                  'Rs ${_fmt(result.monthlyTax)}/mo'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: GoogleFonts.sora(fontSize: 10, color: AppColors.textGrey1)),
          Text(value,
              style: GoogleFonts.sora(
                  fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ]),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    return v.toStringAsFixed(0);
  }
}