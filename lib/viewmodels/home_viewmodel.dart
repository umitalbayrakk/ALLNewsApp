import 'package:flutter/material.dart';
import 'package:newsapp/models/article_model.dart';
import 'package:newsapp/models/slider_model.dart';
import 'package:newsapp/repositories/news_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final NewsRepository _newsRepository = NewsRepository();

  List<ArticleModel> _articles = [];
  List<sliderModel> _sliders = [];
  bool _loading = true;
  int _activeIndex = 0;

  List<ArticleModel> get articles => _articles;
  List<sliderModel> get sliders => _sliders;
  bool get loading => _loading;
  int get activeIndex => _activeIndex;

  HomeViewModel() {
    _init();
  }

  void _init() async {
    await _getNews();
    await _getSliders();
    _loading = false;
    notifyListeners();
  }

  Future<void> _getNews() async {
    _articles = await _newsRepository.getNews();
  }

  Future<void> _getSliders() async {
    _sliders = await _newsRepository.getSliders();
  }

  void setActiveIndex(int index) {
    _activeIndex = index;
    notifyListeners();
  }
}
