import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/info_card.dart';

class PtaTaxScreen extends StatefulWidget {
  const PtaTaxScreen({super.key});
  @override
  State<PtaTaxScreen> createState() => _PtaTaxScreenState();
}

class _PtaTaxScreenState extends State<PtaTaxScreen> {
  final _priceCtrl = TextEditingController();
  String _deviceType = 'Smartphone', _importStatus = 'Commercial Import';
  double _ptaTax = 0, _salesTax = 0, _customsDuty = 0, _totalTax = 0;
  bool _hasResult = false;

  static const Map<String, double> _ptaRates = {'Smartphone': 0.17, 'Feature Phone': 0.07, 'Tablet': 0.15, 'Laptop': 0.05};
  static const Map<String, double> _customsRates = {'Commercial Import': 0.20, 'Personal Baggage (Traveler)': 0.10, 'DIRBS Registration': 0.05};

  void _calculate() {
    final price = double.tryParse(_priceCtrl.text.replaceAll(',', '')) ?? 0;
    if (price <= 0) return;
    setState(() {
      _ptaTax      = price * (_ptaRates[_deviceType] ?? 0.17);
      _customsDuty = price * (_customsRates[_importStatus] ?? 0.20);
      _salesTax    = price * 0.18;
      _totalTax    = _ptaTax + _customsDuty + _salesTax;
      _hasResult   = true;
    });
  }

  void _reset() { _priceCtrl.clear(); setState(() => _hasResult = false); }
  @override
  void dispose() { _priceCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        children: [
          if (isDark)
            Positioned(top: -80, right: -60,
                child: Container(width: 240, height: 240,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [AppColors.ptaPurple.withOpacity(0.22), Colors.transparent])))),
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
                                color: isDark ? AppColors.ptaPurple.withOpacity(0.08) : Colors.white.withOpacity(0.82),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: isDark ? AppColors.ptaPurple.withOpacity(0.20) : Colors.white.withOpacity(0.90), width: 1.1),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Device Type', style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
                                const SizedBox(height: 8),
                                _buildDropdown(_deviceType, _ptaRates.keys.toList(), (v) => setState(() => _deviceType = v!), isDark),
                                const SizedBox(height: 14),
                                Text('Import Category', style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
                                const SizedBox(height: 8),
                                _buildDropdown(_importStatus, _customsRates.keys.toList(), (v) => setState(() => _importStatus = v!), isDark),
                                const SizedBox(height: 14),
                                Text('Device Price (PKR)', style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _priceCtrl,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w800, color: isDark ? AppColors.textWhite : AppColors.textDark, letterSpacing: -0.5),
                                  decoration: InputDecoration(hintText: '200,000', prefixText: 'Rs  ',
                                      prefixStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ptaPurple)),
                                ),
                                const SizedBox(height: 16),
                                GradientButton(label: 'Calculate PTA Tax', onTap: _calculate, colors: AppColors.ptaGrad, icon: Icons.phone_android_rounded),
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
                          Row(children: [
                            Expanded(child: InfoCard(label: 'PTA Regulatory', value: 'Rs ${_ptaTax.toStringAsFixed(0)}', color: AppColors.ptaPurple, icon: Icons.verified_user_rounded)),
                            const SizedBox(width: 12),
                            Expanded(child: InfoCard(label: 'Customs Duty', value: 'Rs ${_customsDuty.toStringAsFixed(0)}', color: AppColors.salaryBlue, icon: Icons.flight_land_rounded)),
                          ]).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(child: InfoCard(label: 'Sales Tax (GST)', value: 'Rs ${_salesTax.toStringAsFixed(0)}', color: AppColors.remitTeal, icon: Icons.receipt_rounded)),
                            const SizedBox(width: 12),
                            Expanded(child: InfoCard(label: 'Total Tax', value: 'Rs ${_totalTax.toStringAsFixed(0)}', color: AppColors.accentRed, icon: Icons.summarize_rounded)),
                          ]).animate().fadeIn(duration: 400.ms, delay: 120.ms),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: AppColors.ptaGrad, begin: Alignment.topLeft, end: Alignment.bottomRight),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: AppColors.ptaPurple.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 7))],
                            ),
                            child: Row(children: [
                              Container(padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.20), borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.phone_android_rounded, color: Colors.white, size: 20)),
                              const SizedBox(width: 14),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Total Device Cost', style: GoogleFonts.spaceGrotesk(fontSize: 11, color: Colors.white70)),
                                const SizedBox(height: 2),
                                Text('Rs ${(_totalTax + (double.tryParse(_priceCtrl.text.replaceAll(',', '')) ?? 0)).toStringAsFixed(0)}',
                                    style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.6)),
                              ]),
                            ]),
                          ).animate().fadeIn(duration: 400.ms, delay: 160.ms),
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
            decoration: BoxDecoration(gradient: const LinearGradient(colors: AppColors.ptaGrad), borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AppColors.ptaPurple.withOpacity(0.40), blurRadius: 14, offset: const Offset(0, 4))]),
            child: const Icon(Icons.phone_android_rounded, color: Colors.white, size: 17)),
        const SizedBox(width: 11),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('PTA Device Tax', style: GoogleFonts.spaceGrotesk(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? AppColors.textWhite : AppColors.textDark, letterSpacing: -0.3)),
          Text('Regulatory Duty + GST + Customs', style: GoogleFonts.spaceGrotesk(fontSize: 11, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
        ]),
      ]),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChange, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, value: value,
          dropdownColor: isDark ? AppColors.darkElevated : AppColors.lightSurface,
          style: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.textWhite : AppColors.textDark),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChange,
        ),
      ),
    );
  }
}
