import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/withholding_tax_model.dart';

/// Visual breakdown chart for WHT — shows Tax vs Net split as an arc chart
class WhtBreakdownChart extends StatelessWidget {
  final WithholdingTaxModel result;
  const WhtBreakdownChart({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gross = result.grossAmount;
    final hasData = gross > 0;
    final taxFraction = hasData ? (result.taxDeducted / gross).clamp(0.0, 1.0) : 0.0;
    final netFraction = 1.0 - taxFraction;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
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
                    ? Colors.black.withOpacity(0.22)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
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
                    child: const Icon(Icons.donut_small_rounded,
                        color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Payment Breakdown',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textWhite : AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Arc chart + legend side by side
              Row(
                children: [
                  // Arc chart
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: _ArcPainter(
                        taxFraction: taxFraction,
                        hasData: hasData,
                        isDark: isDark,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              hasData
                                  ? '${result.ratePercent.toStringAsFixed(1)}%'
                                  : '—',
                              style: GoogleFonts.sora(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.whtOrange,
                                letterSpacing: -0.6,
                              ),
                            ),
                            Text(
                              'WHT',
                              style: GoogleFonts.sora(
                                fontSize: 9,
                                color: isDark
                                    ? AppColors.textGrey1
                                    : AppColors.textGrey2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Legend
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendItem(
                          color: AppColors.whtOrange,
                          label: 'WHT Deducted',
                          value: _fmt(result.taxDeducted),
                          percent: '${(taxFraction * 100).toStringAsFixed(1)}%',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        _LegendItem(
                          color: AppColors.accentGreen,
                          label: 'Net Payment',
                          value: _fmt(result.netPayment),
                          percent: '${(netFraction * 100).toStringAsFixed(1)}%',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        _LegendItem(
                          color: AppColors.salaryBlue,
                          label: 'Gross Amount',
                          value: _fmt(result.grossAmount),
                          percent: '100%',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Section badge
              if (hasData) ...[
                const SizedBox(height: 16),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.whtOrange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.whtOrange.withOpacity(0.22)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppColors.whtOrange, size: 13),
                      const SizedBox(width: 8),
                      Text(
                        '${result.section} · ${result.ratePercent.toStringAsFixed(1)}% on gross · ${result.isFiler ? "Filer" : "Non-Filer"}',
                        style: GoogleFonts.sora(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whtOrange,
                        ),
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

  static String _fmt(double v) {
    if (v == 0) return 'Rs 0';
    if (v >= 10000000) return 'Rs ${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000) return 'Rs ${(v / 100000).toStringAsFixed(2)} L';
    return 'Rs ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }
}

// ── Arc painter ─────────────────────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  final double taxFraction;
  final bool hasData;
  final bool isDark;

  _ArcPainter({
    required this.taxFraction,
    required this.hasData,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 14.0;

    final trackPaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.07)
          : Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final taxPaint = Paint()
      ..shader = const LinearGradient(
        colors: AppColors.whtGrad,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final netPaint = Paint()
      ..shader = const LinearGradient(
        colors: AppColors.greenGrad,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 3
      ..strokeCap = StrokeCap.round;

    // Track (full circle)
    canvas.drawCircle(center, radius, trackPaint);

    if (!hasData) return;

    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;

    // Tax arc (orange)
    final taxSweep = 2 * math.pi * taxFraction;
    canvas.drawArc(rect, startAngle, taxSweep, false, taxPaint);

    // Net arc (green — starts after tax arc)
    final netSweep = 2 * math.pi * (1.0 - taxFraction);
    canvas.drawArc(rect, startAngle + taxSweep + 0.04, netSweep - 0.04, false,
        netPaint);
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.taxFraction != taxFraction || old.hasData != hasData;
}

// ── Legend item ─────────────────────────────────────────────────────────────
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String percent;
  final bool isDark;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    required this.percent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label ($percent)',
                style: GoogleFonts.sora(
                  fontSize: 10,
                  color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
