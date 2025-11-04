import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/models/category_model.dart';
import 'package:newsapp/services/data.dart';
import 'package:newsapp/viewmodels/home_viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'all_news.dart';
import 'article_view.dart';
import 'category_news.dart';

final homeViewModelProvider =
    ChangeNotifierProvider((ref) => HomeViewModel());

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late List<CategoryModel> categories = [];
  @override
  void initState() {
    categories = getCategories();
    super.initState();
  }

  Widget buildImage(String image, int index, String name) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                height: 250,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                imageUrl: image,
              ),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.only(left: 10.0),
              margin: const EdgeInsets.only(top: 130.0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                name,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: ref.watch(homeViewModelProvider).activeIndex,
        count: ref.watch(homeViewModelProvider).sliders.length,
        effect: const SlideEffect(
            dotWidth: 15, dotHeight: 15, activeDotColor: Colors.blue),
      );

  @override
  Widget build(BuildContext context) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Haber",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "ALL",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
              "TR",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: homeViewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    height: 80,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            image: categories[index].image,
                            categoryName: categories[index].categoryName,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Breaking News!",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllNews(news: "Breaking")));
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CarouselSlider.builder(
                    itemCount: 5,
                    itemBuilder: (context, index, realIndex) {
                      String? res =
                          homeViewModel.sliders[index].urlToImage;
                      String? res1 = homeViewModel.sliders[index].title;
                      return buildImage(res!, index, res1!);
                    },
                    options: CarouselOptions(
                        height: 250,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index, reason) {
                          homeViewModel.setActiveIndex(index);
                        }),
                  ),
                  const SizedBox(height: 30.0),
                  Center(child: buildIndicator()),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Trending News!",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllNews(news: "Trending")));
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: homeViewModel.articles.length,
                      itemBuilder: (context, index) {
                        return BlockTile(
                          url: homeViewModel.articles[index].url!,
                          desc: homeViewModel.articles[index].description!,
                          imageUrl: homeViewModel.articles[index].urlToImage!,
                          title: homeViewModel.articles[index].title!,
                        );
                      }),
                ],
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({this.categoryName, this.image});

  final image, categoryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: image,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BlockTile extends StatelessWidget {
  BlockTile(
      {required this.desc,
      required this.imageUrl,
      required this.title,
      required this.url});

  String imageUrl, title, desc, url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 150,
                        height: 150,
                        imageUrl: imageUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: Text(
                              title,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            ),
                          ),
                          const SizedBox(height: 7.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: Text(
                              desc,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
