import 'package:flutter/material.dart';
import '../services/market_price_service.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MarketPriceService _marketPriceService = MarketPriceService();
  
  String _searchQuery = '';
  List<Map<String, dynamic>> _allCrops = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMarketPrices();
  }

  Future<void> _loadMarketPrices() async {
    setState(() {
      _loading = true;
    });

    try {
      final crops = await _marketPriceService.getMarketPrices();
      setState(() {
        _allCrops = crops.isNotEmpty ? crops : _marketPriceService.getDemoData();
        _loading = false;
      });
    } catch (e) {
      print('Error loading market prices: $e');
      setState(() {
        _allCrops = _marketPriceService.getDemoData();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredCrops {
    if (_searchQuery.isEmpty) {
      return _allCrops;
    }
    return _allCrops.where((crop) =>
        crop['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  // Get emoji for commodity (simplified mapping)
  String _getCropEmoji(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('wheat')) return '🌾';
    if (lowerName.contains('rice') || lowerName.contains('paddy')) return '🍚';
    if (lowerName.contains('maize') || lowerName.contains('corn')) return '🌽';
    if (lowerName.contains('tomato')) return '🍅';
    if (lowerName.contains('onion')) return '🧅';
    if (lowerName.contains('potato')) return '🥔';
    if (lowerName.contains('sugarcane') || lowerName.contains('cane')) return '🌿';
    if (lowerName.contains('cotton')) return '☁️';
    if (lowerName.contains('soybean') || lowerName.contains('soya')) return '🫘';
    if (lowerName.contains('groundnut') || lowerName.contains('peanut')) return '🥜';
    if (lowerName.contains('coconut')) return '🥥';
    if (lowerName.contains('apple')) return '🍎';
    if (lowerName.contains('banana')) return '🍌';
    if (lowerName.contains('mango')) return '🥭';
    if (lowerName.contains('grape')) return '🍇';
    if (lowerName.contains('orange')) return '🍊';
    if (lowerName.contains('chilli') || lowerName.contains('chili') || lowerName.contains('pepper')) return '🌶️';
    if (lowerName.contains('garlic')) return '🧄';
    if (lowerName.contains('ginger')) return '🫚';
    if (lowerName.contains('turmeric')) return '🟡';
    return '🌱'; // Default for unknown crops
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Prices'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF2E7D32),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search crops...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffix: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Crop List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCrops.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No crops available'
                                  : 'No crops found',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            if (!_searchQuery.isEmpty) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Text('Clear search'),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredCrops.length,
                        itemBuilder: (context, index) {
                          final crop = _filteredCrops[index];
                          return _buildCropCard(crop);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropCard(Map<String, dynamic> crop) {
    final String trend = crop['trend'] ?? 'stable';
    final double change = (crop['change'] ?? 0).toDouble();
    
    Color trendColor = trend == 'up'
        ? Colors.green
        : trend == 'down'
            ? Colors.red
            : Colors.orange;

    String trendIcon = trend == 'up'
        ? '📈'
        : trend == 'down'
            ? '📉'
            : '➡️';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Show market and state info
          final market = crop['market'] ?? '';
          final state = crop['state'] ?? '';
          final detail = market.isNotEmpty && state.isNotEmpty
              ? '$market, $state'
              : crop['name'];
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(detail)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Emoji
              Text(
                _getCropEmoji(crop['name'] ?? ''),
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              
              // Crop info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crop['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${crop['price']?.toStringAsFixed(0) ?? '0'} per ${crop['unit'] ?? 'quintal'}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Trend
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    trendIcon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: trendColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
