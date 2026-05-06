import '../models/withholding_tax_model.dart';

/// FBR Withholding Tax — Tax Year 2025-26 (1 July 2025 – 30 June 2026)
/// Section 153: Payments for goods (Suppliers), services, and execution of contracts
/// Section 155: Payments on account of rent
///
/// Rates per Finance Act 2025 / FBR Circular
class WithholdingTaxService {
  // ── Payment Type Keys ────────────────────────────────────────────────────
  static const String contractorFiler    = 'Contractor (Filer)';
  static const String contractorNonFiler = 'Contractor (Non-Filer)';
  static const String supplierFiler      = 'Supplier (Filer)';
  static const String supplierNonFiler   = 'Supplier (Non-Filer)';
  static const String servicesFiler      = 'Services (Filer)';
  static const String servicesNonFiler   = 'Services (Non-Filer)';
  static const String rentFiler          = 'Rent (Filer)';
  static const String rentNonFiler       = 'Rent (Non-Filer)';

  // ── All available payment types ───────────────────────────────────────────
  static const List<String> allTypes = [
    contractorFiler,
    contractorNonFiler,
    supplierFiler,
    supplierNonFiler,
    servicesFiler,
    servicesNonFiler,
    rentFiler,
    rentNonFiler,
  ];

  // ── Rate table (Section 153 / 155) ───────────────────────────────────────
  static const Map<String, _RateEntry> _rateTable = {
    contractorFiler:    _RateEntry(rate: 0.075, section: 'Sec 153(1)(c)', category: 'Contractor'),
    contractorNonFiler: _RateEntry(rate: 0.150, section: 'Sec 153(1)(c)', category: 'Contractor'),
    supplierFiler:      _RateEntry(rate: 0.040, section: 'Sec 153(1)(a)', category: 'Supplier'),
    supplierNonFiler:   _RateEntry(rate: 0.080, section: 'Sec 153(1)(a)', category: 'Supplier'),
    servicesFiler:      _RateEntry(rate: 0.080, section: 'Sec 153(1)(b)', category: 'Services'),
    servicesNonFiler:   _RateEntry(rate: 0.160, section: 'Sec 153(1)(b)', category: 'Services'),
    rentFiler:          _RateEntry(rate: 0.150, section: 'Sec 155',       category: 'Rent'),
    rentNonFiler:       _RateEntry(rate: 0.300, section: 'Sec 155',       category: 'Rent'),
  };

  // ── All rate entries for reference table display ──────────────────────────
  static List<WhtRateRow> get referenceRates => _rateTable.entries
      .map((e) => WhtRateRow(
    label: e.key,
    rate: e.value.rate,
    section: e.value.section,
    category: e.value.category,
  ))
      .toList();

  // ── Main calculation ─────────────────────────────────────────────────────
  static WithholdingTaxModel calculate({
    required double grossAmount,
    required String paymentType,
  }) {
    final entry = _rateTable[paymentType];

    if (entry == null || grossAmount <= 0) {
      return WithholdingTaxModel(
        grossAmount:   grossAmount,
        paymentType:   paymentType,
        section:       '—',
        isFiler:       true,
        rate:          0,
        taxDeducted:   0,
        netPayment:    grossAmount,
        categoryLabel: '',
        isExempt:      true,
      );
    }

    final double tax = grossAmount * entry.rate;
    final double net = grossAmount - tax;
    final bool filer = !paymentType.contains('Non-Filer');

    return WithholdingTaxModel(
      grossAmount:   grossAmount,
      paymentType:   paymentType,
      section:       entry.section,
      isFiler:       filer,
      rate:          entry.rate,
      taxDeducted:   tax,
      netPayment:    net,
      categoryLabel: entry.category,
      isExempt:      false,
    );
  }

  /// Returns corresponding non-filer type key for a filer type, and vice versa
  static String toggleFilerStatus(String currentType) {
    if (currentType.contains('Non-Filer')) {
      return currentType.replaceAll(' (Non-Filer)', ' (Filer)');
    } else {
      return currentType.replaceAll(' (Filer)', ' (Non-Filer)');
    }
  }

  /// Returns rate for a given type
  static double rateFor(String type) => (_rateTable[type]?.rate ?? 0);
}

// ── Internal rate entry ───────────────────────────────────────────────────
class _RateEntry {
  final double rate;
  final String section;
  final String category;
  const _RateEntry({required this.rate, required this.section, required this.category});
}

// ── Public data class for reference rate table rows ───────────────────────
class WhtRateRow {
  final String label;
  final double rate;
  final String section;
  final String category;

  const WhtRateRow({
    required this.label,
    required this.rate,
    required this.section,
    required this.category,
  });

  double get ratePercent => rate * 100;
}
