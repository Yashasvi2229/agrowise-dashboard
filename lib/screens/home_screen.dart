import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_localizations.dart';
import '../utils/api_config.dart';
import '../main.dart';
import 'crop_analysis_screen.dart';
import 'chat_screen.dart';
import 'history_screen.dart';
import 'weather_detail_screen.dart';
import '../widgets/weather_card.dart';
import '../widgets/market_prices_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('language_code') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('home_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String languageCode) {
              _changeLanguage(languageCode);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    if (_currentLanguage == 'en') const Icon(Icons.check, color: Color(0xFF2E7D32)),
                    if (_currentLanguage == 'en') const SizedBox(width: 8),
                    Text(localizations.translate('english'), style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'hi',
                child: Row(
                  children: [
                    if (_currentLanguage == 'hi') const Icon(Icons.check, color: Color(0xFF2E7D32)),
                    if (_currentLanguage == 'hi') const SizedBox(width: 8),
                    Text(localizations.translate('hindi'), style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ta',
                child: Row(
                  children: [
                    if (_currentLanguage == 'ta') const Icon(Icons.check, color: Color(0xFF2E7D32)),
                    if (_currentLanguage == 'ta') const SizedBox(width: 8),
                    Text(localizations.translate('tamil'), style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'te',
                child: Row(
                  children: [
                    if (_currentLanguage == 'te') const Icon(Icons.check, color: Color(0xFF2E7D32)),
                    if (_currentLanguage == 'te') const SizedBox(width: 8),
                    Text(localizations.translate('telugu'), style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'pa',
                child: Row(
                  children: [
                    if (_currentLanguage == 'pa') const Icon(Icons.check, color: Color(0xFF2E7D32)),
                    if (_currentLanguage == 'pa') const SizedBox(width: 8),
                    Text(localizations.translate('punjabi'), style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E7D32).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Weather Card (replaces logo)
                const WeatherCard(),
                const SizedBox(height: 30),
                // Analyze Crop Photo Card  
                _buildActionCard(
                  context,
                  icon: Icons.camera_alt,
                  title: localizations.translate('analyze_crop'),
                  subtitle: 'Take or upload crop photos for AI analysis',
                  color: const Color(0xFF2E7D32),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CropAnalysisScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Market Prices Card
                const MarketPricesCard(),
                const SizedBox(height: 20),
                // Future features placeholder
                Expanded(
                  child: Center(
                    child: Text(
                      'More features coming soon!',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Floating Action Buttons
      floatingActionButton: Stack(
        children: [
          // Chat FAB - Bottom Right
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'chat_fab',
              backgroundColor: const Color(0xFF5D4037),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              child: const Icon(Icons.chat_bubble, color: Colors.white),
            ),
          ),
          // Call FAB - Bottom Left
          Positioned(
            bottom: 16,
            left: 36,
            child: FloatingActionButton(
              heroTag: 'call_fab',
              backgroundColor: const Color(0xFF1976D2),
              onPressed: () => _makePhoneCall(context),
              child: const Icon(Icons.phone, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF2E7D32)),
            ],
          ),
        ),
      ),
    );
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });
    AgroWiseApp.of(context)?.setLocale(Locale(languageCode));
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: ApiConfig.helplineNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch phone dialer: ${ApiConfig.helplineNumber}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
