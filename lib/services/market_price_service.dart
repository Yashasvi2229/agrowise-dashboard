import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketPriceService {
  // Backend API URL (Render)
  static const String _baseUrl = 'https://crop-disease-api-oawi.onrender.com/api';

  /// Get all market prices
  Future<List<Map<String, dynamic>>> getMarketPrices({
    String? state,
    String? commodity,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/market-prices').replace(
        queryParameters: {
          if (state != null) 'state': state,
          if (commodity != null) 'commodity': commodity,
          'limit': '200',
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['crops']);
        }
      }

      print('Market prices API error: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error fetching market prices: $e');
      return [];
    }
  }

  /// Get trending crops
  Future<List<Map<String, dynamic>>> getTrendingCrops({
    String? state,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/market-prices/trending').replace(
        queryParameters: {
          if (state != null) 'state': state,
          'limit': limit.toString(),
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['crops']);
        }
      }

      print('Trending crops API error: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error fetching trending crops: $e');
      return [];
    }
  }

  /// Get demo data (fallback if API fails)
  List<Map<String, dynamic>> getDemoData() {
    return [
      {'name': 'Wheat', 'price': 2150.0, 'unit': 'quintal', 'trend': 'up', 'change': 3.0},
      {'name': 'Rice', 'price': 3200.0, 'unit': 'quintal', 'trend': 'up', 'change': 5.0},
      {'name': 'Maize', 'price': 1850.0, 'unit': 'quintal', 'trend': 'down', 'change': -2.0},
      {'name': 'Tomato', 'price': 40.0, 'unit': 'kg', 'trend': 'stable', 'change': 0.0},
      {'name': 'Onion', 'price': 35.0, 'unit': 'kg', 'trend': 'up', 'change': 8.0},
      {'name': 'Potato', 'price': 25.0, 'unit': 'kg', 'trend': 'down', 'change': -4.0},
      {'name': 'Sugarcane', 'price': 350.0, 'unit': 'quintal', 'trend': 'stable', 'change': 0.0},
      {'name': 'Cotton', 'price': 6500.0, 'unit': 'quintal', 'trend': 'up', 'change': 2.0},
    ];
  }
}
