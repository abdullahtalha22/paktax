import 'package:flutter/material.dart';
import '../models/salary_tax_model.dart';
import '../services/salary_tax_service.dart';

class SalaryTaxController extends ChangeNotifier {
  final TextEditingController salaryController = TextEditingController();

  SalaryTaxModel? result;
  bool hasCalculated = false;

  void calculate() {
    final double salary =
        double.tryParse(salaryController.text.replaceAll(',', '')) ?? 0;
    if (salary <= 0) return;
    result = SalaryTaxService.calculate(salary);
    hasCalculated = true;
    notifyListeners();
  }

  void reset() {
    salaryController.clear();
    result = null;
    hasCalculated = false;
    notifyListeners();
  }

  @override
  void dispose() {
    salaryController.dispose();
    super.dispose();
  }
}
