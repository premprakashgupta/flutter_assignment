class Movie {
  final int? rank;
  final String? title;
  final String? thumbnail;
  final String? rating;
  final String? id;
  final int? year;
  final String? image;
  final String? description;
  final String? trailer;
  final List<String>? genre;
  final List<String>? director;
  final List<String>? writers;
  final String? imdbid;

  Movie({
    this.rank,
    this.title,
    this.thumbnail,
    this.rating,
    this.id,
    this.year,
    this.image,
    this.description,
    this.trailer,
    this.genre,
    this.director,
    this.writers,
    this.imdbid,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      rank: json['rank'] as int,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      rating: json['rating'] as String,
      id: json['id'] as String,
      year: json['year'] as int,
      image: json['image'] as String,
      description: json['description'] as String,
      trailer: json['trailer'] as String,
      genre: (json['genre'] as List).map((genre) => genre as String).toList(),
      director: (json['director'] as List)
          .map((director) => director as String)
          .toList(),
      writers:
          (json['writers'] as List).map((writer) => writer as String).toList(),
      imdbid: json['imdbid'] as String,
    );
  }
}
