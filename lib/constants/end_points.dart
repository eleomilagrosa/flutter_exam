class Endpoints {
  Endpoints._();
  static const String baseUrl = 'https://stable-api.pricelocq.com/mobile';
  static const int receiveTimeout = 30000;
  static const int connectionTimeout = 20000;

  static const String login = '/v2/sessions';
  static const String getAllStation = '/stations?all';
}