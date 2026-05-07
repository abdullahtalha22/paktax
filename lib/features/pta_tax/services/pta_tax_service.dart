import '../models/pta_tax_model.dart';

/// PTA Device Tax Service
/// Sources:
///   • FBR Finance Act 2025
///   • Valuation Ruling 1999/2025
///   • Valuation Ruling 2035/2026 (Jan 16, 2026 — used/refurb phones)
///   • Valuation Ruling 2070/2026 (Apr 2026 — revised upward)
///   • Valuation Ruling 2076/2026
///
/// TAX FORMULA:
///   Total = Customs Duty (base slab) + Regulatory Duty + Sales Tax (17%) + WHT (1%)
///
/// FBR BASE SLABS — fixed PKR by phone USD customs value:
///   < $30          → Rs 430
///   $30–$100       → Rs 2,500 (Passport) / Rs 3,000 (CNIC)
///   $100–$200      → Rs 8,000 (Passport) / Rs 11,561 (CNIC)
///   $200–$350      → Rs 12,000 (Passport) / Rs 14,661 (CNIC)
///   $350–$500      → Rs 17,800 (Passport) / Rs 23,420 (CNIC)
///   > $500         → Rs 27,600 (Passport) / Rs 37,007 (CNIC)
///   + 17% Sales Tax ad valorem on PKR customs value
///   + 1%  WHT (filer rate)
///   Laptops        → 0% customs duty (only 17% ST + 1% WHT)
///
/// KEY INSIGHT: FBR valuations update frequently.
/// For unlisted devices, use [calculateByUsdValue] with the
/// device's current FBR customs value from dirbs.pta.gov.pk

class PtaTaxService {
  static const double usdToPkr = 280.0;

  // ── Search Normalization ────────────────────────────────────────────────
  /// Strips spaces/symbols for fuzzy search: "iphone15promax" matches
  static String _normalize(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  static List<PtaDeviceEntry> searchDevices(String query) {
    if (query.trim().isEmpty) return _devices;
    final q = _normalize(query);
    return _devices.where((d) {
      return _normalize(d.brand).contains(q) ||
          _normalize(d.model).contains(q) ||
          (_normalize(d.brand) + _normalize(d.model)).contains(q);
    }).toList();
  }

  // ── Custom USD Value Calculator ─────────────────────────────────────────
  /// Use this for ANY device not in the database.
  /// Pass the FBR customs value in USD (check dirbs.pta.gov.pk).
  static PtaTaxModel calculateByUsdValue({
    required String brand,
    required String model,
    required double usdValue,
    String category = 'Smartphone',
    required String registrationType,
  }) {
    final entry = PtaDeviceEntry(
      brand: brand,
      model: model,
      category: category,
      customsValueUsd: usdValue,
    );
    return calculate(device: entry, registrationType: registrationType);
  }

  static const List<PtaDeviceEntry> _devices = [

    // ══════════════════════════════════════════════════════════════════════
    // APPLE  (Valuation Ruling 2035/2026 & 2070/2026)
    // ══════════════════════════════════════════════════════════════════════

    // ── iPhone (legacy) ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 4',                        category: 'Smartphone', customsValueUsd: 10),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 4S',                       category: 'Smartphone', customsValueUsd: 12),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 5',                        category: 'Smartphone', customsValueUsd: 15),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 5C',                       category: 'Smartphone', customsValueUsd: 14),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 5S',                       category: 'Smartphone', customsValueUsd: 18),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone SE (2016)',                 category: 'Smartphone', customsValueUsd: 25),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 6',                        category: 'Smartphone', customsValueUsd: 35),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 6 Plus',                   category: 'Smartphone', customsValueUsd: 42),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 6S',                       category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 6S Plus',                  category: 'Smartphone', customsValueUsd: 55),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 7',                        category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 7 Plus',                   category: 'Smartphone', customsValueUsd: 80),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 8',                        category: 'Smartphone', customsValueUsd: 88),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 8 Plus',                   category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone X',                        category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone XR',                       category: 'Smartphone', customsValueUsd: 110),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone XS',                       category: 'Smartphone', customsValueUsd: 130),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone XS Max',                   category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone SE (2020)',                 category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone SE (2022)',                 category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone SE (2024)',                 category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 11',                       category: 'Smartphone', customsValueUsd: 112),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 11 Pro',                   category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 11 Pro Max',               category: 'Smartphone', customsValueUsd: 185),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 12',                       category: 'Smartphone', customsValueUsd: 120),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 12 Mini',                  category: 'Smartphone', customsValueUsd: 100),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 12 Pro',                   category: 'Smartphone', customsValueUsd: 155),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 12 Pro Max',               category: 'Smartphone', customsValueUsd: 180),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 13',                       category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 13 Mini',                  category: 'Smartphone', customsValueUsd: 135),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 13 Pro',                   category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 13 Pro Max',               category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 14',                       category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 14 Plus',                  category: 'Smartphone', customsValueUsd: 295),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 14 Pro',                   category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 14 Pro Max',               category: 'Smartphone', customsValueUsd: 398),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 15',                       category: 'Smartphone', customsValueUsd: 350),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 15 Plus',                  category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 15 Pro',                   category: 'Smartphone', customsValueUsd: 400),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 15 Pro Max',               category: 'Smartphone', customsValueUsd: 460),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 16',                       category: 'Smartphone', customsValueUsd: 560),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 16 Plus',                  category: 'Smartphone', customsValueUsd: 620),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 16 Pro',                   category: 'Smartphone', customsValueUsd: 700),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 16 Pro Max',               category: 'Smartphone', customsValueUsd: 800),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 16e',                      category: 'Smartphone', customsValueUsd: 420),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 17',                       category: 'Smartphone', customsValueUsd: 600),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 17 Plus',                  category: 'Smartphone', customsValueUsd: 660),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 17 Pro',                   category: 'Smartphone', customsValueUsd: 750),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 17 Pro Max',               category: 'Smartphone', customsValueUsd: 860),
    PtaDeviceEntry(brand: 'Apple', model: 'iPhone 17 Air',                   category: 'Smartphone', customsValueUsd: 640),

    // ── Apple iPad ────────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Apple', model: 'iPad (7th Gen)',                  category: 'Tablet', customsValueUsd: 170),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad (8th Gen)',                  category: 'Tablet', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad (9th Gen)',                  category: 'Tablet', customsValueUsd: 230),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad (10th Gen)',                 category: 'Tablet', customsValueUsd: 300),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Mini (5th Gen)',             category: 'Tablet', customsValueUsd: 240),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Mini (6th Gen)',             category: 'Tablet', customsValueUsd: 320),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Mini (7th Gen)',             category: 'Tablet', customsValueUsd: 360),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Air (M1)',                   category: 'Tablet', customsValueUsd: 440),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Air (M2)',                   category: 'Tablet', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Air 11" (M2)',               category: 'Tablet', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Air 13" (M2)',               category: 'Tablet', customsValueUsd: 660),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Air 11" (M3)',               category: 'Tablet', customsValueUsd: 540),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Air 13" (M3)',               category: 'Tablet', customsValueUsd: 700),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Pro 11" (M1)',               category: 'Tablet', customsValueUsd: 540),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Pro 12.9" (M1)',             category: 'Tablet', customsValueUsd: 700),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Pro 11" (M2)',               category: 'Tablet', customsValueUsd: 600),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Pro 12.9" (M2)',             category: 'Tablet', customsValueUsd: 780),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Pro 11" (M4)',               category: 'Tablet', customsValueUsd: 680),
    PtaDeviceEntry(brand: 'Apple', model: 'iPad Pro 13" (M4)',               category: 'Tablet', customsValueUsd: 880),

    // ── Apple MacBook ─────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Air (M1)',                category: 'Laptop', customsValueUsd: 800),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Air 13" (M2)',            category: 'Laptop', customsValueUsd: 950),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Air 15" (M2)',            category: 'Laptop', customsValueUsd: 1100),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Air 13" (M3)',            category: 'Laptop', customsValueUsd: 1000),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Air 15" (M3)',            category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Air 13" (M4)',            category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Air 15" (M4)',            category: 'Laptop', customsValueUsd: 1200),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 13" (M2)',            category: 'Laptop', customsValueUsd: 1100),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 14" (M3)',            category: 'Laptop', customsValueUsd: 1500),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 14" (M3 Pro)',        category: 'Laptop', customsValueUsd: 1800),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 14" (M3 Max)',        category: 'Laptop', customsValueUsd: 2200),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 16" (M3 Pro)',        category: 'Laptop', customsValueUsd: 2000),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 16" (M3 Max)',        category: 'Laptop', customsValueUsd: 2500),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 14" (M4)',            category: 'Laptop', customsValueUsd: 1600),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 14" (M4 Pro)',        category: 'Laptop', customsValueUsd: 1900),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 16" (M4)',            category: 'Laptop', customsValueUsd: 2100),
    PtaDeviceEntry(brand: 'Apple', model: 'MacBook Pro 16" (M4 Pro)',        category: 'Laptop', customsValueUsd: 2400),

    // ══════════════════════════════════════════════════════════════════════
    // SAMSUNG  (Ruling 2035/2026 updated values for S22/S23 series)
    // ══════════════════════════════════════════════════════════════════════

    // ── Galaxy S Series ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S10',                   category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S10+',                  category: 'Smartphone', customsValueUsd: 160),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S10e',                  category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S10 5G',                category: 'Smartphone', customsValueUsd: 175),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S20',                   category: 'Smartphone', customsValueUsd: 120),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S20+',                  category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S20 Ultra',             category: 'Smartphone', customsValueUsd: 165),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S20 FE',                category: 'Smartphone', customsValueUsd: 98),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S21',                   category: 'Smartphone', customsValueUsd: 138),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S21+',                  category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S21 Ultra',             category: 'Smartphone', customsValueUsd: 188),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S21 FE',                category: 'Smartphone', customsValueUsd: 110),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S22',                   category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S22+',                  category: 'Smartphone', customsValueUsd: 168),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S22 Ultra',             category: 'Smartphone', customsValueUsd: 160),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S22 FE',                category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S23',                   category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S23+',                  category: 'Smartphone', customsValueUsd: 160),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S23 Ultra',             category: 'Smartphone', customsValueUsd: 255),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S23 FE',                category: 'Smartphone', customsValueUsd: 130),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S24',                   category: 'Smartphone', customsValueUsd: 380),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S24+',                  category: 'Smartphone', customsValueUsd: 440),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S24 Ultra',             category: 'Smartphone', customsValueUsd: 560),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S24 FE',                category: 'Smartphone', customsValueUsd: 280),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S25',                   category: 'Smartphone', customsValueUsd: 440),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S25+',                  category: 'Smartphone', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S25 Ultra',             category: 'Smartphone', customsValueUsd: 620),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy S25 Edge',              category: 'Smartphone', customsValueUsd: 540),

    // ── Galaxy A Series ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A02',                   category: 'Smartphone', customsValueUsd: 42),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A02s',                  category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A03',                   category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A03s',                  category: 'Smartphone', customsValueUsd: 55),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A03 Core',              category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A04',                   category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A04e',                  category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A04s',                  category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A05',                   category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A05s',                  category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A06',                   category: 'Smartphone', customsValueUsd: 82),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A06s',                  category: 'Smartphone', customsValueUsd: 88),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A12',                   category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A12 Nacho',             category: 'Smartphone', customsValueUsd: 88),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A13',                   category: 'Smartphone', customsValueUsd: 92),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A13 5G',                category: 'Smartphone', customsValueUsd: 100),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A14',                   category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A14 5G',                category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A15',                   category: 'Smartphone', customsValueUsd: 112),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A15 5G',                category: 'Smartphone', customsValueUsd: 122),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A16',                   category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A16 5G',                category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A22',                   category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A22 5G',                category: 'Smartphone', customsValueUsd: 128),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A23',                   category: 'Smartphone', customsValueUsd: 130),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A23 5G',                category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A24',                   category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A24 4G',                category: 'Smartphone', customsValueUsd: 138),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A25',                   category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A25 5G',                category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A26 5G',                category: 'Smartphone', customsValueUsd: 168),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A32',                   category: 'Smartphone', customsValueUsd: 155),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A32 5G',                category: 'Smartphone', customsValueUsd: 165),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A33 5G',                category: 'Smartphone', customsValueUsd: 188),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A34',                   category: 'Smartphone', customsValueUsd: 198),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A34 5G',                category: 'Smartphone', customsValueUsd: 208),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A35',                   category: 'Smartphone', customsValueUsd: 205),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A35 5G',                category: 'Smartphone', customsValueUsd: 215),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A36 5G',                category: 'Smartphone', customsValueUsd: 222),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A52',                   category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A52s 5G',               category: 'Smartphone', customsValueUsd: 242),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A53 5G',                category: 'Smartphone', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A54',                   category: 'Smartphone', customsValueUsd: 255),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A54 5G',                category: 'Smartphone', customsValueUsd: 262),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A55',                   category: 'Smartphone', customsValueUsd: 275),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A55 5G',                category: 'Smartphone', customsValueUsd: 285),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A56 5G',                category: 'Smartphone', customsValueUsd: 298),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A71',                   category: 'Smartphone', customsValueUsd: 215),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A72',                   category: 'Smartphone', customsValueUsd: 255),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy A73 5G',                category: 'Smartphone', customsValueUsd: 265),

    // ── Galaxy M Series ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M02',                   category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M12',                   category: 'Smartphone', customsValueUsd: 88),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M13',                   category: 'Smartphone', customsValueUsd: 98),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M14 5G',                category: 'Smartphone', customsValueUsd: 108),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M15 5G',                category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M23',                   category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M33 5G',                category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M34 5G',                category: 'Smartphone', customsValueUsd: 188),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M35 5G',                category: 'Smartphone', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M52 5G',                category: 'Smartphone', customsValueUsd: 235),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M53 5G',                category: 'Smartphone', customsValueUsd: 248),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M54 5G',                category: 'Smartphone', customsValueUsd: 260),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy M55 5G',                category: 'Smartphone', customsValueUsd: 272),

    // ── Galaxy F Series ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy F14 5G',                category: 'Smartphone', customsValueUsd: 112),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy F15 5G',                category: 'Smartphone', customsValueUsd: 120),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy F34 5G',                category: 'Smartphone', customsValueUsd: 205),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy F54 5G',                category: 'Smartphone', customsValueUsd: 270),

    // ── Galaxy Z Series ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Flip 3',              category: 'Smartphone', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Flip 4',              category: 'Smartphone', customsValueUsd: 540),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Flip 5',              category: 'Smartphone', customsValueUsd: 580),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Flip 6',              category: 'Smartphone', customsValueUsd: 620),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Flip 7',              category: 'Smartphone', customsValueUsd: 660),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Fold 3',              category: 'Smartphone', customsValueUsd: 750),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Fold 4',              category: 'Smartphone', customsValueUsd: 820),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Fold 5',              category: 'Smartphone', customsValueUsd: 880),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Fold 6',              category: 'Smartphone', customsValueUsd: 940),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Z Fold 7',              category: 'Smartphone', customsValueUsd: 1000),

    // ── Galaxy Note Series ────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Note 8',                category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Note 9',                category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Note 10',               category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Note 10+',              category: 'Smartphone', customsValueUsd: 205),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Note 10 Lite',          category: 'Smartphone', customsValueUsd: 155),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Note 20',               category: 'Smartphone', customsValueUsd: 245),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Note 20 Ultra',         category: 'Smartphone', customsValueUsd: 295),

    // ── Samsung Tablets ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab A7',                category: 'Tablet', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab A7 Lite',           category: 'Tablet', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab A8',                category: 'Tablet', customsValueUsd: 168),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab A8 10.5"',          category: 'Tablet', customsValueUsd: 170),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab A9',                category: 'Tablet', customsValueUsd: 188),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab A9+',               category: 'Tablet', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab A9+ 5G',            category: 'Tablet', customsValueUsd: 252),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S6 Lite',           category: 'Tablet', customsValueUsd: 265),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S6 Lite (2022)',     category: 'Tablet', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S6 Lite (2024)',     category: 'Tablet', customsValueUsd: 278),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S7',                category: 'Tablet', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S7 FE',             category: 'Tablet', customsValueUsd: 308),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S7+',               category: 'Tablet', customsValueUsd: 462),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S8',                category: 'Tablet', customsValueUsd: 442),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S8+',               category: 'Tablet', customsValueUsd: 540),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S8 Ultra',          category: 'Tablet', customsValueUsd: 680),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S9',                category: 'Tablet', customsValueUsd: 520),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S9+',               category: 'Tablet', customsValueUsd: 610),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S9 Ultra',          category: 'Tablet', customsValueUsd: 740),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S9 FE',             category: 'Tablet', customsValueUsd: 305),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S9 FE+',            category: 'Tablet', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S10',               category: 'Tablet', customsValueUsd: 560),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S10+',              category: 'Tablet', customsValueUsd: 660),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S10 Ultra',         category: 'Tablet', customsValueUsd: 808),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Tab S10 FE',            category: 'Tablet', customsValueUsd: 342),

    // ── Samsung Laptops ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 2',                category: 'Laptop', customsValueUsd: 800),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 2 Pro',            category: 'Laptop', customsValueUsd: 1100),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 2 360',            category: 'Laptop', customsValueUsd: 950),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 3',                category: 'Laptop', customsValueUsd: 880),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 3 Pro',            category: 'Laptop', customsValueUsd: 1180),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 3 Ultra',          category: 'Laptop', customsValueUsd: 1500),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 4',                category: 'Laptop', customsValueUsd: 930),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 4 Pro',            category: 'Laptop', customsValueUsd: 1230),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 4 Ultra',          category: 'Laptop', customsValueUsd: 1550),
    PtaDeviceEntry(brand: 'Samsung', model: 'Galaxy Book 4 360',            category: 'Laptop', customsValueUsd: 1050),

    // ══════════════════════════════════════════════════════════════════════
    // XIAOMI / REDMI / POCO
    // ══════════════════════════════════════════════════════════════════════

    // ── Redmi Budget ──────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 9',                       category: 'Smartphone', customsValueUsd: 60),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 9A',                      category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 9C',                      category: 'Smartphone', customsValueUsd: 50),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 9T',                      category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 10',                      category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 10A',                     category: 'Smartphone', customsValueUsd: 55),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 10C',                     category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 11A',                     category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 12',                      category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 12C',                     category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 13',                      category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 13C',                     category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 13R',                     category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 14C',                     category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi 14R',                     category: 'Smartphone', customsValueUsd: 85),

    // ── Redmi Note ────────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 10',                 category: 'Smartphone', customsValueUsd: 100),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 10 Pro',             category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 10 Pro Max',         category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 10S',                category: 'Smartphone', customsValueUsd: 112),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 11',                 category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 11 Pro',             category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 11 Pro+',            category: 'Smartphone', customsValueUsd: 168),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 11S',                category: 'Smartphone', customsValueUsd: 128),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 12',                 category: 'Smartphone', customsValueUsd: 135),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 12 Pro',             category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 12 Pro+',            category: 'Smartphone', customsValueUsd: 208),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 12 Turbo',           category: 'Smartphone', customsValueUsd: 222),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 12S',                category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 13',                 category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 13 Pro',             category: 'Smartphone', customsValueUsd: 192),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 13 Pro+',            category: 'Smartphone', customsValueUsd: 230),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 13R Pro',            category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 14',                 category: 'Smartphone', customsValueUsd: 162),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 14 Pro',             category: 'Smartphone', customsValueUsd: 212),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 14 Pro+',            category: 'Smartphone', customsValueUsd: 250),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Note 14 Pro+ 5G',         category: 'Smartphone', customsValueUsd: 265),

    // ── Redmi K Series ────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K50',                     category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K50 Pro',                 category: 'Smartphone', customsValueUsd: 328),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K60',                     category: 'Smartphone', customsValueUsd: 318),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K60 Pro',                 category: 'Smartphone', customsValueUsd: 398),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K70',                     category: 'Smartphone', customsValueUsd: 358),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K70 Pro',                 category: 'Smartphone', customsValueUsd: 438),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K80',                     category: 'Smartphone', customsValueUsd: 398),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi K80 Pro',                 category: 'Smartphone', customsValueUsd: 488),

    // ── Xiaomi Flagship ───────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 11',                     category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 11T',                    category: 'Smartphone', customsValueUsd: 300),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 11T Pro',                category: 'Smartphone', customsValueUsd: 360),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 12',                     category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 12 Pro',                 category: 'Smartphone', customsValueUsd: 462),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 12T',                    category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 12T Pro',                category: 'Smartphone', customsValueUsd: 412),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 12X',                    category: 'Smartphone', customsValueUsd: 320),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 13',                     category: 'Smartphone', customsValueUsd: 425),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 13 Pro',                 category: 'Smartphone', customsValueUsd: 505),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 13 Ultra',               category: 'Smartphone', customsValueUsd: 605),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 13T',                    category: 'Smartphone', customsValueUsd: 368),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 13T Pro',                category: 'Smartphone', customsValueUsd: 435),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 14',                     category: 'Smartphone', customsValueUsd: 465),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 14 Pro',                 category: 'Smartphone', customsValueUsd: 565),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 14 Ultra',               category: 'Smartphone', customsValueUsd: 700),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 14T',                    category: 'Smartphone', customsValueUsd: 388),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 14T Pro',                category: 'Smartphone', customsValueUsd: 465),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 15',                     category: 'Smartphone', customsValueUsd: 515),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 15 Pro',                 category: 'Smartphone', customsValueUsd: 615),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi 15 Ultra',               category: 'Smartphone', customsValueUsd: 762),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Mix Fold 3',             category: 'Smartphone', customsValueUsd: 948),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Mix Fold 4',             category: 'Smartphone', customsValueUsd: 1050),

    // ── POCO ─────────────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO C55',                      category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO C65',                      category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO M4 Pro',                   category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO M5',                       category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO M5s',                      category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO M6',                       category: 'Smartphone', customsValueUsd: 92),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO M6 Pro',                   category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO M6 Pro 5G',                category: 'Smartphone', customsValueUsd: 165),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO X4 Pro 5G',                category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO X5',                       category: 'Smartphone', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO X5 Pro',                   category: 'Smartphone', customsValueUsd: 230),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO X6',                       category: 'Smartphone', customsValueUsd: 240),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO X6 Pro',                   category: 'Smartphone', customsValueUsd: 270),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO X7',                       category: 'Smartphone', customsValueUsd: 260),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO X7 Pro',                   category: 'Smartphone', customsValueUsd: 308),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO F4',                       category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO F4 GT',                    category: 'Smartphone', customsValueUsd: 338),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO F5',                       category: 'Smartphone', customsValueUsd: 308),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO F5 Pro',                   category: 'Smartphone', customsValueUsd: 368),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO F6',                       category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'POCO F6 Pro',                   category: 'Smartphone', customsValueUsd: 405),

    // ── Xiaomi Tablets ────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Pad 5',                  category: 'Tablet', customsValueUsd: 248),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Pad 5 Pro',              category: 'Tablet', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Pad 6',                  category: 'Tablet', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Pad 6 Pro',              category: 'Tablet', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Pad 6S Pro',             category: 'Tablet', customsValueUsd: 408),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Pad 7',                  category: 'Tablet', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Xiaomi Pad 7 Pro',              category: 'Tablet', customsValueUsd: 368),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Pad',                     category: 'Tablet', customsValueUsd: 188),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Pad Pro',                 category: 'Tablet', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Xiaomi', model: 'Redmi Pad SE',                  category: 'Tablet', customsValueUsd: 158),

    // ══════════════════════════════════════════════════════════════════════
    // OPPO
    // ══════════════════════════════════════════════════════════════════════

    // ── OPPO A Series ─────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A15',                        category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A16',                        category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A16e',                       category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A16s',                       category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A17',                        category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A17k',                       category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A18',                        category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A31',                        category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A36',                        category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A38',                        category: 'Smartphone', customsValueUsd: 95),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A52',                        category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A53',                        category: 'Smartphone', customsValueUsd: 95),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A53s',                       category: 'Smartphone', customsValueUsd: 100),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A54',                        category: 'Smartphone', customsValueUsd: 108),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A55',                        category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A57',                        category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A57e',                       category: 'Smartphone', customsValueUsd: 98),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A57s',                       category: 'Smartphone', customsValueUsd: 108),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A58',                        category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A58x',                       category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A59 5G',                     category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A60',                        category: 'Smartphone', customsValueUsd: 128),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A72',                        category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A74',                        category: 'Smartphone', customsValueUsd: 138),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A74 5G',                     category: 'Smartphone', customsValueUsd: 145),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A76',                        category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A77',                        category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A77s',                       category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A78',                        category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A78 5G',                     category: 'Smartphone', customsValueUsd: 160),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A79 5G',                     category: 'Smartphone', customsValueUsd: 162),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A94',                        category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A96',                        category: 'Smartphone', customsValueUsd: 165),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A97',                        category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO A98',                        category: 'Smartphone', customsValueUsd: 182),

    // ── OPPO Reno ─────────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 6',                     category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 6 Pro',                 category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 7',                     category: 'Smartphone', customsValueUsd: 220),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 7 Pro',                 category: 'Smartphone', customsValueUsd: 278),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 8',                     category: 'Smartphone', customsValueUsd: 230),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 8 Pro',                 category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 8T',                    category: 'Smartphone', customsValueUsd: 240),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 8T 5G',                 category: 'Smartphone', customsValueUsd: 255),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 10',                    category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 10 Pro',                category: 'Smartphone', customsValueUsd: 328),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 10 Pro+',               category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 11',                    category: 'Smartphone', customsValueUsd: 298),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 11 Pro',                category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 11 F',                  category: 'Smartphone', customsValueUsd: 248),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 12',                    category: 'Smartphone', customsValueUsd: 328),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 12 Pro',                category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 12 F',                  category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 13',                    category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 13 Pro',                category: 'Smartphone', customsValueUsd: 405),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Reno 13 F',                  category: 'Smartphone', customsValueUsd: 288),

    // ── OPPO Find Series ──────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X3',                    category: 'Smartphone', customsValueUsd: 542),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X3 Pro',                category: 'Smartphone', customsValueUsd: 600),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X5',                    category: 'Smartphone', customsValueUsd: 618),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X5 Pro',                category: 'Smartphone', customsValueUsd: 698),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X6 Pro',                category: 'Smartphone', customsValueUsd: 778),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X7',                    category: 'Smartphone', customsValueUsd: 738),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X7 Ultra',              category: 'Smartphone', customsValueUsd: 878),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X8',                    category: 'Smartphone', customsValueUsd: 778),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find X8 Pro',                category: 'Smartphone', customsValueUsd: 878),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find N2 Flip',               category: 'Smartphone', customsValueUsd: 678),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find N3',                    category: 'Smartphone', customsValueUsd: 828),
    PtaDeviceEntry(brand: 'OPPO', model: 'OPPO Find N3 Flip',               category: 'Smartphone', customsValueUsd: 728),

    // ══════════════════════════════════════════════════════════════════════
    // VIVO
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y01',                        category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y02',                        category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y02s',                       category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y03',                        category: 'Smartphone', customsValueUsd: 60),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y11s',                       category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y12s',                       category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y15s',                       category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y16',                        category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y17s',                       category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y18',                        category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y18e',                       category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y18s',                       category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y20',                        category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y20G',                       category: 'Smartphone', customsValueUsd: 88),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y21',                        category: 'Smartphone', customsValueUsd: 88),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y21s',                       category: 'Smartphone', customsValueUsd: 92),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y21T',                       category: 'Smartphone', customsValueUsd: 95),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y22',                        category: 'Smartphone', customsValueUsd: 98),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y22s',                       category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y27',                        category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y27s',                       category: 'Smartphone', customsValueUsd: 108),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y27 5G',                     category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y28',                        category: 'Smartphone', customsValueUsd: 112),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y28 5G',                     category: 'Smartphone', customsValueUsd: 122),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y35',                        category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y35+',                       category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y36',                        category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y36 5G',                     category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y38',                        category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y38 5G',                     category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo Y58 5G',                     category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo T1x',                        category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo T2x',                        category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo T3',                         category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo T3 Pro 5G',                  category: 'Smartphone', customsValueUsd: 188),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V23',                        category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V23 Pro',                    category: 'Smartphone', customsValueUsd: 278),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V25',                        category: 'Smartphone', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V25 Pro',                    category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V27',                        category: 'Smartphone', customsValueUsd: 248),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V27 Pro',                    category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V29',                        category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V29 Pro',                    category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V29e',                       category: 'Smartphone', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V30',                        category: 'Smartphone', customsValueUsd: 308),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V30 Pro',                    category: 'Smartphone', customsValueUsd: 378),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V30e',                       category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V40',                        category: 'Smartphone', customsValueUsd: 328),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V40 Pro',                    category: 'Smartphone', customsValueUsd: 405),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V40 Lite',                   category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V40 SE',                     category: 'Smartphone', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V50',                        category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo V50 Pro',                    category: 'Smartphone', customsValueUsd: 425),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X70 Pro+',                   category: 'Smartphone', customsValueUsd: 578),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X80',                        category: 'Smartphone', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X80 Pro',                    category: 'Smartphone', customsValueUsd: 598),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X90',                        category: 'Smartphone', customsValueUsd: 420),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X90 Pro',                    category: 'Smartphone', customsValueUsd: 520),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X90 Pro+',                   category: 'Smartphone', customsValueUsd: 618),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X100',                       category: 'Smartphone', customsValueUsd: 480),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X100 Pro',                   category: 'Smartphone', customsValueUsd: 578),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X100 Ultra',                 category: 'Smartphone', customsValueUsd: 678),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X200',                       category: 'Smartphone', customsValueUsd: 538),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X200 Pro',                   category: 'Smartphone', customsValueUsd: 658),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X200 Ultra',                 category: 'Smartphone', customsValueUsd: 758),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X Fold 3',                   category: 'Smartphone', customsValueUsd: 858),
    PtaDeviceEntry(brand: 'Vivo', model: 'Vivo X Fold 3 Pro',               category: 'Smartphone', customsValueUsd: 958),

    // ══════════════════════════════════════════════════════════════════════
    // iQOO
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Z7 Pro',                     category: 'Smartphone', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Z7s',                        category: 'Smartphone', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Z9',                         category: 'Smartphone', customsValueUsd: 220),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Z9 Pro',                     category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Z9 Turbo',                   category: 'Smartphone', customsValueUsd: 308),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Z9s Pro',                    category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Neo 9',                      category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Neo 9 Pro',                  category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Neo 10',                     category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO Neo 10 Pro',                 category: 'Smartphone', customsValueUsd: 425),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO 12',                         category: 'Smartphone', customsValueUsd: 480),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO 12 Pro',                     category: 'Smartphone', customsValueUsd: 558),
    PtaDeviceEntry(brand: 'iQOO', model: 'iQOO 13',                         category: 'Smartphone', customsValueUsd: 518),

    // ══════════════════════════════════════════════════════════════════════
    // GOOGLE PIXEL  (Ruling 2035/2026 updated values)
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 5',                        category: 'Smartphone', customsValueUsd: 180),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 5a',                       category: 'Smartphone', customsValueUsd: 165),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 6',                        category: 'Smartphone', customsValueUsd: 175),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 6 Pro',                    category: 'Smartphone', customsValueUsd: 218),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 6a',                       category: 'Smartphone', customsValueUsd: 155),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 7',                        category: 'Smartphone', customsValueUsd: 195),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 7 Pro',                    category: 'Smartphone', customsValueUsd: 245),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 7a',                       category: 'Smartphone', customsValueUsd: 175),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 8',                        category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 8 Pro',                    category: 'Smartphone', customsValueUsd: 295),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 8a',                       category: 'Smartphone', customsValueUsd: 205),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 9',                        category: 'Smartphone', customsValueUsd: 150),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 9 Pro',                    category: 'Smartphone', customsValueUsd: 195),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 9 Pro XL',                 category: 'Smartphone', customsValueUsd: 260),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 9 Pro Fold',               category: 'Smartphone', customsValueUsd: 780),
    PtaDeviceEntry(brand: 'Google', model: 'Pixel 9a',                       category: 'Smartphone', customsValueUsd: 168),

    // ══════════════════════════════════════════════════════════════════════
    // ONEPLUS  (Ruling 2035/2026: OnePlus 12 revised to $184)
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord CE 2 Lite',        category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord CE 3',             category: 'Smartphone', customsValueUsd: 208),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord CE 3 Lite',        category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord CE 4',             category: 'Smartphone', customsValueUsd: 208),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord CE 4 Lite',        category: 'Smartphone', customsValueUsd: 185),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord 3',                category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord 4',                category: 'Smartphone', customsValueUsd: 265),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Nord 5',                category: 'Smartphone', customsValueUsd: 295),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 9',                     category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 9 Pro',                 category: 'Smartphone', customsValueUsd: 325),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 9R',                    category: 'Smartphone', customsValueUsd: 215),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 10 Pro',                category: 'Smartphone', customsValueUsd: 325),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 10R',                   category: 'Smartphone', customsValueUsd: 245),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 10T',                   category: 'Smartphone', customsValueUsd: 298),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 11',                    category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 11R',                   category: 'Smartphone', customsValueUsd: 245),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 12',                    category: 'Smartphone', customsValueUsd: 184),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 12R',                   category: 'Smartphone', customsValueUsd: 260),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 13',                    category: 'Smartphone', customsValueUsd: 450),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 13R',                   category: 'Smartphone', customsValueUsd: 295),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus 13s',                   category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Open',                  category: 'Smartphone', customsValueUsd: 858),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Open 2',                category: 'Smartphone', customsValueUsd: 938),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Pad',                   category: 'Tablet',     customsValueUsd: 365),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Pad 2',                 category: 'Tablet',     customsValueUsd: 405),
    PtaDeviceEntry(brand: 'OnePlus', model: 'OnePlus Pad Pro',               category: 'Tablet',     customsValueUsd: 452),

    // ══════════════════════════════════════════════════════════════════════
    // HUAWEI
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Y7a',                    category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 8i',                category: 'Smartphone', customsValueUsd: 182),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 9',                 category: 'Smartphone', customsValueUsd: 220),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 9 Pro',             category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 10',                category: 'Smartphone', customsValueUsd: 230),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 10 Pro',            category: 'Smartphone', customsValueUsd: 278),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 11',                category: 'Smartphone', customsValueUsd: 240),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 11 Pro',            category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 11i',               category: 'Smartphone', customsValueUsd: 192),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 12',                category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 12 Pro',            category: 'Smartphone', customsValueUsd: 328),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 12 Ultra',          category: 'Smartphone', customsValueUsd: 405),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 12i',               category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Nova 12s',               category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P40',                    category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P40 Pro',                category: 'Smartphone', customsValueUsd: 405),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P40 Pro+',               category: 'Smartphone', customsValueUsd: 482),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P50',                    category: 'Smartphone', customsValueUsd: 425),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P50 Pro',                category: 'Smartphone', customsValueUsd: 482),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P60',                    category: 'Smartphone', customsValueUsd: 520),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P60 Pro',                category: 'Smartphone', customsValueUsd: 578),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei P60 Art',                category: 'Smartphone', customsValueUsd: 658),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate 40 Pro',            category: 'Smartphone', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate 50',                category: 'Smartphone', customsValueUsd: 540),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate 50 Pro',            category: 'Smartphone', customsValueUsd: 578),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate 60',                category: 'Smartphone', customsValueUsd: 618),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate 60 Pro',            category: 'Smartphone', customsValueUsd: 678),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate 60 Pro+',           category: 'Smartphone', customsValueUsd: 758),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate 60 RS',             category: 'Smartphone', customsValueUsd: 858),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Mate X5',                category: 'Smartphone', customsValueUsd: 958),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Pura 70',                category: 'Smartphone', customsValueUsd: 598),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Pura 70 Pro',            category: 'Smartphone', customsValueUsd: 725),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Pura 70 Pro+',           category: 'Smartphone', customsValueUsd: 825),
    PtaDeviceEntry(brand: 'Huawei', model: 'Huawei Pura 70 Ultra',          category: 'Smartphone', customsValueUsd: 925),
    PtaDeviceEntry(brand: 'Huawei', model: 'MatePad 11',                    category: 'Tablet',     customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Huawei', model: 'MatePad 11.5"',                 category: 'Tablet',     customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Huawei', model: 'MatePad 11.5" S',               category: 'Tablet',     customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Huawei', model: 'MatePad Pro 11"',               category: 'Tablet',     customsValueUsd: 405),
    PtaDeviceEntry(brand: 'Huawei', model: 'MatePad Pro 12.6"',             category: 'Tablet',     customsValueUsd: 462),
    PtaDeviceEntry(brand: 'Huawei', model: 'MatePad Pro 13.2"',             category: 'Tablet',     customsValueUsd: 540),

    // ══════════════════════════════════════════════════════════════════════
    // NOKIA / HMD
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia C21',                      category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia C21 Plus',                 category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia C22',                      category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia C31',                      category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia C32',                      category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia C33',                      category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia G11',                      category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia G11 Plus',                 category: 'Smartphone', customsValueUsd: 92),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia G21',                      category: 'Smartphone', customsValueUsd: 100),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia G22',                      category: 'Smartphone', customsValueUsd: 108),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia G42 5G',                   category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia G60 5G',                   category: 'Smartphone', customsValueUsd: 182),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia X30 5G',                   category: 'Smartphone', customsValueUsd: 240),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia X35 5G',                   category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Nokia', model: 'Nokia XR21',                     category: 'Smartphone', customsValueUsd: 295),
    PtaDeviceEntry(brand: 'Nokia', model: 'HMD Pulse',                      category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Nokia', model: 'HMD Pulse+',                     category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Nokia', model: 'HMD Pulse Pro',                  category: 'Smartphone', customsValueUsd: 100),
    PtaDeviceEntry(brand: 'Nokia', model: 'HMD Vibe',                       category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Nokia', model: 'HMD Skyline',                    category: 'Smartphone', customsValueUsd: 338),

    // ══════════════════════════════════════════════════════════════════════
    // REALME
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C25Y',                   category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C30',                    category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C30s',                   category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C31',                    category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C33',                    category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C35',                    category: 'Smartphone', customsValueUsd: 82),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C51',                    category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C53',                    category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C55',                    category: 'Smartphone', customsValueUsd: 88),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C61',                    category: 'Smartphone', customsValueUsd: 82),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C63',                    category: 'Smartphone', customsValueUsd: 87),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C65',                    category: 'Smartphone', customsValueUsd: 92),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C67',                    category: 'Smartphone', customsValueUsd: 95),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme C75',                    category: 'Smartphone', customsValueUsd: 100),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 9',                      category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 9 Pro',                  category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 9 Pro+',                 category: 'Smartphone', customsValueUsd: 208),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 9i',                     category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 10',                     category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 10 Pro',                 category: 'Smartphone', customsValueUsd: 182),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 10 Pro+',                category: 'Smartphone', customsValueUsd: 218),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 11',                     category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 11 Pro',                 category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 11 Pro+',                category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 11x 5G',                 category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 12',                     category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 12 Pro',                 category: 'Smartphone', customsValueUsd: 230),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 12 Pro+',                category: 'Smartphone', customsValueUsd: 278),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 12x',                    category: 'Smartphone', customsValueUsd: 128),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 13',                     category: 'Smartphone', customsValueUsd: 162),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 13 Pro',                 category: 'Smartphone', customsValueUsd: 248),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 13 Pro+',                category: 'Smartphone', customsValueUsd: 298),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 13x',                    category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 14 Pro',                 category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme 14 Pro+',                category: 'Smartphone', customsValueUsd: 318),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 2',                   category: 'Smartphone', customsValueUsd: 308),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 2 Pro',               category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 3',                   category: 'Smartphone', customsValueUsd: 348),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 5',                   category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 6',                   category: 'Smartphone', customsValueUsd: 425),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 6T',                  category: 'Smartphone', customsValueUsd: 355),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 7',                   category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 7 Pro',               category: 'Smartphone', customsValueUsd: 482),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme GT 7T',                  category: 'Smartphone', customsValueUsd: 405),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Narzo 60',               category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Narzo 60 Pro',           category: 'Smartphone', customsValueUsd: 188),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Narzo 70',               category: 'Smartphone', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Narzo 70 Pro',           category: 'Smartphone', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Pad',                    category: 'Tablet',     customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Pad Mini',               category: 'Tablet',     customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Pad 2',                  category: 'Tablet',     customsValueUsd: 192),
    PtaDeviceEntry(brand: 'Realme', model: 'Realme Pad X',                  category: 'Tablet',     customsValueUsd: 238),

    // ══════════════════════════════════════════════════════════════════════
    // NOTHING
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Nothing', model: 'Nothing Phone (1)',             category: 'Smartphone', customsValueUsd: 265),
    PtaDeviceEntry(brand: 'Nothing', model: 'Nothing Phone (2)',             category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'Nothing', model: 'Nothing Phone (2a)',            category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Nothing', model: 'Nothing Phone (2a) Plus',      category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Nothing', model: 'Nothing Phone (3a)',            category: 'Smartphone', customsValueUsd: 285),
    PtaDeviceEntry(brand: 'Nothing', model: 'Nothing Phone (3a) Pro',       category: 'Smartphone', customsValueUsd: 345),
    PtaDeviceEntry(brand: 'Nothing', model: 'Nothing Phone (3)',             category: 'Smartphone', customsValueUsd: 482),

    // ══════════════════════════════════════════════════════════════════════
    // SONY
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 10 IV',               category: 'Smartphone', customsValueUsd: 325),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 10 V',                category: 'Smartphone', customsValueUsd: 345),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 10 VI',               category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 5 IV',                category: 'Smartphone', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 5 V',                 category: 'Smartphone', customsValueUsd: 540),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 5 VI',                category: 'Smartphone', customsValueUsd: 578),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 1 IV',                category: 'Smartphone', customsValueUsd: 648),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 1 V',                 category: 'Smartphone', customsValueUsd: 678),
    PtaDeviceEntry(brand: 'Sony', model: 'Sony Xperia 1 VI',                category: 'Smartphone', customsValueUsd: 725),

    // ══════════════════════════════════════════════════════════════════════
    // MOTOROLA
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G31',                    category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G32',                    category: 'Smartphone', customsValueUsd: 112),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G42',                    category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G52',                    category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G53 5G',                 category: 'Smartphone', customsValueUsd: 150),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G54 5G',                 category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G62 5G',                 category: 'Smartphone', customsValueUsd: 160),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G64 5G',                 category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G72',                    category: 'Smartphone', customsValueUsd: 168),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G73 5G',                 category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G84 5G',                 category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G85 5G',                 category: 'Smartphone', customsValueUsd: 182),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G Power 5G (2024)',      category: 'Smartphone', customsValueUsd: 162),
    PtaDeviceEntry(brand: 'Motorola', model: 'Moto G Stylus 5G (2024)',     category: 'Smartphone', customsValueUsd: 192),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 30',            category: 'Smartphone', customsValueUsd: 248),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 30 Pro',        category: 'Smartphone', customsValueUsd: 338),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 30 Neo',        category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 40',            category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 40 Neo',        category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 40 Pro',        category: 'Smartphone', customsValueUsd: 405),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 50',            category: 'Smartphone', customsValueUsd: 278),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 50 Fusion',     category: 'Smartphone', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 50 Neo',        category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 50 Pro',        category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 50 Ultra',      category: 'Smartphone', customsValueUsd: 462),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 60 Pro',        category: 'Smartphone', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Edge 60 Fusion',     category: 'Smartphone', customsValueUsd: 258),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Razr 40',            category: 'Smartphone', customsValueUsd: 558),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Razr 40 Ultra',      category: 'Smartphone', customsValueUsd: 658),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Razr 50',            category: 'Smartphone', customsValueUsd: 608),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Razr 50 Ultra',      category: 'Smartphone', customsValueUsd: 738),
    PtaDeviceEntry(brand: 'Motorola', model: 'Motorola Razr+ (2024)',       category: 'Smartphone', customsValueUsd: 678),

    // ══════════════════════════════════════════════════════════════════════
    // HONOR
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X6',                       category: 'Smartphone', customsValueUsd: 95),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X6a',                      category: 'Smartphone', customsValueUsd: 98),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X6b',                      category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X7',                       category: 'Smartphone', customsValueUsd: 112),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X7a',                      category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X7b',                      category: 'Smartphone', customsValueUsd: 118),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X8',                       category: 'Smartphone', customsValueUsd: 120),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X8a',                      category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X8b',                      category: 'Smartphone', customsValueUsd: 128),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X9',                       category: 'Smartphone', customsValueUsd: 162),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X9a',                      category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X9b',                      category: 'Smartphone', customsValueUsd: 192),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X9c',                      category: 'Smartphone', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X9d 5G',                   category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X50',                      category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X50i',                     category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor X50 GT',                   category: 'Smartphone', customsValueUsd: 208),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor 90',                       category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor 90 Lite',                  category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor 90 Pro',                   category: 'Smartphone', customsValueUsd: 328),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor 200',                      category: 'Smartphone', customsValueUsd: 345),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor 200 Lite',                 category: 'Smartphone', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor 200 Pro',                  category: 'Smartphone', customsValueUsd: 425),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor 200 Smart',                category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Magic 5 Lite',             category: 'Smartphone', customsValueUsd: 248),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Magic 5 Pro',              category: 'Smartphone', customsValueUsd: 598),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Magic 6 Lite',             category: 'Smartphone', customsValueUsd: 268),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Magic 6 Pro',              category: 'Smartphone', customsValueUsd: 678),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Magic V2',                 category: 'Smartphone', customsValueUsd: 878),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Magic V3',                 category: 'Smartphone', customsValueUsd: 938),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Pad 8',                    category: 'Tablet',     customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Pad 9',                    category: 'Tablet',     customsValueUsd: 248),
    PtaDeviceEntry(brand: 'Honor', model: 'Honor Pad X9',                   category: 'Tablet',     customsValueUsd: 210),

    // ══════════════════════════════════════════════════════════════════════
    // TECNO
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno POP 6',                    category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno POP 6 Pro',                category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno POP 7',                    category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno POP 7 Pro',                category: 'Smartphone', customsValueUsd: 55),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno POP 8',                    category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 9',                  category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 9 Pro',              category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 10',                 category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 10 Pro',             category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 10 NFC',             category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 10C',                category: 'Smartphone', customsValueUsd: 55),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 20',                 category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 20 Pro',             category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 20 Pro+',            category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 20C',                category: 'Smartphone', customsValueUsd: 60),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 30',                 category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 30 Pro',             category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Spark 30C',                category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 19',                 category: 'Smartphone', customsValueUsd: 108),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 19 Pro',             category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 20',                 category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 20 Pro',             category: 'Smartphone', customsValueUsd: 148),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 20 Pro 5G',         category: 'Smartphone', customsValueUsd: 162),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 20 Premier',        category: 'Smartphone', customsValueUsd: 182),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 30',                 category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 30 Pro',             category: 'Smartphone', customsValueUsd: 162),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 30 Pro 5G',         category: 'Smartphone', customsValueUsd: 178),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 30 Premier',        category: 'Smartphone', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Camon 30S',                category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Pova 5',                   category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Pova 5 Pro',               category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Pova 6',                   category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Pova 6 Pro',               category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Phantom X2',               category: 'Smartphone', customsValueUsd: 288),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Phantom X2 Pro',           category: 'Smartphone', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Phantom V Fold',           category: 'Smartphone', customsValueUsd: 558),
    PtaDeviceEntry(brand: 'Tecno', model: 'Tecno Phantom V Flip',           category: 'Smartphone', customsValueUsd: 480),

    // ══════════════════════════════════════════════════════════════════════
    // INFINIX
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 6',              category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 7',              category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 7 HD',           category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 8',              category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 8 Plus',         category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 8 HD',           category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 9',              category: 'Smartphone', customsValueUsd: 55),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Smart 9 HD',           category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 20',               category: 'Smartphone', customsValueUsd: 75),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 20i',              category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 20s',              category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 20 Play',          category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 30',               category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 30i',              category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 30 Play',          category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 40',               category: 'Smartphone', customsValueUsd: 72),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 40i',              category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 40 Pro',           category: 'Smartphone', customsValueUsd: 85),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 50',               category: 'Smartphone', customsValueUsd: 78),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 50i',              category: 'Smartphone', customsValueUsd: 68),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 50 Pro',           category: 'Smartphone', customsValueUsd: 92),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Hot 50 Pro+',          category: 'Smartphone', customsValueUsd: 105),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 12',              category: 'Smartphone', customsValueUsd: 115),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 12 Pro',          category: 'Smartphone', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 12 G96',         category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 30',              category: 'Smartphone', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 30 Pro',          category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 30 VIP',          category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 40',              category: 'Smartphone', customsValueUsd: 132),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 40 Pro',          category: 'Smartphone', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 40 Pro+ 5G',      category: 'Smartphone', customsValueUsd: 192),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 40X 5G',          category: 'Smartphone', customsValueUsd: 152),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 50',              category: 'Smartphone', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 50 Pro',          category: 'Smartphone', customsValueUsd: 182),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Note 50 Pro+ 5G',      category: 'Smartphone', customsValueUsd: 210),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix GT 10 Pro',            category: 'Smartphone', customsValueUsd: 195),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix GT 20 Pro',            category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Zero 30 5G',           category: 'Smartphone', customsValueUsd: 228),
    PtaDeviceEntry(brand: 'Infinix', model: 'Infinix Zero 40 5G',           category: 'Smartphone', customsValueUsd: 248),

    // ══════════════════════════════════════════════════════════════════════
    // ITEL
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Itel', model: 'Itel A23 Pro',                    category: 'Smartphone', customsValueUsd: 35),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel A50',                        category: 'Smartphone', customsValueUsd: 38),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel A50C',                       category: 'Smartphone', customsValueUsd: 36),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel A60',                        category: 'Smartphone', customsValueUsd: 42),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel A70',                        category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel A70s',                       category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel P40',                        category: 'Smartphone', customsValueUsd: 38),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel P55',                        category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel P55+',                       category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel P55 NFC',                    category: 'Smartphone', customsValueUsd: 60),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel P65',                        category: 'Smartphone', customsValueUsd: 62),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel RS4',                        category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel S23',                        category: 'Smartphone', customsValueUsd: 52),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel S23+',                       category: 'Smartphone', customsValueUsd: 58),
    PtaDeviceEntry(brand: 'Itel', model: 'Itel S24',                        category: 'Smartphone', customsValueUsd: 58),

    // ══════════════════════════════════════════════════════════════════════
    // QMOBILE
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'QMobile', model: 'QMobile LT950',               category: 'Smartphone', customsValueUsd: 38),
    PtaDeviceEntry(brand: 'QMobile', model: 'QMobile CS1 Plus',            category: 'Smartphone', customsValueUsd: 45),
    PtaDeviceEntry(brand: 'QMobile', model: 'QMobile Noir J7',             category: 'Smartphone', customsValueUsd: 48),
    PtaDeviceEntry(brand: 'QMobile', model: 'QMobile Noir Z12',            category: 'Smartphone', customsValueUsd: 55),
    PtaDeviceEntry(brand: 'QMobile', model: 'QMobile Noir Z16 Plus',       category: 'Smartphone', customsValueUsd: 65),
    PtaDeviceEntry(brand: 'QMobile', model: 'QMobile Noir Z18',            category: 'Smartphone', customsValueUsd: 75),

    // ══════════════════════════════════════════════════════════════════════
    // ASUS ROG PHONES
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Asus', model: 'ROG Phone 6',                    category: 'Smartphone', customsValueUsd: 632),
    PtaDeviceEntry(brand: 'Asus', model: 'ROG Phone 6 Pro',                category: 'Smartphone', customsValueUsd: 758),
    PtaDeviceEntry(brand: 'Asus', model: 'ROG Phone 7',                    category: 'Smartphone', customsValueUsd: 758),
    PtaDeviceEntry(brand: 'Asus', model: 'ROG Phone 7 Ultimate',           category: 'Smartphone', customsValueUsd: 878),
    PtaDeviceEntry(brand: 'Asus', model: 'ROG Phone 8',                    category: 'Smartphone', customsValueUsd: 878),
    PtaDeviceEntry(brand: 'Asus', model: 'ROG Phone 8 Pro',                category: 'Smartphone', customsValueUsd: 978),

    // ── ASUS Laptops ──────────────────────────────────────────────────────
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS VivoBook 14',               category: 'Laptop', customsValueUsd: 480),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS VivoBook 15',               category: 'Laptop', customsValueUsd: 530),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS VivoBook 16',               category: 'Laptop', customsValueUsd: 578),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS VivoBook S 14 OLED',        category: 'Laptop', customsValueUsd: 725),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS VivoBook S 15 OLED',        category: 'Laptop', customsValueUsd: 775),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ZenBook 14 OLED',           category: 'Laptop', customsValueUsd: 925),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ZenBook 14X OLED',          category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ZenBook Duo 14',            category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ExpertBook B1500',          category: 'Laptop', customsValueUsd: 725),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ExpertBook B9 OLED',        category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ROG Zephyrus G14 (2023)',   category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ROG Zephyrus G14 (2024)',   category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ROG Zephyrus G16 (2024)',   category: 'Laptop', customsValueUsd: 1450),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ROG Strix G15',             category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ROG Strix G16',             category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ROG Strix G18',             category: 'Laptop', customsValueUsd: 1450),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ROG Strix SCAR 16',         category: 'Laptop', customsValueUsd: 1850),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS TUF Gaming A15',            category: 'Laptop', customsValueUsd: 825),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS TUF Gaming A16',            category: 'Laptop', customsValueUsd: 875),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS TUF Gaming F15',            category: 'Laptop', customsValueUsd: 875),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS TUF Gaming F17',            category: 'Laptop', customsValueUsd: 925),
    PtaDeviceEntry(brand: 'Asus', model: 'ASUS ProArt Studiobook 16',      category: 'Laptop', customsValueUsd: 1850),

    // ══════════════════════════════════════════════════════════════════════
    // LENOVO
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab M9',                 category: 'Tablet', customsValueUsd: 125),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab M10 (3rd Gen)',      category: 'Tablet', customsValueUsd: 142),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab M10 Plus (3rd Gen)', category: 'Tablet', customsValueUsd: 158),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab M10 FHD Plus',      category: 'Tablet', customsValueUsd: 140),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab M11',                category: 'Tablet', customsValueUsd: 172),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab P11 (2nd Gen)',      category: 'Tablet', customsValueUsd: 200),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab P11 Gen 2',         category: 'Tablet', customsValueUsd: 238),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab P11 Pro',            category: 'Tablet', customsValueUsd: 308),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab P12',                category: 'Tablet', customsValueUsd: 365),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Tab P12 Pro',            category: 'Tablet', customsValueUsd: 462),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Legion Tab Gen 2',      category: 'Tablet', customsValueUsd: 578),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo IdeaPad 1',              category: 'Laptop', customsValueUsd: 405),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo IdeaPad 3',              category: 'Laptop', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo IdeaPad 5',              category: 'Laptop', customsValueUsd: 598),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo IdeaPad Slim 3',         category: 'Laptop', customsValueUsd: 462),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo IdeaPad Slim 5',         category: 'Laptop', customsValueUsd: 628),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo IdeaPad Slim 5i',        category: 'Laptop', customsValueUsd: 658),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo ThinkPad E14 Gen 4',     category: 'Laptop', customsValueUsd: 775),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo ThinkPad E14 Gen 5',     category: 'Laptop', customsValueUsd: 825),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo ThinkPad E15 Gen 4',     category: 'Laptop', customsValueUsd: 798),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo ThinkPad X1 Carbon Gen 11', category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo ThinkPad X1 Carbon Gen 12', category: 'Laptop', customsValueUsd: 1320),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Yoga 7i (2023)',         category: 'Laptop', customsValueUsd: 875),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Yoga 7i (2024)',         category: 'Laptop', customsValueUsd: 925),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Yoga 9i',                category: 'Laptop', customsValueUsd: 1168),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Legion 5 Gen 8',         category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Legion 5 Gen 9',         category: 'Laptop', customsValueUsd: 1090),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Legion 5 Pro Gen 8',     category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'Lenovo', model: 'Lenovo Legion 7i Gen 8',        category: 'Laptop', customsValueUsd: 1450),

    // ══════════════════════════════════════════════════════════════════════
    // DELL
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Inspiron 14 (5430)',         category: 'Laptop', customsValueUsd: 600),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Inspiron 15 (3530)',         category: 'Laptop', customsValueUsd: 530),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Inspiron 15 (5530)',         category: 'Laptop', customsValueUsd: 628),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Inspiron 16 (5630)',         category: 'Laptop', customsValueUsd: 725),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Vostro 14 (3430)',           category: 'Laptop', customsValueUsd: 562),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Vostro 15 (3530)',           category: 'Laptop', customsValueUsd: 598),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Vostro 16 (5630)',           category: 'Laptop', customsValueUsd: 698),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell XPS 13 (9315)',              category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell XPS 13 (9340)',              category: 'Laptop', customsValueUsd: 1118),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell XPS 14 (9440)',              category: 'Laptop', customsValueUsd: 1350),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell XPS 15 (9530)',              category: 'Laptop', customsValueUsd: 1450),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell XPS 15 (9560)',              category: 'Laptop', customsValueUsd: 1550),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell XPS 16 (9640)',              category: 'Laptop', customsValueUsd: 1650),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell G15 5530 (Gaming)',          category: 'Laptop', customsValueUsd: 858),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell G15 5535 (Gaming)',          category: 'Laptop', customsValueUsd: 898),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell G16 7630 (Gaming)',          category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Alienware m16 R1',           category: 'Laptop', customsValueUsd: 1750),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Alienware m16 R2',           category: 'Laptop', customsValueUsd: 1850),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Alienware x14 R2',           category: 'Laptop', customsValueUsd: 1650),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Latitude 14 (5440)',         category: 'Laptop', customsValueUsd: 958),
    PtaDeviceEntry(brand: 'Dell', model: 'Dell Latitude 15 (5540)',         category: 'Laptop', customsValueUsd: 998),

    // ══════════════════════════════════════════════════════════════════════
    // HP
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'HP', model: 'HP 15s (Intel i3)',                 category: 'Laptop', customsValueUsd: 500),
    PtaDeviceEntry(brand: 'HP', model: 'HP 15s (Intel i5)',                 category: 'Laptop', customsValueUsd: 598),
    PtaDeviceEntry(brand: 'HP', model: 'HP 15s (AMD Ryzen 5)',              category: 'Laptop', customsValueUsd: 558),
    PtaDeviceEntry(brand: 'HP', model: 'HP Pavilion 14',                    category: 'Laptop', customsValueUsd: 558),
    PtaDeviceEntry(brand: 'HP', model: 'HP Pavilion 15',                    category: 'Laptop', customsValueUsd: 598),
    PtaDeviceEntry(brand: 'HP', model: 'HP Pavilion 16',                    category: 'Laptop', customsValueUsd: 658),
    PtaDeviceEntry(brand: 'HP', model: 'HP Pavilion Plus 14',               category: 'Laptop', customsValueUsd: 698),
    PtaDeviceEntry(brand: 'HP', model: 'HP Pavilion x360 14"',              category: 'Laptop', customsValueUsd: 725),
    PtaDeviceEntry(brand: 'HP', model: 'HP Envy 13',                        category: 'Laptop', customsValueUsd: 825),
    PtaDeviceEntry(brand: 'HP', model: 'HP Envy 14',                        category: 'Laptop', customsValueUsd: 875),
    PtaDeviceEntry(brand: 'HP', model: 'HP Envy 15',                        category: 'Laptop', customsValueUsd: 875),
    PtaDeviceEntry(brand: 'HP', model: 'HP Envy x360 13"',                  category: 'Laptop', customsValueUsd: 925),
    PtaDeviceEntry(brand: 'HP', model: 'HP Envy x360 15"',                  category: 'Laptop', customsValueUsd: 975),
    PtaDeviceEntry(brand: 'HP', model: 'HP Spectre x360 13.5"',             category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'HP', model: 'HP Spectre x360 14"',               category: 'Laptop', customsValueUsd: 1168),
    PtaDeviceEntry(brand: 'HP', model: 'HP Spectre x360 16"',               category: 'Laptop', customsValueUsd: 1350),
    PtaDeviceEntry(brand: 'HP', model: 'HP EliteBook 840 G9',               category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'HP', model: 'HP EliteBook 840 G10',              category: 'Laptop', customsValueUsd: 1098),
    PtaDeviceEntry(brand: 'HP', model: 'HP EliteBook 865 G10',              category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'HP', model: 'HP Omen 16 (AMD)',                  category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'HP', model: 'HP Omen 16 (Intel)',                category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'HP', model: 'HP Omen Transcend 14',              category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'HP', model: 'HP Victus 15 (AMD)',                category: 'Laptop', customsValueUsd: 725),
    PtaDeviceEntry(brand: 'HP', model: 'HP Victus 15 (Intel)',              category: 'Laptop', customsValueUsd: 775),
    PtaDeviceEntry(brand: 'HP', model: 'HP Victus 16 (AMD)',                category: 'Laptop', customsValueUsd: 795),
    PtaDeviceEntry(brand: 'HP', model: 'HP ProBook 440 G10',                category: 'Laptop', customsValueUsd: 825),
    PtaDeviceEntry(brand: 'HP', model: 'HP ProBook 450 G10',                category: 'Laptop', customsValueUsd: 875),

    // ══════════════════════════════════════════════════════════════════════
    // MICROSOFT SURFACE
    // ══════════════════════════════════════════════════════════════════════
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Go 3',               category: 'Tablet', customsValueUsd: 385),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Go 4',               category: 'Tablet', customsValueUsd: 432),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Pro 8',              category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Pro 9',              category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Pro 10',             category: 'Laptop', customsValueUsd: 1350),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Pro 11 (Copilot+)',  category: 'Laptop', customsValueUsd: 1450),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Laptop 4 (13")',     category: 'Laptop', customsValueUsd: 958),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Laptop 4 (15")',     category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Laptop 5 (13")',     category: 'Laptop', customsValueUsd: 1050),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Laptop 5 (15")',     category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Laptop 6 (13")',     category: 'Laptop', customsValueUsd: 1150),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Laptop 6 (15")',     category: 'Laptop', customsValueUsd: 1250),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Laptop Studio 2',    category: 'Laptop', customsValueUsd: 1650),
    PtaDeviceEntry(brand: 'Microsoft', model: 'Surface Book 3',             category: 'Laptop', customsValueUsd: 1350),
  ];

  // ── Public API ──────────────────────────────────────────────────────────

  static List<String> getBrands() {
    final brands = _devices.map((d) => d.brand).toSet().toList();
    brands.sort();
    return brands;
  }

  static List<PtaDeviceEntry> getModelsForBrand(String brand) =>
      _devices.where((d) => d.brand == brand).toList();

  static PtaDeviceEntry? getDevice(String brand, String model) {
    try {
      return _devices.firstWhere((d) => d.brand == brand && d.model == model);
    } catch (_) {
      return null;
    }
  }

  // ── Calculation Engine ──────────────────────────────────────────────────

  static PtaTaxModel calculate({
    required PtaDeviceEntry device,
    required String registrationType,
  }) {
    final double usdVal = device.customsValueUsd;
    final double pkrVal = usdVal * usdToPkr;
    final bool isCnic = registrationType == 'CNIC';

    double baseDuty = 0;
    double regulatoryDuty = 0;
    String slabLabel = '';

    if (device.category == 'Laptop') {
      baseDuty = 0;
      regulatoryDuty = 0;
      slabLabel = 'Laptop — 0% Customs Duty';
    } else if (usdVal < 30) {
      baseDuty = 430;
      regulatoryDuty = 0;
      slabLabel = 'Under \$30';
    } else if (usdVal < 100) {
      baseDuty = isCnic ? 3000 : 2500;
      regulatoryDuty = 0;
      slabLabel = '\$30–\$100';
    } else if (usdVal < 200) {
      baseDuty = isCnic ? 11561 : 8000;
      regulatoryDuty = pkrVal * 0.03;
      slabLabel = '\$100–\$200';
    } else if (usdVal < 350) {
      baseDuty = isCnic ? 14661 : 12000;
      regulatoryDuty = pkrVal * 0.05;
      slabLabel = '\$200–\$350';
    } else if (usdVal < 500) {
      baseDuty = isCnic ? 23420 : 17800;
      regulatoryDuty = pkrVal * 0.07;
      slabLabel = '\$350–\$500';
    } else {
      baseDuty = isCnic ? 37007 : 27600;
      regulatoryDuty = pkrVal * 0.10;
      slabLabel = 'Above \$500';
    }

    final double salesTax = pkrVal * 0.17;
    final double withholdingTax = pkrVal * 0.01;
    final double totalTax = baseDuty + regulatoryDuty + salesTax + withholdingTax;

    return PtaTaxModel(
      brand: device.brand,
      model: device.model,
      deviceCategory: device.category,
      registrationType: registrationType,
      deviceValueUsd: usdVal,
      usdTopkr: usdToPkr,
      customsDuty: baseDuty,
      regulatoryDuty: regulatoryDuty,
      salesTax: salesTax,
      withholdingTax: withholdingTax,
      totalTax: totalTax,
      slabLabel: slabLabel,
      isTaxable: true,
    );
  }
}