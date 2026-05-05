import 'package:flutter/material.dart';
import '../features/salary_tax/screens/salary_tax_screen.dart';
import '../features/withholding_tax/screens/withholding_tax_screen.dart';
import '../features/pta_tax/screens/pta_tax_screen.dart';
import '../features/remittance_tax/screens/remittance_tax_screen.dart';

class AppRoutes {
  static const String salaryTax      = '/salary-tax';
  static const String withholdingTax = '/withholding-tax';
  static const String ptaTax         = '/pta-tax';
  static const String remittanceTax  = '/remittance-tax';

  static Map<String, WidgetBuilder> get routes => {
    salaryTax:      (_) => const SalaryTaxScreen(),
    withholdingTax: (_) => const WithholdingTaxScreen(),
    ptaTax:         (_) => const PtaTaxScreen(),
    remittanceTax:  (_) => const RemittanceTaxScreen(),
  };
}
