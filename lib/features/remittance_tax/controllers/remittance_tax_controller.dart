import 'package:flutter/material.dart';
import '../models/remittance_tax_model.dart';
import '../services/remittance_tax_service.dart';

class RemittanceTaxController extends ChangeNotifier {
  final TextEditingController amountController = TextEditingController();

  String _selectedChannel = RemittanceTaxService.inwardBankFiler;

  // Always show results — starts at zero (mirrors other calculators)
  RemittanceTaxModel result = RemittanceTaxService.calculate(
    amount: 0,
    channelKey: RemittanceTaxService.inwardBankFiler,
  );

  RemittanceTaxController() {
    amountController.addListener(_onAmountChanged);
    result = RemittanceTaxService.calculate(
      amount: 0,
      channelKey: _selectedChannel,
    );
  }

  // ── Getters ──────────────────────────────────────────────────────────────
  String get selectedChannel => _selectedChannel;

  double get currentAmount =>
      double.tryParse(amountController.text.replaceAll(',', '')) ?? 0;

  bool get hasInput => currentAmount > 0;

  bool get isInward => result.direction == RemittanceDirection.inward;

  List<String> get inwardChannels => RemittanceTaxService.inwardChannels;
  List<String> get outwardChannels => RemittanceTaxService.outwardChannels;

  // ── Actions ──────────────────────────────────────────────────────────────
  void setChannel(String key) {
    _selectedChannel = key;
    _recalculate();
  }

  void toggleFilerStatus() {
    _selectedChannel = RemittanceTaxService.toggleFilerStatus(_selectedChannel);
    _recalculate();
  }

  void reset() {
    amountController.clear();
    _selectedChannel = RemittanceTaxService.inwardBankFiler;
    result = RemittanceTaxService.calculate(amount: 0, channelKey: _selectedChannel);
    notifyListeners();
  }

  // ── Private ──────────────────────────────────────────────────────────────
  void _onAmountChanged() => _recalculate();

  void _recalculate() {
    result = RemittanceTaxService.calculate(
      amount: currentAmount.clamp(0, double.infinity),
      channelKey: _selectedChannel,
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