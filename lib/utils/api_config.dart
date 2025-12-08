class ApiConfig {
  // Main backend for chat and general questions
  static const String baseUrl = 'http://salutational-hortensia-histioid.ngrok-free.dev';
  static const String languagesEndpoint = '/api/languages';
  
  // Crop disease detector API (deployed on Render)
  static const String cropDiseaseApiUrl = 'https://crop-disease-api-1-wami.onrender.com';
  static const String cropDiseaseEndpoint = '/predict';
  
  // Other configs
  static const String helplineNumber = '+18557746931';
}
