import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'package:intl/intl.dart';

class WeatherDetailScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const WeatherDetailScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  final WeatherService _weatherService = WeatherService();
  
  Map<String, dynamic>? _weather;
  List<Map<String, dynamic>> _forecast = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      // Use passed location instead of fetching again
      final weather = await _weatherService.getCurrentWeather(
        widget.latitude,
        widget.longitude,
      );

      final forecast = await _weatherService.get7DayForecast(
        widget.latitude,
        widget.longitude,
      );

      setState(() {
        _weather = weather;
        _forecast = forecast;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _weather == null
              ? _buildErrorView()
              : _buildWeatherView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Unable to load weather data'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadWeatherData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current weather header
          _buildCurrentWeatherHeader(),
          
          // Weather details
          _buildWeatherDetails(),
          
          const SizedBox(height: 20),
          
          // 7-day forecast
          _build7DayForecast(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherHeader() {
    final int temp = _weather!['temperature'];
    final String icon = _weatherService.getWeatherIcon(_weather!['weather_code']);
    final String description = _weather!['weather'];

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.locationName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            icon,
            style: const TextStyle(fontSize: 100),
          ),
          const SizedBox(height: 10),
          Text(
            '$temp°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildDetailRow(
                Icons.thermostat,
                'Feels Like',
                '${_weather!['feels_like']}°C',
              ),
              const Divider(),
              _buildDetailRow(
                Icons.water_drop,
                'Humidity',
                '${_weather!['humidity']}%',
              ),
              const Divider(),
              _buildDetailRow(
                Icons.air,
                'Wind Speed',
                '${_weather!['wind_speed']} km/h',
              ),
              const Divider(),
              _buildDetailRow(
                Icons.cloud,
                'Cloud Cover',
                '${_weather!['clouds']}%',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build7DayForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '7-Day Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _forecast.length,
          itemBuilder: (context, index) {
            final day = _forecast[index];
            return _buildForecastCard(day);
          },
        ),
      ],
    );
  }

  Widget _buildForecastCard(Map<String, dynamic> day) {
    final DateTime date = day['date'];
    final String dayName = DateFormat('EEEE').format(date);
    final String dateStr = DateFormat('MMM d').format(date);
    final String icon = _weatherService.getWeatherIcon(day['weather_code']);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              icon,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${day['temp_max']}° / ${day['temp_min']}°',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (day['rain_probability'] > 0)
                    Text(
                      '💧${day['rain_probability'].round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
