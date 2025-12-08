import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';

class ApiService {
  Future<Map<String, dynamic>> analyzeCrop({
    required File imageFile,
    required String question,
    required String language,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.cropDiseaseApiUrl}${ApiConfig.cropDiseaseEndpoint}'),
      );

      // For web platform, read file as bytes instead of using path
      var bytes = await imageFile.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'crop_image.jpg',
      );
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var apiResponse = json.decode(response.body);
        
        // Transform API response to our app's format
        return _transformCropDiseaseResponse(apiResponse, question, language);
      } else {
        print('Crop Disease API Error: Status ${response.statusCode}');
        print('Response body: ${response.body}');
        return _getDemoCropResponse(question, language);
      }
    } catch (e) {
      print('Crop Disease API Exception: $e');
      print('API URL: ${ApiConfig.cropDiseaseApiUrl}${ApiConfig.cropDiseaseEndpoint}');
      return _getDemoCropResponse(question, language);
    }
  }

  Map<String, dynamic> _transformCropDiseaseResponse(
    Map<String, dynamic> apiResponse, 
    String question,
    String language
  ) {
    // API returns: predicted_class, predicted_crop, predicted_diseases, confidence_percentage, recommendations
    String crop = apiResponse['predicted_crop'] ?? 'Unknown';
    String disease = apiResponse['predicted_diseases'] ?? 'Unknown';
    double confidence = (apiResponse['confidence_percentage'] ?? 0) / 100.0;
    
    // Use LLM-generated recommendations from API response
    List<String> recommendations = apiResponse['recommendations'] != null 
        ? List<String>.from(apiResponse['recommendations'])
        : _generateRecommendations(crop, disease, language);  // Fallback to generic if API doesn't provide
    
    // Generate analysis text based on language
    String analysis = _generateAnalysisText(crop, disease, language);
    
    return {
      'analysis': analysis,
      'confidence': confidence,
      'recommendations': recommendations,
      'crop_type': crop,
      'disease_detected': disease,
    };
  }

  String _generateAnalysisText(String crop, String disease, String language) {
    final templates = {
      'en': 'Detected: $crop affected by $disease. This is a common disease that affects crop health and yield. Immediate action is recommended to prevent spread.',
      'hi': 'पता लगाया: $crop $disease से प्रभावित। यह एक सामान्य रोग है जो फसल स्वास्थ्य और उपज को प्रभावित करता है। प्रसार को रोकने के लिए तत्काल कार्रवाई की सिफारिश की जाती है।',
      'ta': 'கண்டறியப்பட்டது: $crop $disease ஆல் பாதிக்கப்பட்டுள்ளது. இது பயிர் ஆரோக்கியம் மற்றும் விளைச்சலை பாதிக்கும் பொதுவான நோய். பரவலைத் தடுக்க உடனடி நடவடிக்கை பரிந்துரைக்கப்படுகிறது.',
      'te': 'గుర్తించబడింది: $crop $disease ద్వారా ప్రభావితమైంది. ఇది పంట ఆరోగ్యం మరియు దిగుబడిని ప్రభావితం చేసే సాధారణ వ్యాధి. వ్యాప్తిని నిరోధించడానికి తక్షణ చర్య సిఫార్సు చేయబడింది.',
    };
    return templates[language] ?? templates['en']!;
  }

  List<String> _generateRecommendations(String crop, String disease, String language) {
    final recommendations = {
      'en': [
        'Remove and destroy infected plant parts immediately',
        'Apply appropriate fungicide or pesticide as recommended',
        'Improve air circulation between plants',
        'Avoid overhead watering to reduce moisture on leaves',
        'Monitor neighboring plants for similar symptoms',
        'Consult local agricultural extension officer for treatment',
      ],
      'hi': [
        'संक्रमित पौधों के भागों को तुरंत हटा दें और नष्ट कर दें',
        'अनुशंसित फ़ंगसाइड या कीटनाशक लगाएं',
        'पौधों के बीच वायु संचलन में सुधार करें',
        'पत्तियों पर नमी कम करने के लिए ऊपरी सिंचाई से बचें',
        'समान लक्षणों के लिए पड़ोसी पौधों की निगरानी करें',
        'उपचार के लिए स्थानीय कृषि विस्तार अधिकारी से परामर्श करें',
      ],
    };
    return recommendations[language] ?? recommendations['en']!;
  }

  Map<String, dynamic> _getDemoCropResponse(String question, String language) {
    final responses = {
      'en': {
        'analysis': '🌾 Demo Mode: Crop Disease Detector API not running. This is a sample response. In production, the AI would analyze the image and detect specific crop diseases with high accuracy. Start the crop disease detector API at http://127.0.0.1:8000',
        'confidence': 0.75,
        'recommendations': [
          'Start crop disease detector API locally',
          'Ensure good image quality with proper lighting',
          'Focus camera on affected crop areas',
        ],
        'crop_type': 'Demo Crop',
        'disease_detected': 'Sample Disease',
      },
      'hi': {
        'analysis': '🌾 डेमो मोड: क्रॉप डिजीज डिटेक्टर API नहीं चल रहा है। यह एक नमूना प्रतिक्रिया है। उत्पादन में, AI छवि का विश्लेषण करेगी और उच्च सटीकता के साथ विशिष्ट फसल रोगों का पता लगाएगी। http://127.0.0.1:8000 पर क्रॉप डिजीज डिटेक्टर API शुरू करें',
        'confidence': 0.75,
        'recommendations': [
          'स्थानीय रूप से क्रॉप डिजीज डिटेक्टर API शुरू करें',
          'उचित प्रकाश के साथ अच्छी छवि गुणवत्ता सुनिश्चित करें',
          'प्रभावित फसल क्षेत्रों पर कैमरा फोकस करें',
        ],
        'crop_type': 'डेमो फसल',
        'disease_detected': 'नमूना रोग',
      },
    };
    
    return responses[language] ?? responses['en']!;
  }


  Future<Map<String, dynamic>> askQuestion({
    required String question,
    required String language,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('${ApiConfig.cropDiseaseApiUrl}/chat'),  // Use Render API for chat
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'question': question,
          'language': language,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Chat API Error: Status ${response.statusCode}');
        print('Response body: ${response.body}');
        return _getDemoResponse(question, language);
      }
    } catch (e) {
      print('Chat API Exception: $e');
      print('API URL: ${ApiConfig.cropDiseaseApiUrl}/chat');
      return _getDemoResponse(question, language);
    }
  }

  Map<String, dynamic> _getDemoResponse(String question, String language) {
    final responses = {
      'en': {
        'answer': '🌾 Demo Mode: Your question was "$question". This is a sample response. The AgroWise AI system would normally analyze your farming question and provide expert advice on crop management, pest control, irrigation, fertilizers, and seasonal planning. Please connect to the backend server for real AI responses.'
      },
      'hi': {
        'answer': '🌾 डेमो मोड: आपका प्रश्न था "$question"। यह एक नमूना उत्तर है। AgroWise AI प्रणाली आम तौर पर आपके कृषि प्रश्न का विश्लेषण करेगी और फसल प्रबंधन, कीट नियंत्रण, सिंचाई, उर्वरक और मौसमी योजना पर विशेषज्ञ सलाह प्रदान करेगी। वास्तविक AI प्रतिक्रियाओं के लिए कृपया बैकएंड सर्वर से कनेक्ट करें।'
      },
      'ta': {
        'answer': '🌾 டெமோ பயன்முறை: உங்கள் கேள்வி "$question". இது ஒரு மாதிரி பதில். AgroWise AI அமைப்பு பொதுவாக உங்கள் விவசாய கேள்வியை பகுப்பாய்வு செய்து பயிர் மேலாண்மை, பூச்சி கட்டுப்பாடு, நீர்ப்பாசனம், உரங்கள் மற்றும் பருவகால திட்டமிடல் குறித்து நிபுணர் ஆலோசனையை வழங்கும். உண்மையான AI பதில்களுக்கு பின்புற சேவையகத்துடன் இணைக்கவும்.'
      },
      'te': {
        'answer': '🌾 డెమో మోడ్: మీ ప్రశ్న "$question". ఇది ఒక నమూనా సమాధానం. AgroWise AI వ్యవస్థ సాధారణంగా మీ వ్యవసాయ ప్రశ్నను విశ్లేషించి పంట నిర్వహణ, పురుగుల నియంత్రణ, నీటిపారుదల, ఎరువులు మరియు కాలానుగుణ ప్రణాళికపై నిపుణుల సలహాను అందిస్తుంది. నిజమైన AI స్పందనల కోసం దయచేసి బ్యాకెండ్ సర్వర్‌కు కనెక్ట్ చేయండి.'
      },
    };
    
    return responses[language] ?? responses['en']!;
  }

  Future<List<String>> getSupportedLanguages() async {
    try {
      var response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.languagesEndpoint}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return List<String>.from(data['supported']);
      } else {
        // Return default languages if API fails
        return ['hi', 'ta', 'te', 'en'];
      }
    } catch (e) {
      // Return default languages if API fails
      return ['hi', 'ta', 'te', 'en'];
    }
  }
}
