import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/joke_service.dart';

class JokeListScreen extends StatefulWidget {
  const JokeListScreen({super.key});

  @override
  State<JokeListScreen> createState() => _JokeListScreenState();
}

class _JokeListScreenState extends State<JokeListScreen> {
  final _service = JokeService();
  late Future<List<Joke>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchTenJokes();
  }

  void _retry() {
    setState(() {
      _future = _service.fetchTenJokes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The Order')),
      body: FutureBuilder<List<Joke>>(
        future: _future,
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error + Retry
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load jokes.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Empty
          final jokes = snapshot.data ?? [];
          if (jokes.isEmpty) {
            return const Center(child: Text('No jokes found.'));
          }

          // 4. Data
          return ListView.builder(
            itemCount: jokes.length,
            itemBuilder: (context, index) {
              final joke = jokes[index];
              return ListTile(
                title: Text(joke.setup),
                subtitle: Text(joke.punchline),
                trailing: Text(joke.type),
              );
            },
          );
        },
      ),
    );
  }
}