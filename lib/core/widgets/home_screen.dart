import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final sf = (size.height / 844).clamp(0.80, 1.15);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A1F) : const Color(0xFFF0F0FF),
      body: Stack(
        children: [
          _Background(isDark: isDark, size: size),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroSection(
                isDark: isDark,
                topPad: topPad,
                onToggle: onThemeToggle,
                size: size,
                sf: sf,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 18 * sf),
                      _StatsBanner(isDark: isDark, sf: sf)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                      SizedBox(height: 18 * sf),
                      Row(
                        children: [
                          Text(
                            'Tax Calculators',
                            style: GoogleFonts.sora(
                              fontSize: 16 * sf,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0D0D1A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10 * sf, vertical: 5 * sf),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.accentGreen.withOpacity(0.35), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5, height: 5,
                                  decoration: const BoxDecoration(color: AppColors.accentGreen, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 5),
                                Text('FBR 2025-26',
                                    style: GoogleFonts.sora(fontSize: 10 * sf, fontWeight: FontWeight.w700, color: AppColors.accentGreen)),
                              ],
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 350.ms, delay: 280.ms),
                      SizedBox(height: 12 * sf),
                      _FeatureCardLarge(
                        title: 'Salary Tax',
                        subtitle: 'Income tax on monthly gross salary',
                        tag: 'Most Used',
                        icon: Icons.account_balance_wallet_rounded,
                        gradient: const [Color(0xFF6C8EFF), Color(0xFF4A6CF7)],
                        isDark: isDark,
                        delay: 340,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.salaryTax),
                        extraInfo: '0% up to Rs.600K',
                        sf: sf,
                      ),
                      SizedBox(height: 11 * sf),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _FeatureCardSmall(
                                title: 'Withholding Tax',
                                tag: 'Sec 153',
                                icon: Icons.percent_rounded,
                                gradient: const [Color(0xFFFF6B35), Color(0xFFE5501A)],
                                isDark: isDark,
                                delay: 400,
                                onTap: () => Navigator.pushNamed(context, AppRoutes.withholdingTax),
                                sf: sf,
                              ),
                            ),
                            SizedBox(width: 11 * sf),
                            Expanded(
                              child: _FeatureCardSmall(
                                title: 'PTA Device Tax',
                                tag: 'DIRBS',
                                icon: Icons.phone_android_rounded,
                                gradient: const [Color(0xFFB06EFF), Color(0xFF8B3FE8)],
                                isDark: isDark,
                                delay: 460,
                                onTap: () => Navigator.pushNamed(context, AppRoutes.ptaTax),
                                sf: sf,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 11 * sf),
                      _FeatureCardLarge(
                        title: 'Remittance Tax',
                        subtitle: 'Foreign transfers — Sec 236AA / 236Y',
                        tag: 'Overseas',
                        icon: Icons.public_rounded,
                        gradient: const [Color(0xFF00D4B8), Color(0xFF00A896)],
                        isDark: isDark,
                        delay: 520,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.remittanceTax),
                        extraInfo: 'Sec 236AA / 236Y',
                        sf: sf,
                      ),
                      SizedBox(height: 12 * sf),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 11,
                                color: isDark ? AppColors.textGrey2 : AppColors.textGrey1),
                            const SizedBox(width: 4),
                            Text(
                              'FBR Finance Act 2025. Verify with your tax consultant.',
                              style: GoogleFonts.sora(
                                fontSize: 10,
                                color: isDark ? AppColors.textGrey2 : AppColors.textGrey1,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                      SizedBox(height: (bottomPad + 8)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Background ─────────────────────────────────────────────────────────────
class _Background extends StatelessWidget {
  final bool isDark;
  final Size size;
  const _Background({required this.isDark, required this.size});

  @override
  Widget build(BuildContext context) {
    if (!isDark) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEBEDFF), Color(0xFFF6F0FF), Color(0xFFE8F0FF)],
          ),
        ),
      );
    }
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF07071A), Color(0xFF0B0B28), Color(0xFF070718)],
            ),
          ),
        ),
        Positioned(
          top: -size.height * 0.05, right: -size.width * 0.15,
          child: Container(
            width: size.width * 0.80, height: size.width * 0.80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [const Color(0xFF7C5CFC).withOpacity(0.28), Colors.transparent]),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.38, left: -size.width * 0.20,
          child: Container(
            width: size.width * 0.55, height: size.width * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [const Color(0xFF4A6CF7).withOpacity(0.16), Colors.transparent]),
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.08, right: -size.width * 0.10,
          child: Container(
            width: size.width * 0.45, height: size.width * 0.45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [const Color(0xFF00D4B8).withOpacity(0.12), Colors.transparent]),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Hero Section ───────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final bool isDark;
  final double topPad;
  final VoidCallback onToggle;
  final Size size;
  final double sf;

  const _HeroSection({
    required this.isDark,
    required this.topPad,
    required this.onToggle,
    required this.size,
    required this.sf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A0E3A), const Color(0xFF0F0A28), const Color(0xFF0A0A1F)]
              : [const Color(0xFF5A3DE8), const Color(0xFF7C5CFC), const Color(0xFF9B7FFF)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CFC).withOpacity(0.35),
            blurRadius: 36,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: topPad + 6, right: -18,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.07), width: 28),
              ),
            ),
          ),
          Positioned(
            top: topPad + 55, right: 38,
            child: Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.06), width: 14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 24 * sf),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🇵🇰', style: TextStyle(fontSize: 17)),
                          const SizedBox(width: 8),
                          Text('PakTax',
                              style: GoogleFonts.sora(
                                  fontSize: 15, fontWeight: FontWeight.w700,
                                  color: Colors.white, letterSpacing: -0.3)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onToggle,
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
                        ),
                        child: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          size: 18, color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 350.ms),

                SizedBox(height: 20 * sf),

                Text('Pakistan Tax Hub',
                    style: GoogleFonts.sora(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.60), letterSpacing: 0.4)),
                SizedBox(height: 6 * sf),
                Text('Smart Tax Calculator',
                    style: GoogleFonts.sora(
                        fontSize: 30 * sf, fontWeight: FontWeight.w800,
                        color: Colors.white, height: 1.1, letterSpacing: -1.3)),
                SizedBox(height: 9 * sf),
                Text('Accurate FBR calculations for Tax\nYear 2025-26.',
                    style: GoogleFonts.sora(
                        fontSize: 12, height: 1.55,
                        color: Colors.white.withOpacity(0.68))),
              ],
            ),
          ).animate()
              .fadeIn(duration: 400.ms, delay: 60.ms)
              .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

// ── Stats Banner ───────────────────────────────────────────────────────────
class _StatsBanner extends StatelessWidget {
  final bool isDark;
  final double sf;
  const _StatsBanner({required this.isDark, required this.sf});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16 * sf, horizontal: 16),
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(colors: [
              const Color(0xFF1A1A3A).withOpacity(0.85),
              const Color(0xFF12122A).withOpacity(0.90),
            ])
                : LinearGradient(colors: [
              Colors.white.withOpacity(0.92),
              Colors.white.withOpacity(0.82),
            ]),
            borderRadius: BorderRadius.circular(20),
            // ── FIXED: removed prominent white border, use subtle shadow only ──
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.28) : Colors.black.withOpacity(0.06),
                blurRadius: 22, offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              _StatItem(value: '4', label: 'Calculators', color: AppColors.salaryBlue, icon: Icons.calculate_rounded, isDark: isDark, sf: sf),
              _StatDivider(isDark: isDark),
              _StatItem(value: '0%', label: 'Up to 600K', color: AppColors.accentGreen, icon: Icons.shield_rounded, isDark: isDark, sf: sf),
              _StatDivider(isDark: isDark),
              _StatItem(value: '35%', label: 'Max Rate', color: AppColors.whtOrange, icon: Icons.trending_up_rounded, isDark: isDark, sf: sf),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final bool isDark;
  const _StatDivider({required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
    width: 1, height: 36,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.07),
  );
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color color;
  final IconData icon;
  final bool isDark;
  final double sf;
  const _StatItem({required this.value, required this.label, required this.color, required this.icon, required this.isDark, required this.sf});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(value,
                style: GoogleFonts.sora(
                    fontSize: 20 * sf, fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0D0D1A),
                    letterSpacing: -0.8)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.sora(
                fontSize: 10, color: isDark ? AppColors.textGrey1 : AppColors.textGrey2,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center),
      ],
    ),
  );
}

// ── Large Feature Card ─────────────────────────────────────────────────────
class _FeatureCardLarge extends StatefulWidget {
  final String title, subtitle, tag, extraInfo;
  final IconData icon;
  final List<Color> gradient;
  final bool isDark;
  final int delay;
  final VoidCallback onTap;
  final double sf;

  const _FeatureCardLarge({
    required this.title, required this.subtitle, required this.tag,
    required this.icon, required this.gradient, required this.isDark,
    required this.delay, required this.onTap, required this.extraInfo, required this.sf,
  });

  @override
  State<_FeatureCardLarge> createState() => _FeatureCardLargeState();
}

class _FeatureCardLargeState extends State<_FeatureCardLarge> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 116 * widget.sf,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(22),
            // ── FIXED: removed border, kept only shadow ──
            boxShadow: [BoxShadow(color: widget.gradient.first.withOpacity(0.38), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Stack(
            children: [
              // Decorative circle — top right
              Positioned(right: -18, top: -18,
                  child: Container(width: 110, height: 110,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
              // Decorative circle — bottom right
              Positioned(right: 26, bottom: -22,
                  child: Container(width: 72, height: 72,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
              // ── REMOVED: top highlight strip that caused the visible edge line ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(15),
                        // ── FIXED: removed icon container border ──
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.20), borderRadius: BorderRadius.circular(6)),
                            child: Text(widget.tag, style: GoogleFonts.sora(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                          const SizedBox(height: 5),
                          Text(widget.title,
                              style: GoogleFonts.sora(fontSize: 16 * widget.sf, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.4)),
                          const SizedBox(height: 3),
                          Text(widget.subtitle,
                              style: GoogleFonts.sora(fontSize: 11, color: Colors.white.withOpacity(0.75), height: 1.3)),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(11),
                            // ── FIXED: removed arrow button border ──
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 17),
                        ),
                        const SizedBox(height: 7),
                        Text(widget.extraInfo,
                            style: GoogleFonts.sora(fontSize: 9, color: Colors.white.withOpacity(0.70), fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 380.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}

// ── Small Feature Card ─────────────────────────────────────────────────────
class _FeatureCardSmall extends StatefulWidget {
  final String title, tag;
  final IconData icon;
  final List<Color> gradient;
  final bool isDark;
  final int delay;
  final VoidCallback onTap;
  final double sf;

  const _FeatureCardSmall({
    required this.title, required this.tag, required this.icon,
    required this.gradient, required this.isDark, required this.delay,
    required this.onTap, required this.sf,
  });

  @override
  State<_FeatureCardSmall> createState() => _FeatureCardSmallState();
}

class _FeatureCardSmallState extends State<_FeatureCardSmall> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(22),
            // ── FIXED: removed border, kept only shadow ──
            boxShadow: [BoxShadow(color: widget.gradient.first.withOpacity(0.38), blurRadius: 18, offset: const Offset(0, 7))],
          ),
          child: Stack(
            children: [
              // Decorative circle — top right
              Positioned(right: -12, top: -12,
                  child: Container(width: 80, height: 80,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
              // ── REMOVED: top highlight strip that caused the visible edge line ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(13),
                            // ── FIXED: removed icon container border ──
                          ),
                          child: Icon(widget.icon, color: Colors.white, size: 20),
                        ),
                        Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 15),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
                      child: Text(widget.tag, style: GoogleFonts.sora(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.title,
                        style: GoogleFonts.sora(
                            fontSize: 14 * widget.sf, fontWeight: FontWeight.w800,
                            color: Colors.white, height: 1.2, letterSpacing: -0.3)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 380.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}