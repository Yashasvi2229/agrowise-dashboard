import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class QueryHistory {
  final String id;
  final String? imagePath;
  final String question;
  final String answer;
  final String language;
  final DateTime timestamp;
  final double? confidence;
  final List<String>? recommendations;

  QueryHistory({
    required this.id,
    this.imagePath,
    required this.question,
    required this.answer,
    required this.language,
    required this.timestamp,
    this.confidence,
    this.recommendations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'question': question,
      'answer': answer,
      'language': language,
      'timestamp': timestamp.toIso8601String(),
      'confidence': confidence,
      'recommendations': recommendations,
    };
  }

  factory QueryHistory.fromJson(Map<String, dynamic> json) {
    return QueryHistory(
      id: json['id'],
      imagePath: json['imagePath'],
      question: json['question'],
      answer: json['answer'],
      language: json['language'],
      timestamp: DateTime.parse(json['timestamp']),
      confidence: json['confidence']?.toDouble(),
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : null,
    );
  }
}

class StorageService {
  static const String _historyKey = 'query_history';

  Future<void> saveQuery(QueryHistory query) async {
    final prefs = await SharedPreferences.getInstance();
    final histories = await getHistory();
    histories.insert(0, query);

    // Keep only last 50 queries
    if (histories.length > 50) {
      histories.removeRange(50, histories.length);
    }

    final jsonList = histories.map((h) => h.toJson()).toList();
    await prefs.setString(_historyKey, json.encode(jsonList));
  }

  Future<List<QueryHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);

    if (jsonString == null) {
      return [];
    }

    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => QueryHistory.fromJson(json)).toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<String> saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = File('${imagesDir.path}/$fileName');
    await imageFile.copy(savedImage.path);

    return savedImage.path;
  }
}
