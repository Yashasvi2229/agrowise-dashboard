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
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.analyzeCropEndpoint}'),
      );

      request.fields['question'] = question;
      request.fields['language'] = language;

      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      );
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return _getDemoCropResponse(question, language);
      }
    } catch (e) {
      return _getDemoCropResponse(question, language);
    }
  }

  Map<String, dynamic> _getDemoCropResponse(String question, String language) {
    final responses = {
      'en': {
        'analysis': '🌾 Demo Mode: Your question was "$question". This is a sample crop analysis. In production, AgroWise AI would analyze the crop image and provide detailed insights about crop health, disease detection, nutrient deficiencies, and treatment recommendations.',
        'confidence': 0.85,
        'recommendations': [
          'Connect backend server for real AI analysis',
          'Ensure good image quality with proper lighting',
          'Focus on affected crop areas for better detection'
        ]
      },
      'hi': {
        'analysis': '🌾 डेमो मोड: आपका प्रश्न था "$question"। यह एक नमूना फसल विश्लेषण है। उत्पादन में, AgroWise AI फसल छवि का विश्लेषण करेगी और फसल स्वास्थ्य, रोग पहचान, पोषक तत्वों की कमी और उपचार अनुशंसाओं के बारे में विस्तृत जानकारी प्रदान करेगी।',
        'confidence': 0.85,
        'recommendations': [
          'वास्तविक AI विश्लेषण के लिए बैकएंड सर्वर कनेक्ट करें',
          'उचित प्रकाश के साथ अच्छी छवि गुणवत्ता सुनिश्चित करें',
          'बेहतर पहचान के लिए प्रभावित फसल क्षेत्रों पर ध्यान दें'
        ]
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
        Uri.parse('${ApiConfig.baseUrl}/api/ask'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'question': question,
          'language': language,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Return demo response if backend is not available
        return _getDemoResponse(question, language);
      }
    } catch (e) {
      // Return demo response if backend is not available
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
