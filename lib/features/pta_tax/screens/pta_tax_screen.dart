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
  String _deviceType = 'Smartphone';
  String _importStatus = 'Commercial Import';

  double _ptaTax = 0;
  double _salesTax = 0;
  double _customsDuty = 0;
  double _totalTax = 0;
  bool _hasResult = false;

  static const Map<String, double> _ptaRates = {
    'Smartphone': 0.17,
    'Feature Phone': 0.07,
    'Tablet': 0.15,
    'Laptop': 0.05,
  };

  static const Map<String, double> _customsRates = {
    'Commercial Import': 0.20,
    'Personal Baggage (Traveler)': 0.10,
    'DIRBS Registration': 0.05,
  };

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

  void _reset() {
    _priceCtrl.clear();
    setState(() => _hasResult = false);
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 10, 18, 0),
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
                      gradient:
                      const LinearGradient(colors: AppColors.ptaGrad),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.phone_android_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PTA Device Tax',
                          style: GoogleFonts.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.textWhite
                                  : AppColors.textDark)),
                      Text('Regulatory Duty + GST + Customs',
                          style: GoogleFonts.sora(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textGrey1
                                  : AppColors.textDark2)),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Device Type',
                              style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textGrey1
                                      : AppColors.textDark2)),
                          const SizedBox(height: 8),
                          _buildDropdown(
                              _deviceType,
                              _ptaRates.keys.toList(),
                                  (v) => setState(() => _deviceType = v!),
                              isDark),
                          const SizedBox(height: 14),
                          Text('Import Category',
                              style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textGrey1
                                      : AppColors.textDark2)),
                          const SizedBox(height: 8),
                          _buildDropdown(
                              _importStatus,
                              _customsRates.keys.toList(),
                                  (v) => setState(() => _importStatus = v!),
                              isDark),
                          const SizedBox(height: 14),
                          Text('Device Price (PKR)',
                              style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textGrey1
                                      : AppColors.textDark2)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _priceCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: GoogleFonts.sora(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textWhite
                                  : AppColors.textDark,
                            ),
                            decoration: const InputDecoration(
                                hintText: '200,000',
                                prefixText: 'Rs  '),
                          ),
                          const SizedBox(height: 14),
                          GradientButton(
                            label: 'Calculate PTA Tax',
                            onTap: _calculate,
                            colors: AppColors.ptaGrad,
                            icon: Icons.phone_android_rounded,
                          ),
                          if (_hasResult) ...[
                            const SizedBox(height: 10),
                            Center(
                              child: GestureDetector(
                                onTap: _reset,
                                child: Text('Reset',
                                    style: GoogleFonts.sora(
                                        fontSize: 13,
                                        color: isDark
                                            ? AppColors.textGrey1
                                            : AppColors.textDark2)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08),

                    if (_hasResult) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              label: 'PTA Regulatory',
                              value: 'Rs ${_ptaTax.toStringAsFixed(0)}',
                              color: AppColors.ptaPurple,
                              icon: Icons.verified_user_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InfoCard(
                              label: 'Customs Duty',
                              value: 'Rs ${_customsDuty.toStringAsFixed(0)}',
                              color: AppColors.salaryBlue,
                              icon: Icons.flight_land_rounded,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              label: 'Sales Tax (GST)',
                              value: 'Rs ${_salesTax.toStringAsFixed(0)}',
                              color: AppColors.remitTeal,
                              icon: Icons.receipt_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InfoCard(
                              label: 'Total Tax',
                              value: 'Rs ${_totalTax.toStringAsFixed(0)}',
                              color: AppColors.accentRed,
                              icon: Icons.summarize_rounded,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 120.ms),

                      const SizedBox(height: 12),

                      // Total cost banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: AppColors.ptaGrad),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ptaPurple.withOpacity(0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.phone_android_rounded,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Device Cost',
                                    style: GoogleFonts.sora(
                                        fontSize: 11,
                                        color: Colors.white70)),
                                const SizedBox(height: 3),
                                Text(
                                  'Rs ${(_totalTax + (double.tryParse(_priceCtrl.text.replaceAll(',', '')) ?? 0)).toStringAsFixed(0)}',
                                  style: GoogleFonts.sora(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    );
  }

  Widget _buildDropdown(String value, List<String> items,
      ValueChanged<String?> onChange, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          dropdownColor:
          isDark ? AppColors.darkElevated : AppColors.lightSurface,
          style: GoogleFonts.sora(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textWhite : AppColors.textDark),
          items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChange,
        ),
      ),
    );
  }
}
