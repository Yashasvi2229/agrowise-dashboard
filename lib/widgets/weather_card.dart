import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';

class WeatherCard extends StatefulWidget {
  final VoidCallback onTap;

  const WeatherCard({super.key, required this.onTap});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  
  Map<String, dynamic>? _weather;
  String? _location;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      // Get location
      final locationData = await _locationService.getLocationWithAddress();
      if (locationData == null) {
        setState(() {
          _loading = false;
          _location = 'Location unavailable';
        });
        return;
      }

      // Get weather
      final weather = await _weatherService.getCurrentWeather(
        locationData['latitude'],
        locationData['longitude'],
      );

      setState(() {
        _weather = weather;
        _location = '${locationData['locality']}, ${locationData['state']}';
        _loading = false;
      });
    } catch (e) {
      print('Error loading weather: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildLoadingCard();
    }

    if (_weather == null) {
      return _buildErrorCard();
    }

    return _buildWeatherCard();
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 16),
              Text(
                'Loading weather...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF78909C), Color(0xFF546E7A)],
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.cloud_off, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                _location ?? 'Weather unavailable',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    final int temp = _weather!['temperature'];
    final String icon = _weatherService.getWeatherIcon(_weather!['weather_code']);
    final String description = _weather!['weather'];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Weather icon
              Text(
                icon,
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(width: 20),
              // Weather info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$temp°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _location ?? '',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
