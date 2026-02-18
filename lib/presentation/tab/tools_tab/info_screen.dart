import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Future<void> _launchUrl(String url) async {
    final encodedUrl = Uri.encodeFull(url);
    final uri = Uri.parse(encodedUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Builder(
            builder: (context) {
              bool isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.black : Colors.white,
                    size: 21,
                  ),
                  //onPressed: () => Navigator.pop(context),
                  onPressed: () => Navigator.pop(context, true),
                ),
              );
            },
          ),
        ),
        title: const Text(
          'Medical Disclaimer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ─── MAIN TITLE ─────────────────────────
            const Text(
              'Medical Disclaimer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            /// ─── DISCLAIMER TEXT ────────────────────
            const Text(
              'This app provides general health and fitness information '
              'for educational and informational purposes only.\n\n'
              'The content, calculations, and recommendations available in '
              'this app are not intended to be a substitute for professional '
              'medical advice, diagnosis, or treatment.\n\n'
              'Always seek the advice of a qualified healthcare professional '
              'before starting any fitness program, changing your diet, or '
              'making health-related decisions. Never disregard professional '
              'medical advice or delay seeking it because of information '
              'provided by this app.\n\n'
              'The use of this app is at your own risk.',
              style: TextStyle(
                fontSize: 12,
                height: 1.55,
                //color: Colors.white
              ),
            ),

            const SizedBox(height: 24),

            /// ─── SOURCES TITLE ──────────────────────
            const Text(
              'Sources & References',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            /// ─── SOURCE LINKS ───────────────────────
            _buildSourceItem(
              title: 'World Health Organization (WHO) – BMI',
              url:
                  'https://www.who.int/data/gho/data/themes/theme-details/GHO/body-mass-index-(bmi)',
            ),
            _buildSourceItem(
              title: 'NIH – Calorie Calculation (TDEE)',
              url: 'https://pubmed.ncbi.nlm.nih.gov/2305711/',
            ),
            _buildSourceItem(
              title: 'American Heart Association – Target Heart Rate Zones',
              url:
                  'https://www.heart.org/en/healthy-living/fitness/fitness-basics/target-heart-rates',
            ),
          ],
        ),
      ),
    );
  }

  /// ─── SOURCE ROW WIDGET ─────────────────────────
  Widget _buildSourceItem({required String title, required String url}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '• ',
              style: TextStyle(
                fontSize: 14,
                //color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.4,
                  color: Color(0xFF00B2FF),
                  //decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
