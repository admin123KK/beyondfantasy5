class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "https://fantasytest.livescorenepal.com/api";
  static const String loginEndPoint = "$baseUrl/login";
  static const String registerEndPoint = "$baseUrl/register";
  static const String profileEndPoint = "$baseUrl/user";
  static const String logoutEndPoint = "$baseUrl/logout";
  static const String matchesEndPoint = "$baseUrl/fantasy-matches";

  static const String playersEndPoint = "$baseUrl/players?match_id=328";
  static const String createfantasyteamEndPoint = "$baseUrl/fantasy-teams";
}
