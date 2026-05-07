import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pta_tax_model.dart';

// ── Number formatters ─────────────────────────────────────────────────────
String ptaFmt(double v) {
  if (v <= 0) return 'Rs 0';
  if (v >= 1000000) return 'Rs ${(v / 1000000).toStringAsFixed(2)}M';
  if (v >= 100000) return 'Rs ${(v / 1000).toStringAsFixed(0)}K';
  return 'Rs ${v.toStringAsFixed(0)}';
}

String ptaFmtFull(double v) {
  if (v <= 0) return 'Rs 0';
  final int rounded = v.round();
  final String s = rounded.toString();
  final StringBuffer buf = StringBuffer();
  int count = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    if (count > 0) {
      if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) buf.write(',');
    }
    buf.write(s[i]);
    count++;
  }
  return 'Rs ${buf.toString().split('').reversed.join()}';
}

// ── Total Banner ──────────────────────────────────────────────────────────
class PtaTotalBanner extends StatelessWidget {
  final PtaTaxModel result;
  const PtaTotalBanner({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: AppColors.ptaGrad,
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(
            color: AppColors.ptaPurple.withOpacity(0.38),
            blurRadius: 22, offset: const Offset(0, 8))],
      ),
      child: Stack(children: [
        Positioned(right: -20, top: -20, child: Container(
            width: 110, height: 110,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
        Positioned(left: -10, bottom: -20, child: Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))),
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(13)),
            child: Icon(
                result.deviceCategory == 'Laptop' ? Icons.laptop_rounded
                    : result.deviceCategory == 'Tablet' ? Icons.tablet_rounded
                    : Icons.phone_android_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(result.model, style: GoogleFonts.sora(
                fontSize: 11, color: Colors.white.withOpacity(0.75))),
            Text('Total PTA Tax', style: GoogleFonts.sora(
                fontSize: 10, color: Colors.white.withOpacity(0.60))),
            Text(ptaFmtFull(result.totalTax), style: GoogleFonts.sora(
                fontSize: 24, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: -0.8)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(result.registrationType, style: GoogleFonts.sora(
                  fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(height: 6),
            Text('Eff. ${result.effectiveRate.toStringAsFixed(1)}%',
                style: GoogleFonts.sora(fontSize: 11, color: Colors.white.withOpacity(0.75))),
            Text(result.slabLabel, style: GoogleFonts.sora(
                fontSize: 9, color: Colors.white.withOpacity(0.60))),
          ]),
        ]),
      ]),
    );
  }
}

// ── 4 Tax Stat Cards in 2×2 Grid ─────────────────────────────────────────
class PtaTaxStatGrid extends StatelessWidget {
  final PtaTaxModel result;
  final bool isDark;
  const PtaTaxStatGrid({super.key, required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatData('Customs Duty', result.customsDuty, AppColors.ptaPurple, Icons.gavel_rounded),
      _StatData('Regulatory Duty', result.regulatoryDuty, AppColors.salaryBlue, Icons.account_balance_rounded),
      _StatData('Sales Tax 17%', result.salesTax, AppColors.remitTeal, Icons.receipt_rounded),
      _StatData('WHT 1%', result.withholdingTax, AppColors.whtOrange, Icons.percent_rounded),
    ];

    return Row(children: [
      Expanded(child: Column(children: [
        _StatCard(data: cards[0], isDark: isDark),
        const SizedBox(height: 10),
        _StatCard(data: cards[2], isDark: isDark),
      ])),
      const SizedBox(width: 10),
      Expanded(child: Column(children: [
        _StatCard(data: cards[1], isDark: isDark),
        const SizedBox(height: 10),
        _StatCard(data: cards[3], isDark: isDark),
      ])),
    ]);
  }
}

class _StatData {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  const _StatData(this.label, this.amount, this.color, this.icon);
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  final bool isDark;
  const _StatCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.18) : Colors.black.withOpacity(0.05),
            blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9)),
          child: Icon(data.icon, color: data.color, size: 15),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data.label, style: GoogleFonts.sora(
              fontSize: 10,
              color: isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
          Text(ptaFmt(data.amount), style: GoogleFonts.sora(
              fontSize: 14, fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
              letterSpacing: -0.4)),
          Text(ptaFmtFull(data.amount), style: GoogleFonts.sora(
              fontSize: 9,
              color: isDark ? AppColors.textGrey2 : AppColors.textGrey1)),
        ])),
      ]),
    );
  }
}

// ── Breakdown Bar Chart ───────────────────────────────────────────────────
class PtaBreakdownChart extends StatelessWidget {
  final PtaTaxModel result;
  final bool isDark;
  const PtaBreakdownChart({super.key, required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final total = result.totalTax;
    final components = <_TaxComp>[
      _TaxComp('Customs', result.customsDuty, AppColors.ptaPurple),
      _TaxComp('Regulatory', result.regulatoryDuty, AppColors.salaryBlue),
      _TaxComp('Sales Tax', result.salesTax, AppColors.remitTeal),
      _TaxComp('WHT', result.withholdingTax, AppColors.whtOrange),
    ].where((c) => c.amount > 0).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Tax Breakdown', style: GoogleFonts.sora(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.textDark))),
          Text(ptaFmtFull(total), style: GoogleFonts.sora(
              fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.ptaPurple)),
        ]),
        const SizedBox(height: 12),
        // Horizontal stacked bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(children: components.map((c) {
            final pct = total > 0 ? (c.amount / total) : 0.0;
            return Expanded(
              flex: (pct * 100).round().clamp(1, 100),
              child: Container(height: 10, color: c.color),
            );
          }).toList()),
        ),
        const SizedBox(height: 12),
        // Legend rows
        ...components.map((c) {
          final pct = total > 0 ? (c.amount / total * 100) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(children: [
              Container(width: 9, height: 9,
                  decoration: BoxDecoration(color: c.color, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 8),
              Expanded(child: Text(c.name, style: GoogleFonts.sora(fontSize: 11,
                  color: isDark ? AppColors.textGrey1 : AppColors.textGrey2))),
              Text('${pct.toStringAsFixed(1)}%', style: GoogleFonts.sora(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textWhite : AppColors.textDark)),
              const SizedBox(width: 10),
              SizedBox(width: 76, child: Text(ptaFmtFull(c.amount),
                  textAlign: TextAlign.right, style: GoogleFonts.sora(
                      fontSize: 10, fontWeight: FontWeight.w700, color: c.color))),
            ]),
          );
        }),
      ]),
    );
  }
}

class _TaxComp {
  final String name;
  final double amount;
  final Color color;
  const _TaxComp(this.name, this.amount, this.color);
}

// ── Device Info + Tip Compact Row ─────────────────────────────────────────
class PtaDeviceInfoCard extends StatelessWidget {
  final PtaTaxModel result;
  final bool isDark;
  const PtaDeviceInfoCard({super.key, required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pkrVal = result.deviceValueUsd * result.usdTopkr;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.ptaPurple.withOpacity(0.08) : AppColors.ptaPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.ptaPurple.withOpacity(0.18)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.info_outline_rounded, size: 14, color: AppColors.ptaPurple),
          const SizedBox(width: 6),
          Text('Device Details', style: GoogleFonts.sora(
              fontSize: 12, fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.textDark)),
          const Spacer(),
          // Tip bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.accentGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accentGreen.withOpacity(0.25))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.lightbulb_outline_rounded, size: 11, color: AppColors.accentGreen),
              const SizedBox(width: 4),
              Text(result.registrationType == 'Passport' ? '60-day window' : 'Max 5/year',
                  style: GoogleFonts.sora(fontSize: 9, fontWeight: FontWeight.w600,
                      color: AppColors.accentGreen)),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        // 2-column compact info grid
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _InfoPair('Brand', result.brand, isDark),
            _InfoPair('Category', result.deviceCategory, isDark),
            _InfoPair('FBR USD', '\$${result.deviceValueUsd.toInt()}', isDark),
          ])),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _InfoPair('Type', result.registrationType, isDark),
            _InfoPair('PKR Equiv.', ptaFmt(pkrVal), isDark),
            _InfoPair('Rate', '1 USD = Rs ${result.usdTopkr.toStringAsFixed(0)}', isDark),
          ])),
        ]),
      ]),
    );
  }
}

class _InfoPair extends StatelessWidget {
  final String label, value;
  final bool isDark;
  const _InfoPair(this.label, this.value, this.isDark);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.sora(fontSize: 9,
            color: isDark ? AppColors.textGrey2 : AppColors.textGrey1)),
        Text(value, style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textWhite : AppColors.textDark)),
      ]),
    );
  }
}

// ── Slab Table (collapsible) ──────────────────────────────────────────────
class PtaSlabTable extends StatefulWidget {
  final bool isDark, isPassport;
  const PtaSlabTable({super.key, required this.isDark, required this.isPassport});
  @override
  State<PtaSlabTable> createState() => _PtaSlabTableState();
}

class _PtaSlabTableState extends State<PtaSlabTable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final slabs = [
      ['Below \$30', 'Rs 430', 'Rs 430'],
      ['\$30 – \$100', 'Rs 2,500', 'Rs 3,000'],
      ['\$100 – \$200', 'Rs 8,000', 'Rs 11,561'],
      ['\$200 – \$350', 'Rs 12,000', 'Rs 14,661'],
      ['\$350 – \$500', 'Rs 17,800', 'Rs 23,420'],
      ['Above \$500', 'Rs 27,600', 'Rs 37,007'],
    ];

    return Container(
      decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Column(children: [
        // Header tap to expand
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: _expanded ? const BorderRadius.vertical(top: Radius.circular(18))
                  : BorderRadius.circular(18),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: AppColors.ptaPurple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.table_chart_rounded, size: 14, color: AppColors.ptaPurple),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('FBR Tax Slabs 2025-26', style: GoogleFonts.sora(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: widget.isDark ? AppColors.textWhite : AppColors.textDark)),
                Text('Customs duty base — tap to expand',
                    style: GoogleFonts.sora(fontSize: 10,
                        color: widget.isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
              ])),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 20,
                    color: widget.isDark ? AppColors.textGrey1 : AppColors.textGrey2),
              ),
            ]),
          ),
        ),

        if (_expanded) ...[
          Divider(height: 1, color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
          // Column headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.ptaPurple.withOpacity(0.07),
            child: Row(children: [
              Expanded(flex: 3, child: Text('Device Value', style: GoogleFonts.sora(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: widget.isDark ? AppColors.textGrey1 : AppColors.textGrey2))),
              Expanded(flex: 2, child: Text('Passport', textAlign: TextAlign.center,
                  style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700,
                      color: AppColors.salaryBlue))),
              Expanded(flex: 2, child: Text('CNIC', textAlign: TextAlign.right,
                  style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700,
                      color: AppColors.ptaPurple))),
            ]),
          ),
          ...slabs.map((slab) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(border: Border(top: BorderSide(
                color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.6))),
            child: Row(children: [
              Expanded(flex: 3, child: Text(slab[0], style: GoogleFonts.sora(
                  fontSize: 11,
                  color: widget.isDark ? AppColors.textGrey1 : AppColors.textGrey2))),
              Expanded(flex: 2, child: Text(slab[1], textAlign: TextAlign.center,
                  style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.salaryBlue))),
              Expanded(flex: 2, child: Text(slab[2], textAlign: TextAlign.right,
                  style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.ptaPurple))),
            ]),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text('+ 17% Sales Tax on PKR customs value.',
                style: GoogleFonts.sora(fontSize: 9, height: 1.4,
                    color: widget.isDark ? AppColors.textGrey2 : AppColors.textGrey1)),
          ),
        ],
      ]),
    );
  }
}

// ── How To Register Card (collapsible) ────────────────────────────────────
class PtaHowToRegisterCard extends StatefulWidget {
  final bool isDark;
  const PtaHowToRegisterCard({super.key, required this.isDark});
  @override
  State<PtaHowToRegisterCard> createState() => _PtaHowToRegisterCardState();
}

class _PtaHowToRegisterCardState extends State<PtaHowToRegisterCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Visit DIRBS Portal', 'Go to dirbs.pta.gov.pk and create an account.', Icons.language_rounded),
      ('Apply for COC', 'Submit a Certificate of Compliance application online.', Icons.assignment_rounded),
      ('Enter IMEI', 'Dial *#06#. Enter both IMEIs for dual-SIM phones.', Icons.pin_rounded),
      ('Generate PSID', 'System calculates tax and issues a Payment Slip ID.', Icons.receipt_long_rounded),
      ('Pay Online', 'Pay via JazzCash, EasyPaisa, HBL, UBL or ATM.', Icons.payment_rounded),
      ('Done!', 'Confirmed within 24–72 hours via SMS/email.', Icons.check_circle_rounded),
    ];

    return Container(
      decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: AppColors.ptaPurple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.how_to_reg_rounded, size: 14, color: AppColors.ptaPurple),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('How to Register on DIRBS', style: GoogleFonts.sora(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: widget.isDark ? AppColors.textWhite : AppColors.textDark)),
                Text('Step-by-step guide — tap to expand', style: GoogleFonts.sora(
                    fontSize: 10,
                    color: widget.isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
              ])),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 20,
                    color: widget.isDark ? AppColors.textGrey1 : AppColors.textGrey2),
              ),
            ]),
          ),
        ),
        if (_expanded) ...[
          Divider(height: 1, color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ...steps.indexed.map((e) {
            final (i, step) = e;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.ptaGrad),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text('${i + 1}', style: GoogleFonts.sora(
                      fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(step.$1, style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w700,
                      color: widget.isDark ? AppColors.textWhite : AppColors.textDark)),
                  Text(step.$2, style: GoogleFonts.sora(fontSize: 10, height: 1.4,
                      color: widget.isDark ? AppColors.textGrey1 : AppColors.textGrey2)),
                ])),
                Icon(step.$3, size: 14,
                    color: widget.isDark ? AppColors.textGrey2 : AppColors.textGrey1),
              ]),
            );
          }),
          const SizedBox(height: 6),
        ],
      ]),
    );
  }
}

// ── Slab Pill ─────────────────────────────────────────────────────────────
class PtaSlabPill extends StatelessWidget {
  final String label;
  const PtaSlabPill({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.ptaPurple.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.ptaPurple.withOpacity(0.35))),
      child: Text(label, style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700,
          color: AppColors.ptaPurple)),
    );
  }
}