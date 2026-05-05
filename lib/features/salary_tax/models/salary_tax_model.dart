class SalaryTaxModel {
  final double monthlySalary;
  final double annualSalary;
  final double annualTax;
  final double monthlyTax;
  final double netMonthly;
  final double netAnnual;
  final double effectiveTaxRate;
  final double marginalRate;
  final String taxSlab;
  final int slabNumber;

  SalaryTaxModel({
    required this.monthlySalary,
    required this.annualSalary,
    required this.annualTax,
    required this.monthlyTax,
    required this.netMonthly,
    required this.netAnnual,
    required this.effectiveTaxRate,
    required this.marginalRate,
    required this.taxSlab,
    required this.slabNumber,
  });

  bool get isTaxExempt => annualTax == 0;
}
