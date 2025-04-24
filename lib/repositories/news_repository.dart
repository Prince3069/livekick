// lib/repositories/news_repository.dart
import 'package:livekick/models/news.dart';
import 'package:livekick/services/rapid_api_service.dart';

class NewsRepository {
  final RapidApiService _apiService = RapidApiService();

  Future<List<News>> getLatestNews() async {
    try {
      return await _apiService.getFootballNews();
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<News> getNewsById(String id) async {
    try {
      final allNews = await _apiService.getFootballNews();
      final news = allNews.firstWhere((item) => item.id == id);
      return news;
    } catch (e) {
      throw Exception('Failed to load news details: $e');
    }
  }
}
