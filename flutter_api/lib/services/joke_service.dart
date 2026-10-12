import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke.dart';

class JokeService {
  static const _baseUrl = 'https://official-joke-api.appspot.com';

  Future<Joke> fetchRandomJoke() async {
    final uri = Uri.parse('$_baseUrl/jokes/random');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load joke (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final joke = Joke.fromJson(data);
    print('[STREAM] ${joke.setup} / ${joke.punchline}');
    return joke;
  }

  Future<List<Joke>> fetchTenJokes() async {
    final uri = Uri.parse('$_baseUrl/jokes/ten');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load jokes (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    final jokes = data
        .map((e) => Joke.fromJson(e as Map<String, dynamic>))
        .toList();

    for (final joke in jokes) {
      print('[LIST] ${joke.setup} / ${joke.punchline}');
    }
    return jokes;
  }
}