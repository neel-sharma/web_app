class AppConstants {
  static const String baseUrl = '{{url}}';
  static const String loaderPath = 'assets/loading.json';
  {{#enableRemoteConfig}}static const String baseUrlKey = 'base_url';{{/enableRemoteConfig}}
}