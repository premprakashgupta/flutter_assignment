import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  final String baseUrl =
      "https://premprakashgupta.github.io/moviedb/movieslist.json";

  Future<List<Map<String, dynamic>>> getMovies() async {
    final String apiUrl = baseUrl;

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> movies =
            jsonData.map((data) => data as Map<String, dynamic>).toList();
        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
