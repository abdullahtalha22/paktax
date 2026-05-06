import 'package:flutter/material.dart';
import '../models/salary_tax_model.dart';
import '../services/salary_tax_service.dart';

class SalaryTaxController extends ChangeNotifier {
  final TextEditingController salaryController = TextEditingController();

  // Always show results — starts at zero
  SalaryTaxModel result = SalaryTaxService.calculate(0);

  SalaryTaxController() {
    salaryController.addListener(_onSalaryChanged);
    // Seed with zero state
    result = SalaryTaxService.calculate(0);
  }

  void _onSalaryChanged() {
    final double salary =
        double.tryParse(salaryController.text.replaceAll(',', '')) ?? 0;
    result = SalaryTaxService.calculate(salary.clamp(0, double.infinity));
    notifyListeners();
  }

  double get currentSalary =>
      double.tryParse(salaryController.text.replaceAll(',', '')) ?? 0;

  bool get hasInput => currentSalary > 0;

  void reset() {
    salaryController.clear();
    result = SalaryTaxService.calculate(0);
    notifyListeners();
  }

  @override
  void dispose() {
    salaryController.removeListener(_onSalaryChanged);
    salaryController.dispose();
    super.dispose();
  }
}