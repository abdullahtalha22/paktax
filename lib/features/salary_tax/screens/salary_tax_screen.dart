import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../controllers/salary_tax_controller.dart';
import '../widgets/tax_slab_table.dart';
import '../widgets/tax_breakdown_chart.dart';

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
    final ctrl   = context.watch<SalaryTaxController>();

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputCard(ctrl, isDark)
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.06, end: 0),

                    if (ctrl.hasCalculated && ctrl.result != null) ...[
                      const SizedBox(height: 16),
                      _resultGrid(ctrl, isDark)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 60.ms),
                      const SizedBox(height: 14),
                      _netBanner(ctrl)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 100.ms),
                      const SizedBox(height: 14),
                      TaxBreakdownChart(result: ctrl.result!)
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 140.ms),
                      const SizedBox(height: 14),
                      const TaxSlabTable()
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 180.ms),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────
  Widget _appBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 18, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: isDark ? AppColors.textWhite : AppColors.textDark,
                size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.salaryGrad),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Salary Tax',
                style: GoogleFonts.dmSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textWhite : AppColors.textDark,
                    letterSpacing: -0.3)),
            Text('FBR Tax Year 2025–26',
                style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
          ]),
        ],
      ),
    );
  }

  // ── Input card ────────────────────────────────────────────────────────────
  Widget _inputCard(SalaryTaxController ctrl, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Monthly Gross Salary',
            style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
                letterSpacing: 0.2)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl.salaryController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
              letterSpacing: -0.3),
          decoration: InputDecoration(
            hintText: '150,000',
            prefixText: 'Rs  ',
            prefixStyle: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.salaryBlue),
            suffixText: '/ mo',
            suffixStyle: GoogleFonts.dmSans(
                fontSize: 12,
                color: isDark ? AppColors.textGrey2 : AppColors.textGrey1),
          ),
        ),
        const SizedBox(height: 14),
        GradientButton(
          label: 'Calculate Tax',
          onTap: ctrl.calculate,
          colors: AppColors.salaryGrad,
          icon: Icons.calculate_rounded,
        ),
        if (ctrl.hasCalculated) ...[
          const SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: ctrl.reset,
              child: Text('Reset',
                  style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ]),
    );
  }

  // ── Result grid ───────────────────────────────────────────────────────────
  Widget _resultGrid(SalaryTaxController ctrl, bool isDark) {
    final r = ctrl.result!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Tax Results',
            style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : AppColors.textDark)),
        const SizedBox(width: 8),
        _pill(r.taxSlab,
            r.isTaxExempt ? AppColors.accentGreen : AppColors.salaryBlue),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
            child: _statCard('Monthly Tax', _fmt(r.monthlyTax),
                AppColors.salaryBlue, Icons.calendar_month_rounded, isDark)),
        const SizedBox(width: 11),
        Expanded(
            child: _statCard('Annual Tax', _fmt(r.annualTax),
                AppColors.accentRed, Icons.receipt_long_rounded, isDark)),
      ]),
      const SizedBox(height: 11),
      Row(children: [
        Expanded(
            child: _statCard('Net Monthly', _fmt(r.netMonthly),
                AppColors.accentGreen, Icons.account_balance_wallet_rounded, isDark)),
        const SizedBox(width: 11),
        Expanded(
            child: _statCard(
                'Effective Rate',
                '${r.effectiveTaxRate.toStringAsFixed(1)}%',
                AppColors.whtOrange,
                Icons.percent_rounded,
                isDark)),
      ]),
    ]);
  }

  Widget _statCard(String label, String value, Color color, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 13),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: isDark ? AppColors.textGrey1 : AppColors.textGrey2),
                overflow: TextOverflow.ellipsis),
          ),
        ]),
        const SizedBox(height: 9),
        Text(value,
            style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.3)),
      ]),
    );
  }

  // ── Net banner ────────────────────────────────────────────────────────────
  Widget _netBanner(SalaryTaxController ctrl) {
    final r = ctrl.result!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.greenGrad),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.accentGreen.withOpacity(0.22),
              blurRadius: 14,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Row(children: [
        const Icon(Icons.verified_rounded, color: Colors.white, size: 22),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Annual Net Take-Home',
              style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white70)),
          const SizedBox(height: 2),
          Text('Rs ${_fmt(r.netAnnual)}',
              style: GoogleFonts.dmSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5)),
        ]),
      ]),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: GoogleFonts.dmSans(
              fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }

  String _fmt(double v) {
    if (v == 0) return '0';
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(2)} L';
    return v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}