import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/info_card.dart';

class RemittanceTaxScreen extends StatefulWidget {
  const RemittanceTaxScreen({super.key});

  @override
  State<RemittanceTaxScreen> createState() => _RemittanceTaxScreenState();
}

class _RemittanceTaxScreenState extends State<RemittanceTaxScreen> {
  final _amountCtrl = TextEditingController();
  String _channel = 'Bank Transfer (Filer)';
  double _tax = 0;
  double _net = 0;
  bool _hasResult = false;

  static const Map<String, double> _rates = {
    'Bank Transfer (Filer)': 0.01,
    'Bank Transfer (Non-Filer)': 0.02,
    'Exchange Company (Filer)': 0.01,
    'Exchange Company (Non-Filer)': 0.02,
    'Digital Transfer (Filer)': 0.005,
    'Digital Transfer (Non-Filer)': 0.01,
  };

  void _calculate() {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    if (amount <= 0) return;
    setState(() {
      _tax = amount * (_rates[_channel] ?? 0.01);
      _net = amount - _tax;
      _hasResult = true;
    });
  }

  void _reset() {
    _amountCtrl.clear();
    setState(() => _hasResult = false);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
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
                      const LinearGradient(colors: AppColors.remitGrad),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remittance Tax',
                          style: GoogleFonts.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.textWhite
                                  : AppColors.textDark)),
                      Text('Section 236AA / 236Y',
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
                          Text('Transfer Channel',
                              style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textGrey1
                                      : AppColors.textDark2)),
                          const SizedBox(height: 8),
                          _buildDropdown(isDark),
                          const SizedBox(height: 14),
                          Text('Transfer Amount (PKR)',
                              style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textGrey1
                                      : AppColors.textDark2)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _amountCtrl,
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
                                hintText: '500,000',
                                prefixText: 'Rs  '),
                          ),
                          const SizedBox(height: 14),
                          GradientButton(
                            label: 'Calculate Remittance Tax',
                            onTap: _calculate,
                            colors: AppColors.remitGrad,
                            icon: Icons.send_rounded,
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

                      // Rate chip
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.remitTeal.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.remitTeal.withOpacity(0.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: AppColors.remitTeal, size: 16),
                            const SizedBox(width: 10),
                            Text(
                              'Rate: ${((_rates[_channel] ?? 0) * 100).toStringAsFixed(1)}% on transferred amount',
                              style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.remitTeal),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 80.ms),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              label: 'Tax Withheld',
                              value: 'Rs ${_tax.toStringAsFixed(0)}',
                              color: AppColors.accentRed,
                              icon: Icons.money_off_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InfoCard(
                              label: 'Net Received',
                              value: 'Rs ${_net.toStringAsFixed(0)}',
                              color: AppColors.accentGreen,
                              icon: Icons.account_balance_rounded,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 120.ms),

                      const SizedBox(height: 12),

                      // Net banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: AppColors.remitGrad),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.remitTeal.withOpacity(0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_rounded,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Recipient Gets',
                                    style: GoogleFonts.sora(
                                        fontSize: 11,
                                        color: Colors.white70)),
                                const SizedBox(height: 3),
                                Text(
                                  'Rs ${_net.toStringAsFixed(0)}',
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

                      const SizedBox(height: 12),
                      _buildRateTable(isDark)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms),
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

  Widget _buildDropdown(bool isDark) {
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
          value: _channel,
          dropdownColor:
          isDark ? AppColors.darkElevated : AppColors.lightSurface,
          style: GoogleFonts.sora(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textWhite : AppColors.textDark),
          items: _rates.keys
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _channel = v!),
        ),
      ),
    );
  }

  Widget _buildRateTable(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Remittance Tax Rates',
              style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textWhite : AppColors.textDark)),
          const SizedBox(height: 10),
          ..._rates.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(e.key,
                      style: GoogleFonts.sora(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textGrey1
                              : AppColors.textDark2)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.remitTeal.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(e.value * 100).toStringAsFixed(1)}%',
                    style: GoogleFonts.sora(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.remitTeal),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
