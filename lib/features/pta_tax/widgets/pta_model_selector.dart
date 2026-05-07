import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/pta_tax_controller.dart';
import '../models/pta_tax_model.dart';
import 'pta_brand_registration_card.dart';

// ── Model Selector Card ───────────────────────────────────────────────────
class PtaModelSelector extends StatelessWidget {
  final PtaTaxController ctrl;
  final bool isDark;
  const PtaModelSelector({super.key, required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final preview = ctrl.previewModels;
    final total = ctrl.modelsForSelectedBrand.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.ptaPurple.withOpacity(0.07)
                : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: isDark
                    ? AppColors.ptaPurple.withOpacity(0.16)
                    : AppColors.lightBorder),
            boxShadow: [
              BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.24)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Step header + count badge ──────────────────────────────
            Row(children: [
              Expanded(
                child: PtaStepLabel(
                    step: '3',
                    label: 'Select Model — ${ctrl.selectedBrand}',
                    color: AppColors.ptaPurple),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.ptaPurple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('$total devices',
                    style: GoogleFonts.sora(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ptaPurple)),
              ),
            ]),

            const SizedBox(height: 14),

            // ── Horizontal scrollable preview (max 5 cards) ────────────
            SizedBox(
              height: 115,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 4),
                physics: const BouncingScrollPhysics(),
                itemCount: preview.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final device = preview[index];
                  final isSelected =
                      ctrl.selectedDevice?.model == device.model;
                  return _HorizontalModelCard(
                    device: device,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () => ctrl.selectDevice(device),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ── Search bar + See All button ────────────────────────────
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAllModelsSheet(context, ctrl, isDark),
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkElevated
                          : AppColors.lightElevated,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                    ),
                    child: Row(children: [
                      Icon(Icons.search_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textGrey1
                              : AppColors.textGrey2),
                      const SizedBox(width: 8),
                      Text(
                        'Search ${ctrl.selectedBrand} devices...',
                        style: GoogleFonts.sora(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textGrey2
                                : AppColors.textGrey1),
                      ),
                    ]),
                  ),
                ),
              ),

              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showAllModelsSheet(context, ctrl, isDark),
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient:
                    const LinearGradient(colors: AppColors.ptaGrad),
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.ptaPurple.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('See All',
                        style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 10, color: Colors.white),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () => _showCustomCalculator(context, ctrl, isDark),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                      const Color(0xFF181830),
                      const Color(0xFF232347),
                    ]
                        : [
                      Colors.white,
                      const Color(0xFFF5F7FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.ptaPurple.withOpacity(isDark ? 0.35 : 0.20),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ptaPurple.withOpacity(0.18),
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    // Left glowing icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.ptaGrad,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ptaPurple.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calculate_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Text section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Custom PTA Tax Calculator',
                            style: GoogleFonts.sora(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textWhite
                                  : AppColors.textDark,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Enter manual USD customs value for unlisted devices',
                            style: GoogleFonts.sora(
                              fontSize: 10,
                              height: 1.4,
                              color: isDark
                                  ? AppColors.textGrey1
                                  : AppColors.textGrey2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Arrow button
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.ptaPurple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.ptaPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _showCustomCalculator(
      BuildContext context,
      PtaTaxController ctrl,
      bool isDark,
      ) {
    final TextEditingController usdCtrl = TextEditingController();

    // No default selected category
    String? selectedCategory;

    void calculateDevice() {
      final val = double.tryParse(usdCtrl.text.trim());

      // Validation
      if (val == null ||
          val <= 0 ||
          selectedCategory == null) {
        return;
      }

      final entry = PtaDeviceEntry(
        brand: 'Custom',
        model: 'Custom Device (\$$val)',
        category: selectedCategory!,
        customsValueUsd: val,
      );

      // Update selected device + calculate PTA tax
      ctrl.selectDevice(entry);

      // Close popup only
      Navigator.of(context).pop();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF111122)
                    : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                border: Border.all(
                  color: AppColors.ptaPurple.withOpacity(0.18),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Handle Bar
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Icon
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.ptaGrad,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ptaPurple.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Custom PTA Calculator',
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Enter FBR customs value for unlisted devices',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(
                      fontSize: 11,
                      height: 1.5,
                      color: isDark
                          ? AppColors.textGrey1
                          : AppColors.textGrey2,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // USD Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkElevated
                          : AppColors.lightElevated,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.ptaPurple.withOpacity(0.15),
                      ),
                    ),
                    child: TextField(
                      controller: usdCtrl,
                      keyboardType:
                      const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      // Calculate on Enter key
                      onSubmitted: (_) => calculateDevice(),

                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textDark,
                      ),

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),

                        prefixIcon: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.ptaGrad,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.attach_money_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        hintText: 'Enter USD value',
                        hintStyle: GoogleFonts.sora(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textGrey2
                              : AppColors.textGrey1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Category Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Device Category',
                      style: GoogleFonts.sora(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Category Selector
                  Row(
                    children: [
                      'Smartphone',
                      'Tablet',
                      'Laptop',
                    ].map((cat) {

                      final isSelected =
                          selectedCategory == cat;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = cat;
                            });

                            // Auto calculate after selecting category
                            if (usdCtrl.text.trim().isNotEmpty &&
                                selectedCategory != null) {
                              calculateDevice();
                            }
                          },

                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 220),

                            margin: const EdgeInsets.only(right: 8),

                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                            ),

                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                colors: AppColors.ptaGrad,
                              )
                                  : null,

                              color: isSelected
                                  ? null
                                  : (isDark
                                  ? AppColors.darkElevated
                                  : AppColors.lightElevated),

                              borderRadius:
                              BorderRadius.circular(15),

                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppColors.ptaPurple
                                    .withOpacity(0.12),
                              ),
                            ),

                            child: Center(
                              child: Text(
                                cat,
                                style: GoogleFonts.sora(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                      ? AppColors.textGrey1
                                      : AppColors.textGrey2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAllModelsSheet(
      BuildContext context, PtaTaxController ctrl, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: ctrl,
        child: _AllModelsSheet(isDark: isDark),
      ),
    );
  }
}

// ── Horizontal Model Card ─────────────────────────────────────────────────
class _HorizontalModelCard extends StatefulWidget {
  final PtaDeviceEntry device;
  final bool isSelected, isDark;
  final VoidCallback onTap;
  const _HorizontalModelCard(
      {required this.device,
        required this.isSelected,
        required this.isDark,
        required this.onTap});

  @override
  State<_HorizontalModelCard> createState() => _HorizontalModelCardState();
}

class _HorizontalModelCardState extends State<_HorizontalModelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  static const _catIcons = {
    'Smartphone': Icons.phone_android_rounded,
    'Tablet': Icons.tablet_rounded,
    'Laptop': Icons.laptop_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _catIcons[widget.device.category] ?? Icons.devices_rounded;

    return GestureDetector(
      onTapDown: (_) => _anim.forward(),
      onTapUp: (_) {
        _anim.reverse();
        widget.onTap();
      },
      onTapCancel: () => _anim.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                colors: AppColors.ptaGrad,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)
                : null,
            color: widget.isSelected
                ? null
                : (widget.isDark
                ? AppColors.darkElevated
                : AppColors.lightElevated),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: widget.isSelected
                    ? Colors.transparent
                    : (widget.isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder)),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                  color: AppColors.ptaPurple.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5))
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Colors.white.withOpacity(0.22)
                        : AppColors.ptaPurple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(9)),
                child: Icon(icon,
                    size: 16,
                    color: widget.isSelected
                        ? Colors.white
                        : AppColors.ptaPurple),
              ),

              // Model name
              Text(
                widget.device.model,
                style: GoogleFonts.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.isSelected
                        ? Colors.white
                        : (widget.isDark
                        ? AppColors.textWhite
                        : AppColors.textDark),
                    height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // USD badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Colors.white.withOpacity(0.20)
                        : AppColors.ptaPurple.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  '\$${widget.device.customsValueUsd.toInt()}',
                  style: GoogleFonts.sora(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: widget.isSelected
                          ? Colors.white
                          : AppColors.ptaPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── All Models Bottom Sheet ───────────────────────────────────────────────
class _AllModelsSheet extends StatefulWidget {
  final bool isDark;
  const _AllModelsSheet({required this.isDark});

  @override
  State<_AllModelsSheet> createState() => _AllModelsSheetState();
}

class _AllModelsSheetState extends State<_AllModelsSheet> {
  late TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<PtaTaxController>();
    final models = ctrl.filteredModels;
    final cats = models.map((m) => m.category).toSet().toList();
    final isDark = widget.isDark;

    // Build a flat list: [categoryHeader, device, device, ..., categoryHeader, ...]
    final List<dynamic> items = [];
    for (final cat in cats) {
      items.add(cat); // String = category header
      items.addAll(models.where((m) => m.category == cat));
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0E0E22) : Colors.white,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
                top: BorderSide(
                    color: isDark
                        ? AppColors.ptaPurple.withOpacity(0.20)
                        : AppColors.lightBorder,
                    width: 1.5)),
          ),
          child: Column(children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),

            // Sheet header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      gradient:
                      const LinearGradient(colors: AppColors.ptaGrad),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.phone_android_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All ${ctrl.selectedBrand} Devices',
                            style: GoogleFonts.sora(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textWhite
                                    : AppColors.textDark)),
                        Text(
                            '${ctrl.modelsForSelectedBrand.length} devices — tap to select',
                            style: GoogleFonts.sora(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textGrey1
                                    : AppColors.textGrey2)),
                      ]),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkElevated
                            : AppColors.lightElevated,
                        shape: BoxShape.circle),
                    child: Icon(Icons.close_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.textGrey1
                            : AppColors.textGrey2),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 14),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchCtrl,
                onChanged: ctrl.setSearchQuery,
                style: GoogleFonts.sora(
                    fontSize: 13,
                    color:
                    isDark ? AppColors.textWhite : AppColors.textDark),
                decoration: InputDecoration(
                  hintText: 'Search model...',
                  hintStyle: GoogleFonts.sora(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textGrey2
                          : AppColors.textGrey1),
                  prefixIcon: Icon(Icons.search_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.textGrey1
                          : AppColors.textGrey2),
                  suffixIcon: ctrl.searchQuery.isNotEmpty
                      ? GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        ctrl.setSearchQuery('');
                      },
                      child: Icon(Icons.clear_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textGrey1
                              : AppColors.textGrey2))
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkElevated
                      : AppColors.lightElevated,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Divider(
                height: 1,
                color:
                isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Device list
            Expanded(
              child: items.isEmpty
                  ? Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 40,
                            color: isDark
                                ? AppColors.textGrey2
                                : AppColors.textGrey1),
                        const SizedBox(height: 10),
                        Text('No devices found',
                            style: GoogleFonts.sora(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.textGrey1
                                    : AppColors.textGrey2)),
                      ]))
                  : ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  if (item is String) {
                    // Category header
                    return _SheetCategoryHeader(
                        category: item, isDark: isDark);
                  }
                  final device = item as PtaDeviceEntry;
                  return _SheetModelTile(
                    device: device,
                    isSelected:
                    ctrl.selectedDevice?.model == device.model,
                    isDark: isDark,
                    onTap: () {
                      ctrl.selectDevice(device);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ]),
        );
      },
    );
  }
}

// ── Sheet Category Header ─────────────────────────────────────────────────
class _SheetCategoryHeader extends StatelessWidget {
  final String category;
  final bool isDark;
  const _SheetCategoryHeader({required this.category, required this.isDark});

  static const _icons = {
    'Smartphone': Icons.phone_android_rounded,
    'Tablet': Icons.tablet_android_rounded,
    'Laptop': Icons.laptop_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: AppColors.ptaPurple.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(_icons[category] ?? Icons.devices_rounded,
              size: 13, color: AppColors.ptaPurple),
          const SizedBox(width: 6),
          Text(category,
              style: GoogleFonts.sora(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ptaPurple)),
        ]),
      ),
    );
  }
}

// ── Sheet Model Tile (vertical list inside bottom sheet) ──────────────────
class _SheetModelTile extends StatelessWidget {
  final PtaDeviceEntry device;
  final bool isSelected, isDark;
  final VoidCallback onTap;
  const _SheetModelTile(
      {required this.device,
        required this.isSelected,
        required this.isDark,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
              colors: AppColors.ptaGrad,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
              : null,
          color: isSelected
              ? null
              : (isDark ? AppColors.darkElevated : AppColors.lightElevated),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
          boxShadow: isSelected
              ? [
            BoxShadow(
                color: AppColors.ptaPurple.withOpacity(0.30),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ]
              : [],
        ),
        child: Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.20)
                    : AppColors.ptaPurple.withOpacity(0.10),
                borderRadius: BorderRadius.circular(9)),
            child: Icon(
                device.category == 'Laptop'
                    ? Icons.laptop_rounded
                    : device.category == 'Tablet'
                    ? Icons.tablet_rounded
                    : Icons.phone_android_rounded,
                size: 17,
                color: isSelected ? Colors.white : AppColors.ptaPurple),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.model,
                        style: GoogleFonts.sora(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                ? AppColors.textWhite
                                : AppColors.textDark))),
                    Text('FBR value: \$${device.customsValueUsd.toInt()}',
                        style: GoogleFonts.sora(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white.withOpacity(0.70)
                                : (isDark
                                ? AppColors.textGrey1
                                : AppColors.textGrey2))),
                  ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.18)
                    : AppColors.ptaPurple.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8)),
            child: Text('\$${device.customsValueUsd.toInt()}',
                style: GoogleFonts.sora(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color:
                    isSelected ? Colors.white : AppColors.ptaPurple)),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check_circle_rounded,
                size: 18, color: Colors.white),
          ],
        ]),
      ),
    );
  }
}

// ── PtaModelTile (kept for external compatibility) ────────────────────────
class PtaModelTile extends StatelessWidget {
  final PtaDeviceEntry device;
  final bool isSelected, isDark;
  final VoidCallback onTap;
  const PtaModelTile(
      {super.key,
        required this.device,
        required this.isSelected,
        required this.isDark,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _SheetModelTile(
        device: device, isSelected: isSelected, isDark: isDark, onTap: onTap);
  }
}