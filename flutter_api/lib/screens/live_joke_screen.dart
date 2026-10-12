import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/joke_service.dart';

class LiveJokeScreen extends StatefulWidget {
  const LiveJokeScreen({super.key});

  @override
  State<LiveJokeScreen> createState() => _LiveJokeScreenState();
}

class _LiveJokeScreenState extends State<LiveJokeScreen> {
  final _service = JokeService();
  late final Stream<Joke> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _jokeStream();
  }

  Stream<Joke> _jokeStream() async* {
    while (true) {
      try {
        yield await _service.fetchRandomJoke();
      } catch (e) {
        print('[STREAM ERROR] $e');
        yield* Stream<Joke>.error(e);
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The Belt')),
      body: StreamBuilder<Joke>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData &&
              !snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error (the stream keeps running and will recover)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Something went wrong.\nTrying again in 5 seconds...\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final joke = snapshot.data!;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    joke.setup,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    joke.punchline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  Text('Type: ${joke.type}  |  ID: ${joke.id}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}