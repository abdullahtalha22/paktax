import 'package:flutter/material.dart';
import '../models/pta_tax_model.dart';
import '../services/pta_tax_service.dart';

class PtaTaxController extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────
  String? selectedBrand;
  PtaDeviceEntry? selectedDevice;
  String registrationType = 'CNIC';
  PtaTaxModel? result;
  bool hasCalculated = false;
  String searchQuery = '';

  // ── Derived ────────────────────────────────────────────────────────────
  List<String> get brands => PtaTaxService.getBrands();

  List<PtaDeviceEntry> get modelsForSelectedBrand =>
      selectedBrand != null ? PtaTaxService.getModelsForBrand(selectedBrand!) : [];

  List<PtaDeviceEntry> get previewModels => modelsForSelectedBrand.take(5).toList();

  List<PtaDeviceEntry> get filteredModels {
    if (searchQuery.trim().isEmpty) return modelsForSelectedBrand;
    final q = searchQuery.toLowerCase();
    return modelsForSelectedBrand
        .where((d) => d.model.toLowerCase().contains(q))
        .toList();
  }

  // ── Actions ────────────────────────────────────────────────────────────
  void selectBrand(String brand) {
    selectedBrand = brand;
    selectedDevice = null;
    result = null;
    hasCalculated = false;
    searchQuery = '';
    notifyListeners();
  }

  void selectDevice(PtaDeviceEntry device) {
    selectedDevice = device;
    _calculate();
    notifyListeners();
  }

  void setRegistrationType(String type) {
    registrationType = type;
    if (selectedDevice != null) _calculate();
    notifyListeners();
  }

  void setSearchQuery(String q) {
    searchQuery = q;
    notifyListeners();
  }

  void calculate() {
    if (selectedDevice == null) return;
    _calculate();
    notifyListeners();
  }

  void _calculate() {
    if (selectedDevice == null) return;
    result = PtaTaxService.calculate(
      device: selectedDevice!,
      registrationType: registrationType,
    );
    hasCalculated = true;
  }

  void reset() {
    selectedBrand = null;
    selectedDevice = null;
    result = null;
    hasCalculated = false;
    searchQuery = '';
    notifyListeners();
  }
}