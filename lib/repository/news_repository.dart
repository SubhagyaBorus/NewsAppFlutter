import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=48ab837d218d4b3391939c2738979779";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=${category}&apiKey=48ab837d218d4b3391939c2738979779";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
