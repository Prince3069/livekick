import 'package:flutter/material.dart';
import 'package:livekick/models/news.dart';
import 'package:livekick/repositories/news_repository.dart';
// import 'package:livekick/models/news_article.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsRepository _newsRepository = NewsRepository();
  bool _isLoading = true;
  String? _error;
  List<News> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final news = await _newsRepository.getLatestNews();
      setState(() {
        _articles = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Latest Football News")),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text("Error: $_error"))
              : RefreshIndicator(
                onRefresh: _loadNews,
                child: ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading:
                            article.imageUrl != null
                                ? Image.network(
                                  article.imageUrl!,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                                : Icon(Icons.image, size: 50),
                        title: Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // subtitle: Text("${article.source} • ${article.publishedAt}"),
                        // onTap: () {
                        //   // Show full article or open webview
                        //   Navigator.push(
                        //     context,
                        //     // MaterialPageRoute(
                        //       // builder: (_) => NewsDetailScreen(article: article),
                        //     ),
                        //   );
                        // },
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
