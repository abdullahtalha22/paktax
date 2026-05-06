import 'dart:ui';
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
    final bool isEmpty = result.annualSalary == 0;
    final double taxPct =
    isEmpty ? 0.0 : (result.effectiveTaxRate / 100).clamp(0.0, 1.0);
    final double netPct = (1 - taxPct).clamp(0.01, 1.0);
    final int taxFlex = isEmpty ? 0 : (taxPct * 100).round().clamp(1, 99);
    final int netFlex = (100 - taxFlex).clamp(1, 100);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.92),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.18)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 18,
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
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.salaryGrad),
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.salaryBlue.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.pie_chart_rounded,
                        color: Colors.white, size: 13),
                  ),
                  const SizedBox(width: 10),
                  Text('Monthly Breakdown',
                      style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textWhite
                              : AppColors.textDark)),
                ],
              ),
              const SizedBox(height: 18),

              // Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: isEmpty
                    ? Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('Enter salary to see breakdown',
                        style: GoogleFonts.sora(
                            fontSize: 8,
                            color: isDark
                                ? AppColors.textGrey2
                                : AppColors.textGrey1)),
                  ),
                )
                    : Row(
                  children: [
                    Expanded(
                      flex: netFlex,
                      child: Container(
                        height: 12,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: AppColors.greenGrad),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10)),
                        ),
                      ),
                    ),
                    if (taxFlex > 0)
                      Expanded(
                        flex: taxFlex,
                        child: Container(
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.accentRed,
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              Row(
                children: [
                  _dot(
                    AppColors.accentGreen,
                    'Net Salary',
                    isEmpty ? 'Rs 0 /mo' : 'Rs ${_fmt(result.netMonthly)}/mo',
                  ),
                  const Spacer(),
                  _dot(
                    AppColors.accentRed,
                    'Tax',
                    isEmpty ? 'Rs 0 /mo' : 'Rs ${_fmt(result.monthlyTax)}/mo',
                  ),
                ],
              ),

              if (!isEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.04)
                        : AppColors.lightElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : AppColors.lightBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoItem(
                        'Annual Salary',
                        'Rs ${_fmt(result.annualSalary)}',
                        isDark,
                        AppColors.salaryBlue,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.07),
                      ),
                      _infoItem(
                        'Annual Tax',
                        'Rs ${_fmt(result.annualTax)}',
                        isDark,
                        AppColors.accentRed,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.07),
                      ),
                      _infoItem(
                        'Marginal Rate',
                        '${result.marginalRate.toStringAsFixed(0)}%',
                        isDark,
                        AppColors.whtOrange,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color, String label, String value) {
    return Row(children: [
      Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 7),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: GoogleFonts.sora(
                fontSize: 10, color: AppColors.textGrey1)),
        Text(value,
            style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color)),
      ]),
    ]);
  }

  Widget _infoItem(
      String label, String value, bool isDark, Color color) {
    return Column(children: [
      Text(label,
          style: GoogleFonts.sora(
              fontSize: 9,
              color:
              isDark ? AppColors.textGrey2 : AppColors.textGrey1)),
      const SizedBox(height: 3),
      Text(value,
          style: GoogleFonts.sora(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color)),
    ]);
  }

  static String _fmt(double v) {
    if (v == 0) return '0';
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    return v
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},');
  }
}