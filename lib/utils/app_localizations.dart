import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'AgroWise',
      'home_title': 'AgroWise - Your Farm Assistant',
      'analyze_crop': 'Analyze Crop Photo',
      'ask_question': 'Ask a Question',
      'call_helpline': 'Call Helpline',
      'history': 'History',
      'settings': 'Settings',
      'select_language': 'Select Language',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'tamil': 'தமிழ் (Tamil)',
      'telugu': 'తెలుగు (Telugu)',
      'punjabi': 'ਪੰਜਾਬੀ (Punjabi)',
      'take_photo': 'Take Photo',
      'choose_gallery': 'Choose from Gallery',
      'cancel': 'Cancel',
      'enter_question': 'What would you like to know about this crop?',
      'send': 'Send',
      'analyzing': 'Analyzing crop...',
      'loading': 'Loading...',
      'no_internet': 'No Internet Connection',
      'error_occurred': 'An error occurred',
      'try_again': 'Try Again',
      'previous_queries': 'Previous Queries',
      'no_history': 'No previous queries',
      'saved_recommendations': 'Saved Recommendations',
      'confidence': 'Confidence',
      'recommendations': 'Recommendations',
      'chat_placeholder': 'Type your question here...',
      'call_now': 'Call Now',
      'helpline_number': '+18557746931',
      'helpline_description': 'Speak with our AI assistant in Hindi, Tamil, Telugu, or English',
    },
    'hi': {
      'app_title': 'एग्रोवाइज',
      'home_title': 'एग्रोवाइज - आपका कृषि सहायक',
      'analyze_crop': 'फसल फोटो विश्लेषण',
      'ask_question': 'प्रश्न पूछें',
      'call_helpline': 'हेल्पलाइन पर कॉल करें',
      'history': 'इतिहास',
      'settings': 'सेटिंग्स',
      'select_language': 'भाषा चुनें',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'tamil': 'தமிழ் (Tamil)',
      'telugu': 'తెలుగు (Telugu)',
      'punjabi': 'ਪੰਜਾਬੀ (Punjabi)',
      'take_photo': 'फोटो लें',
      'choose_gallery': 'गैलरी से चुनें',
      'cancel': 'रद्द करें',
      'enter_question': 'इस फसल के बारे में आप क्या जानना चाहते हैं?',
      'send': 'भेजें',
      'analyzing': 'फसल का विश्लेषण हो रहा है...',
      'loading': 'लोड हो रहा है...',
      'no_internet': 'इंटरनेट कनेक्शन नहीं है',
      'error_occurred': 'एक त्रुटि हुई',
      'try_again': 'पुनः प्रयास करें',
      'previous_queries': 'पिछले प्रश्न',
      'no_history': 'कोई पिछला प्रश्न नहीं',
      'saved_recommendations': 'सहेजी गई सिफारिशें',
      'confidence': 'विश्वास',
      'recommendations': 'सिफारिशें',
      'chat_placeholder': 'अपना प्रश्न यहाँ लिखें...',
      'call_now': 'अभी कॉल करें',
      'helpline_number': '+18557746931',
      'helpline_description': 'हिंदी, तमिल, तेलुगु या अंग्रेजी में हमारे AI सहायक से बात करें',
    },
    'ta': {
      'app_title': 'அக்ரோவைஸ்',
      'home_title': 'அக்ரோவைஸ் - உங்கள் விவசாய உதவியாளர்',
      'analyze_crop': 'பயிர் புகைப்படம் பகுப்பாய்வு',
      'ask_question': 'கேள்வி கேளுங்கள்',
      'call_helpline': 'உதவி எண்ணை அழைக்கவும்',
      'history': 'வரலாறு',
      'settings': 'அமைப்புகள்',
      'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'tamil': 'தமிழ் (Tamil)',
      'telugu': 'తెలుగు (Telugu)',
      'punjabi': 'ਪੰਜਾਬੀ (Punjabi)',
      'take_photo': 'புகைப்படம் எடுக்கவும்',
      'choose_gallery': 'கேலரியில் இருந்து தேர்வு செய்க',
      'cancel': 'ரத்து செய்',
      'enter_question': 'இந்த பயிரைப் பற்றி நீங்கள் என்ன தெரிந்து கொள்ள விரும்புகிறீர்கள்?',
      'send': 'அனுப்பு',
      'analyzing': 'பயிர் பகுப்பாய்வு செய்யப்படுகிறது...',
      'loading': 'ஏற்றுகிறது...',
      'no_internet': 'இணைய இணைப்பு இல்லை',
      'error_occurred': 'பிழை ஏற்பட்டது',
      'try_again': 'மீண்டும் முயற்சிக்கவும்',
      'previous_queries': 'முந்தைய கேள்விகள்',
      'no_history': 'முந்தைய கேள்விகள் இல்லை',
      'saved_recommendations': 'சேமிக்கப்பட்ட பரிந்துரைகள்',
      'confidence': 'நம்பிக்கை',
      'recommendations': 'பரிந்துரைகள்',
      'chat_placeholder': 'உங்கள் கேள்வியை இங்கே தட்டச்சு செய்யவும்...',
      'call_now': 'இப்போது அழைக்கவும்',
      'helpline_number': '+18557746931',
      'helpline_description': 'தமிழ், இந்தி, தெலுங்கு அல்லது ஆங்கிலத்தில் எங்கள் AI உதவியாளருடன் பேசுங்கள்',
    },
    'te': {
      'app_title': 'అగ్రోవైజ్',
      'home_title': 'అగ్రోవైజ్ - మీ వ్యవసాయ సహాయకుడు',
      'analyze_crop': 'పంట ఫోటో విశ్లేషణ',
      'ask_question': 'ప్రశ్న అడగండి',
      'call_helpline': 'హెల్ప్‌లైన్‌కు కాల్ చేయండి',
      'history': 'చరిత్ర',
      'settings': 'సెట్టింగ్‌లు',
      'select_language': 'భాషను ఎంచుకోండి',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'tamil': 'தமிழ் (Tamil)',
      'telugu': 'తెలుగు (Telugu)',
      'punjabi': 'ਪੰਜਾਬੀ (Punjabi)',
      'take_photo': 'ఫోటో తీయండి',
      'choose_gallery': 'గ్యాలరీ నుండి ఎంచుకోండి',
      'cancel': 'రద్దు చేయండి',
      'enter_question': 'ఈ పంట గురించి మీరు ఏమి తెలుసుకోవాలనుకుంటున్నారు?',
      'send': 'పంపించు',
      'analyzing': 'పంట విశ్లేషించబడుతోంది...',
      'loading': 'లోడ్ అవుతోంది...',
      'no_internet': 'ఇంటర్నెట్ కనెక్షన్ లేదు',
      'error_occurred': 'లోపం సంభవించింది',
      'try_again': 'మళ్ళీ ప్రయత్నించండి',
      'previous_queries': 'మునుపటి ప్రశ్నలు',
      'no_history': 'మునుపటి ప్రశ్నలు లేవు',
      'saved_recommendations': 'సేవ్ చేసిన సిఫార్సులు',
      'confidence': 'విశ్వాసం',
      'recommendations': 'సిఫార్సులు',
      'chat_placeholder': 'మీ ప్రశ్నను ఇక్కడ టైప్ చేయండి...',
      'call_now': 'ఇప్పుడు కాల్ చేయండి',
      'helpline_number': '+18557746931',
      'helpline_description': 'తెలుగు, హిందీ, తమిళం లేదా ఆంగ్లంలో మా AI సహాయకుడితో మాట్లాడండి',
    },
    'pa': {
      'app_title': 'ਐਗਰੋਵਾਈਜ਼',
      'home_title': 'ਐਗਰੋਵਾਈਜ਼ - ਤੁਹਾਡਾ ਖੇਤੀ ਸਹਾਇਕ',
      'analyze_crop': 'ਫਸਲ ਫੋਟੋ ਵਿਸ਼ਲੇਸ਼ਣ',
      'ask_question': 'ਸਵਾਲ ਪੁੱਛੋ',
      'call_helpline': 'ਹੈਲਪਲਾਈਨ ਤੇ ਕਾਲ ਕਰੋ',
      'history': 'ਇਤਿਹਾਸ',
      'settings': 'ਸੈਟਿੰਗਾਂ',
      'select_language': 'ਭਾਸ਼ਾ ਚੁਣੋ',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'tamil': 'தமிழ் (Tamil)',
      'telugu': 'తెలుగు (Telugu)',
      'punjabi': 'ਪੰਜਾਬੀ (Punjabi)',
      'take_photo': 'ਫੋਟੋ ਲਓ',
      'choose_gallery': 'ਗੈਲਰੀ ਤੋਂ ਚੁਣੋ',
      'cancel': 'ਰੱਦ ਕਰੋ',
      'enter_question': 'ਤੁਸੀਂ ਇਸ ਫਸਲ ਬਾਰੇ ਕੀ ਜਾਣਨਾ ਚਾਹੁੰਦੇ ਹੋ?',
      'send': 'ਭੇਜੋ',
      'analyzing': 'ਫਸਲ ਦਾ ਵਿਸ਼ਲੇਸ਼ਣ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ...',
      'loading': 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...',
      'no_internet': 'ਇੰਟਰਨੈੱਟ ਕਨੈਕਸ਼ਨ ਨਹੀਂ ਹੈ',
      'error_occurred': 'ਇੱਕ ਗਲਤੀ ਹੋਈ',
      'try_again': 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ',
      'previous_queries': 'ਪਿਛਲੇ ਸਵਾਲ',
      'no_history': 'ਕੋਈ ਪਿਛਲੇ ਸਵਾਲ ਨਹੀਂ',
      'saved_recommendations': 'ਸੰਭਾਲੀਆਂ ਸਿਫਾਰਸ਼ਾਂ',
      'confidence': 'ਵਿਸ਼ਵਾਸ',
      'recommendations': 'ਸਿਫਾਰਸ਼ਾਂ',
      'chat_placeholder': 'ਆਪਣਾ ਸਵਾਲ ਇੱਥੇ ਲਿਖੋ...',
      'call_now': 'ਹੁਣੇ ਕਾਲ ਕਰੋ',
      'helpline_number': '+18557746931',
      'helpline_description': 'ਪੰਜਾਬੀ, ਹਿੰਦੀ, ਤਮਿਲ, ਤੇਲਗੂ ਜਾਂ ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਸਾਡੇ AI ਸਹਾਇਕ ਨਾਲ ਗੱਲ ਕਰੋ',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'ta', 'te', 'pa'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
