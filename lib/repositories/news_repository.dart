import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapp/config.dart';
import 'package:newsapp/models/article_model.dart';
import 'package:newsapp/models/slider_model.dart';

class NewsRepository {
  Future<List<ArticleModel>> getNews() async {
    List<ArticleModel> news = [];
    String url =
        'https://newsapi.org/v2/everything?q=tesla&from=2023-11-24&sortBy=publishedAt&apiKey=${apiKey}';
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );

          news.add(articleModel);
        }
      });
    }
    return news;
  }

  Future<List<sliderModel>> getSliders() async {
    List<sliderModel> sliders = [];
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=${apiKey}';
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          sliderModel slidermodel = sliderModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );

          sliders.add(slidermodel);
        }
      });
    }
    return sliders;
  }
}
