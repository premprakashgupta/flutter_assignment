import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      controller.searchText.value = value;
                      controller.filterAndSortMovies();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Movie',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              PopupMenuButton(
                onSelected: (value) {
                  controller.sortBy.value = value;
                  controller.filterAndSortMovies();
                },
                icon: const Icon(Icons.filter_alt_rounded),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                        value: "rating",
                        // row has two child icon and text.
                        child: Text("Rating")),
                    const PopupMenuItem(
                        value: "year",
                        // row has two child icon and text.
                        child: Text("Year")),
                  ];
                },
              )
            ],
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    controller: controller.scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust as needed
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 9 / 16,
                    ),
                    itemCount: controller.filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = controller.filteredMovies[index];
                      final savePost = controller.savePost;
                      print("savePost");
                      return Card(
                        elevation: 3.0,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Flexible(
                              flex: 6,
                              child: Image.network(
                                movie['image'].toString(),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  movie['title'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Rating: ${movie['rating']}')),
                              ),
                            ), // Add more movie details here
                            Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Year: ${movie['year']}'),
                                  ),
                                  Obx(() => IconButton(
                                        onPressed: () {
                                          controller.savePostFunction(
                                              id: movie['id']);
                                        },
                                        icon: Icon(savePost
                                                .contains(movie['id'])
                                            ? Icons.bookmark_outlined
                                            : Icons.bookmark_border_outlined),
                                      ))
                                ],
                              ),
                            ) // Add more movie details here
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
