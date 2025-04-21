// ===============================
// CORE/SERVICES/LOCAL_STORAGE_SERVICE.DART
// ===============================

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static late SharedPreferences _preferences;

  static const String authTokenKey = 'auth_token';
  static const String themeKey = 'theme_mode';
  static const String favoriteTeamsKey = 'favorite_teams';
  static const String favoriteLeaguesKey = 'favorite_leagues';
  static const String userCacheKey = 'user_cache';
  static const String notificationsEnabledKey = 'notifications_enabled';

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _instance = LocalStorageService();
  }

  static LocalStorageService getInstance() {
    _instance ??= LocalStorageService();
    return _instance!;
  }

  // Auth token
  Future<String?> getAuthToken() async {
    return _preferences.getString(authTokenKey);
  }

  Future<void> setAuthToken(String token) async {
    await _preferences.setString(authTokenKey, token);
  }

  Future<void> clearAuthToken() async {
    await _preferences.remove(authTokenKey);
  }

  // Theme
  Future<String?> getThemeMode() async {
    return _preferences.getString(themeKey);
  }

  Future<void> setThemeMode(String themeMode) async {
    await _preferences.setString(themeKey, themeMode);
  }

  // Favorites
  Future<List<String>> getFavoriteTeams() async {
    return _preferences.getStringList(favoriteTeamsKey) ?? [];
  }

  Future<void> setFavoriteTeams(List<String> teamIds) async {
    await _preferences.setStringList(favoriteTeamsKey, teamIds);
  }

  Future<List<String>> getFavoriteLeagues() async {
    return _preferences.getStringList(favoriteLeaguesKey) ?? [];
  }

  Future<void> setFavoriteLeagues(List<String> leagueIds) async {
    await _preferences.setStringList(favoriteLeaguesKey, leagueIds);
  }

  // User cache
  Future<String?> getUserCache() async {
    return _preferences.getString(userCacheKey);
  }

  Future<void> setUserCache(String userJson) async {
    await _preferences.setString(userCacheKey, userJson);
  }

  Future<void> clearUserCache() async {
    await _preferences.remove(userCacheKey);
  }

  // Notifications
  Future<bool> getNotificationsEnabled() async {
    return _preferences.getBool(notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _preferences.setBool(notificationsEnabledKey, enabled);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _preferences.clear();
  }
}
