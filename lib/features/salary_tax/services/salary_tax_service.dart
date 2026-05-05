import '../models/salary_tax_model.dart';

/// FBR Salary Tax Slabs — Tax Year 2025–26 (1 July 2025 – 30 June 2026)
/// Source: Finance Act 2025
/// Salaried persons — progressive slabs on ANNUAL income
class SalaryTaxService {
  static SalaryTaxModel calculate(double monthlySalary) {
    final double annualSalary = monthlySalary * 12;

    double annualTax = 0;
    String slabLabel = '';
    int slabNumber = 0;
    double marginalRate = 0;

    if (annualSalary <= 600000) {
      annualTax    = 0;
      slabLabel    = 'Tax Exempt';
      slabNumber   = 1;
      marginalRate = 0;
    } else if (annualSalary <= 1200000) {
      annualTax    = (annualSalary - 600000) * 0.05;
      slabLabel    = 'Slab 2 — 5%';
      slabNumber   = 2;
      marginalRate = 5;
    } else if (annualSalary <= 2200000) {
      annualTax    = 30000 + (annualSalary - 1200000) * 0.15;
      slabLabel    = 'Slab 3 — 15%';
      slabNumber   = 3;
      marginalRate = 15;
    } else if (annualSalary <= 3200000) {
      annualTax    = 180000 + (annualSalary - 2200000) * 0.25;
      slabLabel    = 'Slab 4 — 25%';
      slabNumber   = 4;
      marginalRate = 25;
    } else if (annualSalary <= 4100000) {
      annualTax    = 430000 + (annualSalary - 3200000) * 0.30;
      slabLabel    = 'Slab 5 — 30%';
      slabNumber   = 5;
      marginalRate = 30;
    } else {
      annualTax    = 700000 + (annualSalary - 4100000) * 0.35;
      slabLabel    = 'Slab 6 — 35%';
      slabNumber   = 6;
      marginalRate = 35;
    }

    final double monthlyTax    = annualTax / 12;
    final double netMonthly    = monthlySalary - monthlyTax;
    final double netAnnual     = annualSalary - annualTax;
    final double effectiveRate = annualSalary > 0
        ? (annualTax / annualSalary) * 100
        : 0;

    return SalaryTaxModel(
      monthlySalary:   monthlySalary,
      annualSalary:    annualSalary,
      annualTax:       annualTax,
      monthlyTax:      monthlyTax,
      netMonthly:      netMonthly,
      netAnnual:       netAnnual,
      effectiveTaxRate: effectiveRate,
      marginalRate:    marginalRate,
      taxSlab:         slabLabel,
      slabNumber:      slabNumber,
    );
  }
}
