import '../models/remittance_tax_model.dart';

/// ─────────────────────────────────────────────────────────────────────────────
class RemittanceTaxService {
  // ── Channel Keys ──────────────────────────────────────────────────────────
  // Inward — Section 236AA
  static const String inwardBankFiler        = 'inward_bank_filer';
  static const String inwardBankNonFiler     = 'inward_bank_non_filer';
  static const String inwardExchangeFiler    = 'inward_exchange_filer';
  static const String inwardExchangeNonFiler = 'inward_exchange_non_filer';

  // Outward — Section 236Y (card-based)
  static const String outwardCardFiler    = 'outward_card_filer';
  static const String outwardCardNonFiler = 'outward_card_non_filer';

  // ── Inward channels list ───────────────────────────────────────────────────
  static const List<String> inwardChannels = [
    inwardBankFiler,
    inwardBankNonFiler,
    inwardExchangeFiler,
    inwardExchangeNonFiler,
  ];

  // ── Outward channels list ──────────────────────────────────────────────────
  static const List<String> outwardChannels = [
    outwardCardFiler,
    outwardCardNonFiler,
  ];

  static List<String> get allChannels => [...inwardChannels, ...outwardChannels];

  // ── Rate table ─────────────────────────────────────────────────────────────
  //
  // 236AA Inward:  Filer 1%  |  Non-Filer 2%   (confirmed FBR 2025-26)
  // 236Y  Outward: Filer 1%  |  Non-Filer 2%
  //   ↳ Finance Act 2023 had raised non-filer 236Y to 10%;
  //     Finance Act 2025 reduced it back to 2% effective 1 July 2025.
  //
  static const Map<String, _RateEntry> _rateTable = {
    // ── Section 236AA — Inward remittances ──────────────────────────────────
    inwardBankFiler: _RateEntry(
      rate: 0.01,                           // 1% — ATL / Filer
      section: 'Sec 236AA',
      category: 'Inward',
      label: 'Bank Transfer (Filer)',
      direction: RemittanceDirection.inward,
      isFiler: true,
      note: 'Adjustable against annual tax liability.',
    ),
    inwardBankNonFiler: _RateEntry(
      rate: 0.02,                           // 2% — Non-ATL / Non-Filer
      section: 'Sec 236AA',
      category: 'Inward',
      label: 'Bank Transfer (Non-Filer)',
      direction: RemittanceDirection.inward,
      isFiler: false,
      note: 'Bank deducts 2% upfront. Personal/family remittances are exempt under Sec 111(4) — reclaim via annual return.',
    ),
    inwardExchangeFiler: _RateEntry(
      rate: 0.01,                           // 1% — ATL / Filer
      section: 'Sec 236AA',
      category: 'Inward',
      label: 'Exchange Company (Filer)',
      direction: RemittanceDirection.inward,
      isFiler: true,
      note: 'Adjustable against annual tax liability.',
    ),
    inwardExchangeNonFiler: _RateEntry(
      rate: 0.02,                           // 2% — Non-ATL / Non-Filer
      section: 'Sec 236AA',
      category: 'Inward',
      label: 'Exchange Company (Non-Filer)',
      direction: RemittanceDirection.inward,
      isFiler: false,
      note: 'Exchange co. deducts 2% upfront. Personal/family remittances are exempt under Sec 111(4) — reclaim via annual return.',
    ),

    // ── Section 236Y — Outward (card) remittances ────────────────────────────
    outwardCardFiler: _RateEntry(
      rate: 0.01,                           // 1% — ATL / Filer
      section: 'Sec 236Y',
      category: 'Outward',
      label: 'Debit / Credit Card (Filer)',
      direction: RemittanceDirection.outward,
      isFiler: true,
      note: 'Adjustable. Applies to all international card transactions.',
    ),
    outwardCardNonFiler: _RateEntry(
      rate: 0.02,                           // 2% — Non-ATL (FA 2025 reduced from 10%)
      section: 'Sec 236Y',
      category: 'Outward',
      label: 'Debit / Credit Card (Non-Filer)',
      direction: RemittanceDirection.outward,
      isFiler: false,
      note: 'FA 2025 reduced rate from 10% → 2%. Become a Filer to pay the same 1%.',
    ),
  };

  // ── Reference rates for display ────────────────────────────────────────────
  static List<RemittanceRateRow> get referenceRates => _rateTable.entries
      .map((e) => RemittanceRateRow(
    label: e.value.label,
    rate: e.value.rate,
    section: e.value.section,
    category: e.value.category,
    direction: e.value.direction,
    note: e.value.note,
  ))
      .toList();

  static List<RemittanceRateRow> get inwardReferenceRates =>
      referenceRates
          .where((r) => r.direction == RemittanceDirection.inward)
          .toList();

  static List<RemittanceRateRow> get outwardReferenceRates =>
      referenceRates
          .where((r) => r.direction == RemittanceDirection.outward)
          .toList();

  // ── Label / rate lookup ────────────────────────────────────────────────────
  static String labelFor(String key) => _rateTable[key]?.label ?? key;
  static double rateFor(String key)  => _rateTable[key]?.rate ?? 0;
  static String noteFor(String key)  => _rateTable[key]?.note ?? '';

  // ── Toggle filer status ────────────────────────────────────────────────────
  static String toggleFilerStatus(String key) {
    switch (key) {
      case inwardBankFiler:        return inwardBankNonFiler;
      case inwardBankNonFiler:     return inwardBankFiler;
      case inwardExchangeFiler:    return inwardExchangeNonFiler;
      case inwardExchangeNonFiler: return inwardExchangeFiler;
      case outwardCardFiler:       return outwardCardNonFiler;
      case outwardCardNonFiler:    return outwardCardFiler;
      default:                     return key;
    }
  }

  // ── Main calculation ───────────────────────────────────────────────────────
  static RemittanceTaxModel calculate({
    required double amount,
    required String channelKey,
  }) {
    final entry = _rateTable[channelKey];

    if (entry == null || amount <= 0) {
      return RemittanceTaxModel(
        amount: amount,
        channelKey: channelKey,
        channelLabel: entry?.label ?? '',
        section: '—',
        isFiler: true,
        rate: 0,
        taxWithheld: 0,
        netAmount: amount,
        directionLabel: 'Net Amount',
        direction: RemittanceDirection.inward,
        categoryLabel: '',
        note: '',
        isExempt: true,
      );
    }

    final double tax = amount * entry.rate;
    final double net = amount - tax;

    return RemittanceTaxModel(
      amount: amount,
      channelKey: channelKey,
      channelLabel: entry.label,
      section: entry.section,
      isFiler: entry.isFiler,
      rate: entry.rate,
      taxWithheld: tax,
      netAmount: net,
      directionLabel: entry.direction == RemittanceDirection.inward
          ? 'Net Received'
          : 'Net Remitted',
      direction: entry.direction,
      categoryLabel: entry.category,
      note: entry.note,
      isExempt: false,
    );
  }
}

// ── Internal rate entry ────────────────────────────────────────────────────
class _RateEntry {
  final double rate;
  final String section;
  final String category;
  final String label;
  final RemittanceDirection direction;
  final bool isFiler;
  final String note;

  const _RateEntry({
    required this.rate,
    required this.section,
    required this.category,
    required this.label,
    required this.direction,
    required this.isFiler,
    this.note = '',
  });
}