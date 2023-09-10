import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mitt_arv/app/data/api/api_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final ApiController apiController = ApiController();
  late SharedPreferences prefs;
  var movies = <Map<String, dynamic>>[].obs;
  var filteredMovies = <Map<String, dynamic>>[].obs;
  var searchText = ''.obs;
  var sortBy = 'rating'.obs;
  var isLoading = true.obs; // Changed initial value to true
  var page = 5;
  bool isScrollingDown = false;
  final savePost = <String>[].obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    initializeSharedPrefs();
    fetchMovies();
    setupScrollListener();
  }

  void initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var response = prefs.getStringList('save_posts');
    if (response != null) {
      savePost.addAll(response);
    }
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (page < movies.length) {
          page += 5;
          filterAndSortMovies();
          isScrollingDown = true;
        }
      } else if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        if (isScrollingDown && page > 5) {
          page -= 5;
          filterAndSortMovies();
          isScrollingDown = false;
        }
      }
    });
  }

  void fetchMovies() async {
    try {
      isLoading.value = true;
      final response = await apiController.getMovies();
      movies.assignAll(response);
      filterAndSortMovies();
    } finally {
      isLoading.value = false;
    }
  }

  void filterAndSortMovies() {
    var temp = movies
        .where((movie) => movie['title']
            .toLowerCase()
            .contains(searchText.value.toLowerCase()))
        .toList();

    if (temp.length > page) {
      filteredMovies.assignAll(temp.sublist(0, page));
    } else {
      filteredMovies.assignAll(temp);
    }

    switch (sortBy.value) {
      case 'rating':
        filteredMovies.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'year':
        filteredMovies
            .sort((a, b) => (b['year'] as num).compareTo(a['year'] as num));
        break;
    }
  }

  void savePostFunction({required String id}) {
    if (savePost.contains(id)) {
      savePost.remove(id);
    } else {
      savePost.add(id);
    }
    prefs.setStringList('save_posts', savePost);
    update();
    print(savePost);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
