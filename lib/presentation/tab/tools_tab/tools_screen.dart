import 'package:fitness_workout_app/presentation/tab/tools_tab/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bmi_calculators.dart';
import 'calories_calculator.dart';
import 'heart_rate_zone_screen.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // final tools = [
    //   {
    //     'title': 'Calorie Calculators',
    //     'subtitle':
    //         'Calculate your daily caloric needs (TDEE) based on your activity level and goals',
    //     'icon': 'assets/icons/heart.svg',
    //     'color': const Color(0xFF00AAFF),
    //     'screen': const CalorieFormulaScreen(),
    //   },
    //   {
    //     'title': 'BMI Calculators',
    //     'subtitle':
    //         'Calculate your Body Mass Index and understand your weight category',
    //     'icon': 'assets/icons/heart.svg',
    //     'color': const Color(0xFFD167FF),
    //     'screen': const BmiCalculatorsScreen(),
    //   },
    //   {
    //     'title': 'Heart Rate Zone',
    //     'subtitle':
    //         'Discover your optimal training zones for fat burning and performance',
    //     'icon': 'assets/icons/heart.svg',
    //     'color': const Color(0xFFFF676C),
    //     'screen': const HeartRateZoneScreen(),
    //   },
    //   // {
    //   //   'title': 'Macro Calculators',
    //   //   'subtitle':
    //   //       'Plan your protein, carb, and fat intake to reach your fitness goals',
    //   //   'icon': 'assets/icons/heart.svg',
    //   //   'color': const Color(0xFFFF9500),
    //   // },
    // ];

    final tools = [
      {
        'title': 'Calorie Calculators',
        'subtitle':
            'Calculate your daily caloric needs (TDEE) based on your activity level and goals',
        'sourceTitle': 'Mifflin-St Jeor Equation',
        'sourceUrl': 'https://pubmed.ncbi.nlm.nih.gov/2305711/',
        'icon': 'assets/icons/heart.svg',
        'color': const Color(0xFF00AAFF),
        'screen': const CalorieFormulaScreen(),
      },
      {
        'title': 'BMI Calculators',
        'subtitle':
            'Calculate your Body Mass Index and understand your weight category',
        'sourceTitle': 'World Health Organization (WHO) BMI Classification',
        'sourceUrl':
            'https://www.who.int/data/gho/data/themes/theme-details/GHO/body-mass-index-(bmi)',
        'icon': 'assets/icons/heart.svg',
        'color': const Color(0xFFD167FF),
        'screen': const BmiCalculatorsScreen(),
      },
      {
        'title': 'Heart Rate Zone',
        'subtitle':
            'Discover your optimal training zones for fat burning and performance',
        'sourceTitle': 'American Heart Association – Target Heart Rates',
        'sourceUrl':
            'https://www.heart.org/en/healthy-living/fitness/fitness-basics/target-heart-rates',
        'icon': 'assets/icons/heart.svg',
        'color': const Color(0xFFFF676C),
        'screen': const HeartRateZoneScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 12,
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Tools',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoScreen()),
                );
              },
              child: const Center(child: Icon(Icons.info, size: 26)),
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...List.generate(tools.length, (index) {
            final tool = tools[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildToolCard(
                context: context,
                title: tool['title'] as String,
                subtitle: tool['subtitle'] as String,
                sourceTitle: tool['sourceTitle'] as String,
                sourceUrl: tool['sourceUrl'] as String,
                iconPath: tool['icon'] as String,
                color: tool['color'] as Color,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => tool['screen'] as Widget,
                    ),
                  );
                },
              ),
            );
          }),

          _buildInfoContainer(),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String sourceTitle,
    required String sourceUrl,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.colorScheme.surface;
    final borderColor = theme.colorScheme.outline;
    final textColor = theme.colorScheme.onSurface;
    final subTextColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final linkColor = isDark ? const Color(0xFF00B2FF) : Colors.blue;
    final buttonBg = theme.colorScheme.primary;
    final buttonText = theme.colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Title + Icon ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _launchUrl(sourceUrl),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width: 14,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.onPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ─── Subtitle ────────────────────────────────
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, height: 1.4, color: textColor),
          ),

          const SizedBox(height: 14),

          // ─── Source Title ────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Source: ',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: sourceTitle,
                  style: TextStyle(color: textColor, fontSize: 10),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ─── URL + Button ────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _launchUrl(sourceUrl),
                  child: Text(
                    sourceUrl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: linkColor,
                      fontSize: 9,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: buttonBg,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Try now',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: buttonText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 15, color: buttonText),
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

  Widget _buildInfoContainer() {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff60ADEE), width: 1),
      ),
      child: Text(
        'This app provides general health and fitness information for educational purposes only.\n'
        'The information, calculations, and recommendations are not intended as medical advice.\n'
        'Always consult a qualified healthcare professional.',
        style: TextStyle(fontSize: 10, height: 1.6, color: textColor),
      ),
    );
  }
}
