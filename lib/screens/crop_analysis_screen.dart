import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_localizations.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class CropAnalysisScreen extends StatefulWidget {
  const CropAnalysisScreen({super.key});

  @override
  State<CropAnalysisScreen> createState() => _CropAnalysisScreenState();
}

class _CropAnalysisScreenState extends State<CropAnalysisScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _questionController = TextEditingController();
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;
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
        title: Text(localizations.translate('analyze_crop')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Selection Area
            if (_selectedImage == null)
              _buildImageSelectionArea(localizations)
            else
              _buildSelectedImageArea(localizations),

            const SizedBox(height: 20),

            // Question Input
            if (_selectedImage != null && _analysisResult == null) ...[
              TextField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: localizations.translate('enter_question'),
                  labelStyle: const TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(fontSize: 18),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _analyzeCrop,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            localizations.translate('analyzing'),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    : Text(
                        localizations.translate('send'),
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ],

            // Analysis Result
            if (_analysisResult != null) _buildAnalysisResult(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelectionArea(AppLocalizations localizations) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_photo_alternate, size: 80, color: Color(0xFF2E7D32)),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(localizations.translate('take_photo')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: Text(localizations.translate('choose_gallery')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D4037),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImageArea(AppLocalizations localizations) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            _selectedImage!,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        if (_analysisResult == null)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedImage = null;
                _questionController.clear();
              });
            },
            icon: const Icon(Icons.refresh),
            label: Text(localizations.translate('take_photo')),
          ),
      ],
    );
  }

  Widget _buildAnalysisResult(AppLocalizations localizations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Analysis Complete',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Confidence
            if (_analysisResult!['confidence'] != null) ...[
              Row(
                children: [
                  Text(
                    '${localizations.translate('confidence')}: ',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(_analysisResult!['confidence'] * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 18, color: Color(0xFF2E7D32)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Analysis Text
            Text(
              _analysisResult!['analysis'] ?? '',
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            
            // Recommendations
            if (_analysisResult!['recommendations'] != null &&
                (_analysisResult!['recommendations'] as List).isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                localizations.translate('recommendations'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...(_analysisResult!['recommendations'] as List).map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rec.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                    _analysisResult = null;
                    _questionController.clear();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Analyze Another Crop'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _analyzeCrop() async {
    if (_selectedImage == null || _questionController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.analyzeCrop(
        imageFile: _selectedImage!,
        question: _questionController.text,
        language: _currentLanguage,
      );

      // Save to history
      final savedImagePath = await _storageService.saveImage(_selectedImage!);
      await _storageService.saveQuery(
        QueryHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imagePath: savedImagePath,
          question: _questionController.text,
          answer: result['analysis'] ?? '',
          language: _currentLanguage,
          timestamp: DateTime.now(),
          confidence: result['confidence']?.toDouble(),
          recommendations: result['recommendations'] != null
              ? List<String>.from(result['recommendations'])
              : null,
        ),
      );

      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
