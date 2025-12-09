import 'package:flutter/material.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample crop data - will be replaced with real API data
  final List<Map<String, dynamic>> _crops = [
    {'name': 'Wheat', 'emoji': '🌾', 'price': 2150, 'unit': 'quintal', 'trend': 'up', 'change': 3},
    {'name': 'Rice', 'emoji': '🍚', 'price': 3200, 'unit': 'quintal', 'trend': 'up', 'change': 5},
    {'name': 'Maize', 'emoji': '🌽', 'price': 1850, 'unit': 'quintal', 'trend': 'down', 'change': -2},
    {'name': 'Tomato', 'emoji': '🍅', 'price': 40, 'unit': 'kg', 'trend': 'stable', 'change': 0},
    {'name': 'Onion', 'emoji': '🧅', 'price': 35, 'unit': 'kg', 'trend': 'up', 'change': 8},
    {'name': 'Potato', 'emoji': '🥔', 'price': 25, 'unit': 'kg', 'trend': 'down', 'change': -4},
    {'name': 'Sugarcane', 'emoji': '🌿', 'price': 350, 'unit': 'quintal', 'trend': 'stable', 'change': 0},
    {'name': 'Cotton', 'emoji': '☁️', 'price': 6500, 'unit': 'quintal', 'trend': 'up', 'change': 2},
  ];

  List<Map<String, dynamic>> get _filteredCrops {
    if (_searchQuery.isEmpty) {
      return _crops;
    }
    return _crops.where((crop) =>
        crop['name'].toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
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
            child: _filteredCrops.isEmpty
                ? const Center(
                    child: Text(
                      'No crops found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
    Color trendColor = crop['trend'] == 'up'
        ? Colors.green
        : crop['trend'] == 'down'
            ? Colors.red
            : Colors.orange;

    String trendIcon = crop['trend'] == 'up'
        ? '📈'
        : crop['trend'] == 'down'
            ? '📉'
            : '➡️';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to crop detail screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${crop['name']} details - Coming Soon!')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Emoji
              Text(
                crop['emoji'],
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              
              // Crop info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crop['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${crop['price']} per ${crop['unit']}',
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
                    '${crop['change'] > 0 ? '+' : ''}${crop['change']}%',
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
