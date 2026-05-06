import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class TaxSlabTable extends StatelessWidget {
  const TaxSlabTable({super.key});

  static const List<_Slab> slabs = [
    _Slab('Up to Rs 600,000', '0%', 'Exempt', AppColors.accentGreen),
    _Slab('Rs 600,001 – 1,200,000', '5%', 'Slab 2', AppColors.salaryBlue),
    _Slab('Rs 1,200,001 – 2,200,000', '15%', 'Slab 3', AppColors.remitTeal),
    _Slab('Rs 2,200,001 – 3,200,000', '25%', 'Slab 4', AppColors.whtOrange),
    _Slab('Rs 3,200,001 – 4,100,000', '30%', 'Slab 5', AppColors.accentRed),
    _Slab('Above Rs 4,100,000', '35%', 'Slab 6', Color(0xFFFF2D6B)),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient:
                    const LinearGradient(colors: AppColors.salaryGrad),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.salaryBlue.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.table_chart_rounded,
                      color: Colors.white, size: 14),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FBR Slab Rates 2025–26',
                        style: GoogleFonts.sora(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textWhite
                                : AppColors.textDark)),
                    Text('Salaried Persons · Finance Act 2025',
                        style: GoogleFonts.sora(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textGrey2
                                : AppColors.textGrey1)),
                  ],
                ),
              ]),
              const SizedBox(height: 16),
              ...slabs.asMap().entries.map(
                    (e) => _SlabRow(
                    slab: e.value,
                    isDark: isDark,
                    isLast: e.key == slabs.length - 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlabRow extends StatelessWidget {
  final _Slab slab;
  final bool isDark;
  final bool isLast;
  const _SlabRow(
      {required this.slab, required this.isDark, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            // Color bar
            Container(
              width: 4,
              height: 36,
              decoration: BoxDecoration(
                color: slab.color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: slab.color.withOpacity(0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Tag
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: slab.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(slab.tag,
                  style: GoogleFonts.sora(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: slab.color)),
            ),
            const SizedBox(width: 10),
            // Range
            Expanded(
              child: Text(slab.range,
                  style: GoogleFonts.sora(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textGrey1
                          : AppColors.textGrey2,
                      height: 1.3)),
            ),
            // Rate badge
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: slab.color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: slab.color.withOpacity(0.28), width: 1),
              ),
              child: Text(slab.rate,
                  style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: slab.color)),
            ),
          ]),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
      ],
    );
  }
}

class _Slab {
  final String range, rate, tag;
  final Color color;
  const _Slab(this.range, this.rate, this.tag, this.color);
}