/// Remittance Tax Model — FBR Tax Year 2025-26
/// Covers Section 236AA (inward remittances via banking channels / exchange cos)
/// and Section 236Y (outward remittances via debit/credit/prepaid cards)
class RemittanceTaxModel {
  final double amount;          // amount entered by user (PKR)
  final String channelKey;      // key from service
  final String channelLabel;    // display label
  final String section;         // e.g. "Sec 236AA", "Sec 236Y"
  final bool isFiler;
  final double rate;            // decimal e.g. 0.01
  final double taxWithheld;
  final double netAmount;       // amount - tax
  final String directionLabel;  // "Net Received" | "Net Remitted"
  final RemittanceDirection direction;
  final String categoryLabel;   // "Inward" | "Outward"
  final String note;            // contextual FBR note for this rate
  final bool isExempt;

  const RemittanceTaxModel({
    required this.amount,
    required this.channelKey,
    required this.channelLabel,
    required this.section,
    required this.isFiler,
    required this.rate,
    required this.taxWithheld,
    required this.netAmount,
    required this.directionLabel,
    required this.direction,
    required this.categoryLabel,
    this.note = '',
    this.isExempt = false,
  });

  double get ratePercent => rate * 100;
  bool get isNonFiler => !isFiler;
  bool get hasData => amount > 0;
}

enum RemittanceDirection { inward, outward }

// ── Public data class for reference rate table ────────────────────────────
class RemittanceRateRow {
  final String label;
  final double rate;
  final String section;
  final String category;
  final RemittanceDirection direction;
  final String note;

  const RemittanceRateRow({
    required this.label,
    required this.rate,
    required this.section,
    required this.category,
    required this.direction,
    this.note = '',
  });

  double get ratePercent => rate * 100;
}