import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class TaxSlabTable extends StatelessWidget {
  const TaxSlabTable({super.key});

  static const List<_Slab> slabs = [
    _Slab('Up to Rs 600,000',         '0%',  AppColors.accentGreen),
    _Slab('Rs 600,001 – 1,200,000',   '5%',  AppColors.salaryBlue),
    _Slab('Rs 1,200,001 – 2,200,000', '15%', AppColors.remitTeal),
    _Slab('Rs 2,200,001 – 3,200,000', '25%', AppColors.whtOrange),
    _Slab('Rs 3,200,001 – 4,100,000', '30%', AppColors.accentRed),
    _Slab('Above Rs 4,100,000',       '35%', Color(0xFFB71C1C)),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          Row(
            children: [
              Icon(Icons.table_chart_rounded,
                  color: AppColors.salaryBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                'FBR Slab Rates 2025–26',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textWhite : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...slabs.map((s) => _SlabRow(slab: s, isDark: isDark)),
        ],
      ),
    );
  }
}

class _SlabRow extends StatelessWidget {
  final _Slab slab;
  final bool isDark;

  const _SlabRow({required this.slab, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: slab.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              slab.range,
              style: GoogleFonts.sora(
                fontSize: 11,
                color: isDark ? AppColors.textGrey1 : AppColors.textDark2,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: slab.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              slab.rate,
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: slab.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slab {
  final String range;
  final String rate;
  final Color color;
  const _Slab(this.range, this.rate, this.color);
}
