/// Withholding Tax Model — FBR Tax Year 2025-26
/// Covers Section 153 (Contractors / Suppliers / Services) and Section 155 (Rent)
class WithholdingTaxModel {
  final double grossAmount;
  final String paymentType;
  final String section;
  final bool isFiler;
  final double rate;           // as a decimal e.g. 0.075
  final double taxDeducted;
  final double netPayment;
  final String categoryLabel;  // e.g. "Contractor", "Supplier"
  final bool isExempt;

  WithholdingTaxModel({
    required this.grossAmount,
    required this.paymentType,
    required this.section,
    required this.isFiler,
    required this.rate,
    required this.taxDeducted,
    required this.netPayment,
    required this.categoryLabel,
    this.isExempt = false,
  });

  double get ratePercent => rate * 100;

  /// Convenience: whether the payer is a non-filer (higher rate bracket)
  bool get isNonFiler => !isFiler;
}
