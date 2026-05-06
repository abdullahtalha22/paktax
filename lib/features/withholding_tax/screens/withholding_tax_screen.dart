import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/info_card.dart';

class WithholdingTaxScreen extends StatefulWidget {
  const WithholdingTaxScreen({super.key});
  @override
  State<WithholdingTaxScreen> createState() => _WithholdingTaxScreenState();
}

class _WithholdingTaxScreenState extends State<WithholdingTaxScreen> {
  final _amountCtrl = TextEditingController();
  String _selectedType = 'Contractor (Filer)';
  double _taxAmount = 0, _netAmount = 0;
  bool _hasResult = false;

  static const Map<String, double> _rates = {
    'Contractor (Filer)': 0.075,
    'Contractor (Non-Filer)': 0.15,
    'Supplier (Filer)': 0.04,
    'Supplier (Non-Filer)': 0.08,
    'Services (Filer)': 0.08,
    'Services (Non-Filer)': 0.16,
    'Rent (Filer)': 0.15,
    'Rent (Non-Filer)': 0.30,
  };

  void _calculate() {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    if (amount <= 0) return;
    final rate = _rates[_selectedType] ?? 0;
    setState(() { _taxAmount = amount * rate; _netAmount = amount - _taxAmount; _hasResult = true; });
  }

  void _reset() { _amountCtrl.clear(); setState(() => _hasResult = false); }

  @override
  void dispose() { _amountCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        children: [
          if (isDark) ...[
            Positioned(top: -80, right: -60,
                child: Container(width: 240, height: 240,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [AppColors.whtOrange.withOpacity(0.20), Colors.transparent])))),
          ],
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.whtOrange.withOpacity(0.08) : Colors.white.withOpacity(0.82),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: isDark ? AppColors.whtOrange.withOpacity(0.20) : Colors.white.withOpacity(0.90), width: 1.1),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Payment Type', style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
                                const SizedBox(height: 8),
                                _buildDropdown(isDark),
                                const SizedBox(height: 14),
                                Text('Payment Amount', style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _amountCtrl,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w800, color: isDark ? AppColors.textWhite : AppColors.textDark, letterSpacing: -0.5),
                                  decoration: InputDecoration(hintText: '500,000', prefixText: 'Rs  ',
                                      prefixStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.whtOrange)),
                                ),
                                const SizedBox(height: 16),
                                GradientButton(label: 'Calculate WHT', onTap: _calculate, colors: AppColors.whtGrad, icon: Icons.calculate_rounded),
                                if (_hasResult) ...[
                                  const SizedBox(height: 10),
                                  Center(child: GestureDetector(onTap: _reset,
                                      child: Text('Reset', style: GoogleFonts.spaceGrotesk(fontSize: 13, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)))),
                                ],
                              ]),
                            ),
                          ),
                        ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.06),

                        if (_hasResult) ...[
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.whtOrange.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.whtOrange.withOpacity(0.25)),
                                ),
                                child: Row(children: [
                                  Icon(Icons.info_outline_rounded, color: AppColors.whtOrange, size: 16),
                                  const SizedBox(width: 10),
                                  Text('Rate: ${((_rates[_selectedType] ?? 0) * 100).toStringAsFixed(1)}% on gross payment',
                                      style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.whtOrange)),
                                ]),
                              ),
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(child: InfoCard(label: 'WHT Deducted', value: 'Rs ${_taxAmount.toStringAsFixed(0)}', color: AppColors.accentRed, icon: Icons.remove_circle_rounded)),
                            const SizedBox(width: 12),
                            Expanded(child: InfoCard(label: 'Net Payment', value: 'Rs ${_netAmount.toStringAsFixed(0)}', color: AppColors.accentGreen, icon: Icons.payments_rounded)),
                          ]).animate().fadeIn(duration: 400.ms, delay: 120.ms),
                          const SizedBox(height: 12),
                          _buildRateTable(isDark).animate().fadeIn(duration: 400.ms, delay: 160.ms),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 12, 18, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: ClipRRect(borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(width: 38, height: 38,
                      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.07) : Colors.white.withOpacity(0.75), borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.90))),
                      child: Icon(Icons.arrow_back_ios_rounded, color: isDark ? AppColors.textWhite : AppColors.textDark, size: 16)))),
        ),
        const SizedBox(width: 12),
        Container(padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: AppColors.whtGrad), borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AppColors.whtOrange.withOpacity(0.40), blurRadius: 14, offset: const Offset(0, 4))]),
            child: const Icon(Icons.percent_rounded, color: Colors.white, size: 17)),
        const SizedBox(width: 11),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Withholding Tax', style: GoogleFonts.spaceGrotesk(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? AppColors.textWhite : AppColors.textDark, letterSpacing: -0.3)),
          Text('FBR Section 153 / 155', style: GoogleFonts.spaceGrotesk(fontSize: 11, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
        ]),
      ]),
    );
  }

  Widget _buildDropdown(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkElevated : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true, value: _selectedType,
              dropdownColor: isDark ? AppColors.darkElevated : AppColors.lightSurface,
              style: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.textWhite : AppColors.textDark),
              items: _rates.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedType = v!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRateTable(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.80),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.90), width: 1.1),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('WHT Reference Rates', style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.textWhite : AppColors.textDark)),
            const SizedBox(height: 12),
            ..._rates.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(children: [
                Expanded(child: Text(e.key, style: GoogleFonts.spaceGrotesk(fontSize: 11, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.whtOrange.withOpacity(0.10), borderRadius: BorderRadius.circular(20)),
                  child: Text('${(e.value * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.whtOrange)),
                ),
              ]),
            )),
          ]),
        ),
      ),
    );
  }
}
