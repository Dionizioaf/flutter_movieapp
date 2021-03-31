import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/environment_config.dart';
import 'package:movieapp/home/movies_exception.dart';

import 'movie.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.read(environmentConfigProvider);

  return MovieService(config, Dio());
});

class MovieService {
  MovieService(this._environmentConfig, this._dio);

  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  Future<List<Movie>> getMovies(int pageNumber) async {
    String argPagNumer = pageNumber.toString();

    try {
      final response = await _dio.get(
          //"https://api.themoviedb.org/3/movie/popular?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=1");
          "https://api.themoviedb.org/3/movie/popular?api_key=5872f0bc94beae0bd581a51708e05738&language=en-US&page=$argPagNumer");

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<Movie> movies = results
          .map((movieData) => Movie.fromMap(movieData))
          .toList(growable: false);

      return movies;
    } on DioError catch (dioError) {
      throw MoviesException.fromDioError(dioError);
    }
  }
}
