import 'package:flutter/material.dart';
import '../screens/market_prices_screen.dart';

class MarketPricesCard extends StatelessWidget {
  const MarketPricesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MarketPricesScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6F00).withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6F00),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6F00).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Market Prices',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242),
                          ),
                        ),
                        Text(
                          'Live mandi rates',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF757575),
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Trending Crops Preview
              _buildCropPriceRow('🌾', 'Wheat', '₹2,150', '📈', '+3%', Colors.green),
              const SizedBox(height: 12),
              _buildCropPriceRow('🌽', 'Maize', '₹1,850', '📉', '-2%', Colors.red),
              const SizedBox(height: 12),
              _buildCropPriceRow('🍅', 'Tomato', '₹40/kg', '➡️', '0%', Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropPriceRow(
    String emoji,
    String crop,
    String price,
    String trendIcon,
    String change,
    Color changeColor,
  ) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            crop,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          trendIcon,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 4),
        Text(
          change,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: changeColor,
          ),
        ),
      ],
    );
  }
}
