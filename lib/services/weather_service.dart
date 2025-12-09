import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Open-Meteo API - FREE, no API key required!
  static const String _baseUrl = 'https://api.open-meteo.com/v1';

  /// Get current weather for coordinates
  Future<Map<String, dynamic>?> getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,'
        'precipitation,weather_code,wind_speed_10m,cloud_cover'
        '&timezone=auto',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        
        return {
          'temperature': current['temperature_2m'].round(),
          'feels_like': current['apparent_temperature'].round(),
          'humidity': current['relative_humidity_2m'],
          'weather_code': current['weather_code'],
          'weather': _getWeatherDescription(current['weather_code']),
          'description': _getWeatherDescription(current['weather_code']),
          'wind_speed': current['wind_speed_10m'],
          'clouds': current['cloud_cover'],
          'precipitation': current['precipitation'] ?? 0.0,
        };
      } else {
        print('Weather API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return null;
    }
  }

  /// Get 7-day forecast
  Future<List<Map<String, dynamic>>> get7DayForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?latitude=$latitude&longitude=$longitude'
        '&daily=weather_code,temperature_2m_max,temperature_2m_min,'
        'precipitation_sum,precipitation_probability_max,wind_speed_10m_max'
        '&timezone=auto',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final daily = data['daily'];
        
        List<Map<String, dynamic>> forecast = [];
        
        for (int i = 0; i < 7 && i < daily['time'].length; i++) {
          forecast.add({
            'date': DateTime.parse(daily['time'][i]),
            'temp_min': daily['temperature_2m_min'][i].round(),
            'temp_max': daily['temperature_2m_max'][i].round(),
            'weather_code': daily['weather_code'][i],
            'weather': _getWeatherDescription(daily['weather_code'][i]),
            'description': _getWeatherDescription(daily['weather_code'][i]),
            'precipitation': daily['precipitation_sum'][i] ?? 0.0,
            'rain_probability': daily['precipitation_probability_max'][i] ?? 0,
            'wind_speed': daily['wind_speed_10m_max'][i],
          });
        }
        
        return forecast;
      } else {
        print('Forecast API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching forecast: $e');
      return [];
    }
  }

  /// Convert WMO weather code to description
  String _getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 66:
      case 67:
        return 'Freezing rain';
      case 71:
      case 73:
      case 75:
        return 'Snowfall';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 85:
      case 86:
        return 'Snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Unknown';
    }
  }

  /// Get weather icon based on code
  String getWeatherIcon(int code) {
    if (code == 0) return '☀️';
    if (code >= 1 && code <= 3) return '⛅';
    if (code >= 45 && code <= 48) return '🌫️';
    if (code >= 51 && code <= 67) return '🌧️';
    if (code >= 71 && code <= 86) return '🌨️';
    if (code >= 95) return '⛈️';
    return '🌤️';
  }

  /// Get farming alert based on weather
  String? getFarmingAlert(Map<String, dynamic> weather, List<Map<String, dynamic>> forecast) {
    // Heavy rain expected
    bool heavyRainComing = forecast.any((day) => 
      day['precipitation'] > 20 || day['rain_probability'] > 70
    );
    
    if (heavyRainComing) {
      return 'Heavy rain expected in next 7 days. Plan harvesting accordingly.';
    }

    // High temperature
    if (weather['temperature'] > 40) {
      return 'Extreme heat alert! Ensure adequate irrigation.';
    }

    // Low temperature
    if (weather['temperature'] < 10) {
      return 'Cold weather alert! Protect sensitive crops.';
    }

    return null;
  }

  /// Check if service is available (always true for Open-Meteo)
  bool isConfigured() {
    return true; // No API key needed!
  }

  /// Get demo weather data (for offline testing)
  Map<String, dynamic> getDemoWeather() {
    return {
      'temperature': 28,
      'feels_like': 30,
      'humidity': 65,
      'weather_code': 0,
      'weather': 'Clear sky',
      'description': 'Clear sky',
      'wind_speed': 3.5,
      'clouds': 10,
      'precipitation': 0.0,
    };
  }

  /// Get demo forecast data
  List<Map<String, dynamic>> getDemoForecast() {
    return List.generate(7, (index) {
      return {
        'date': DateTime.now().add(Duration(days: index)),
        'temp_min': 22 + (index % 3),
        'temp_max': 32 + (index % 4),
        'weather_code': index % 2 == 0 ? 0 : 2,
        'weather': index % 2 == 0 ? 'Clear sky' : 'Partly cloudy',
        'description': index % 2 == 0 ? 'Clear sky' : 'Partly cloudy',
        'precipitation': index * 2.0,
        'rain_probability': index * 10,
        'wind_speed': 3.5 + index,
      };
    });
  }
}
