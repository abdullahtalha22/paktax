import 'package:flutter/material.dart';
import '../models/withholding_tax_model.dart';
import '../services/withholding_tax_service.dart';

class WithholdingTaxController extends ChangeNotifier {
  final TextEditingController amountController = TextEditingController();

  String _selectedType = WithholdingTaxService.contractorFiler;

  // Always show results — starts at zero (mirrors SalaryTaxController)
  WithholdingTaxModel result = WithholdingTaxService.calculate(
    grossAmount: 0,
    paymentType: WithholdingTaxService.contractorFiler,
  );

  WithholdingTaxController() {
    amountController.addListener(_onAmountChanged);
    // Seed with zero state
    result = WithholdingTaxService.calculate(
      grossAmount: 0,
      paymentType: _selectedType,
    );
  }

  // ── Getters ────────────────────────────────────────────────────────────────

  String get selectedType => _selectedType;

  double get currentAmount =>
      double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;

  bool get hasInput => currentAmount > 0;

  List<String> get allTypes => WithholdingTaxService.allTypes;

  // ── Setters / Actions ─────────────────────────────────────────────────────

  void setPaymentType(String type) {
    _selectedType = type;
    _recalculate();
  }

  /// Toggle between filer / non-filer for the current category
  void toggleFilerStatus() {
    _selectedType = WithholdingTaxService.toggleFilerStatus(_selectedType);
    _recalculate();
  }

  void reset() {
    amountController.clear();
    _selectedType = WithholdingTaxService.contractorFiler;
    result = WithholdingTaxService.calculate(
      grossAmount: 0,
      paymentType: _selectedType,
    );
    notifyListeners();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _onAmountChanged() => _recalculate();

  void _recalculate() {
    result = WithholdingTaxService.calculate(
      grossAmount: currentAmount.clamp(0, double.infinity),
      paymentType: _selectedType,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    amountController.removeListener(_onAmountChanged);
    amountController.dispose();
    super.dispose();
  }
}
