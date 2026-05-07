
class PtaTaxModel {
  // Inputs
  final String brand;
  final String model;
  final String deviceCategory; // e.g. 'Smartphone', 'Tablet', 'Laptop'
  final String registrationType; // 'CNIC' or 'Passport'
  final double deviceValueUsd;  // FBR customs value (USD)
  final double usdTopkr;        // Exchange rate used

  // Tax Components (PKR)
  final double customsDuty;
  final double regulatoryDuty;
  final double salesTax;
  final double withholdingTax;
  final double totalTax;

  // Result
  final String slabLabel;
  final bool isTaxable;

  const PtaTaxModel({
    required this.brand,
    required this.model,
    required this.deviceCategory,
    required this.registrationType,
    required this.deviceValueUsd,
    required this.usdTopkr,
    required this.customsDuty,
    required this.regulatoryDuty,
    required this.salesTax,
    required this.withholdingTax,
    required this.totalTax,
    required this.slabLabel,
    required this.isTaxable,
  });

  factory PtaTaxModel.empty() => const PtaTaxModel(
    brand: '',
    model: '',
    deviceCategory: '',
    registrationType: 'CNIC',
    deviceValueUsd: 0,
    usdTopkr: 280,
    customsDuty: 0,
    regulatoryDuty: 0,
    salesTax: 0,
    withholdingTax: 0,
    totalTax: 0,
    slabLabel: '',
    isTaxable: false,
  );

  double get effectiveRate => deviceValueUsd > 0
      ? (totalTax / (deviceValueUsd * usdTopkr)) * 100
      : 0;
}

/// Device data entry used in the brand→model database
class PtaDeviceEntry {
  final String brand;
  final String model;
  final String category;
  final double customsValueUsd; // FBR official customs value in USD

  const PtaDeviceEntry({
    required this.brand,
    required this.model,
    required this.category,
    required this.customsValueUsd,
  });
}