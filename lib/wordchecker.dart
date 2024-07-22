import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class WordChecker extends StatefulWidget {
  const WordChecker({super.key});

  @override
  State<WordChecker> createState() => _WordCheckerState();
}

class _WordCheckerState extends State<WordChecker> {
  List<String> wordList = [];
  final TextEditingController _textController = TextEditingController();
  String _result = '';

  @override
  void initState() {
    super.initState();
    loadWordsFromGithubOrCache().then((words) {
      setState(() {
        wordList = words;
      });
    });
  }
  
  Future<List<String>> loadWordsFromGithubOrCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('wordList')) {
      // Load from cache
      String cachedList = prefs.getString('wordList')!;
      return json.decode(cachedList).cast<String>();
    } else {
      // Fetch from GitHub and cache
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/JorgeDuenasLerin/diccionario-espanol-txt/master/0_palabras_todas.txt'));
      if (response.statusCode == 200) {
        List<String> wordList = response.body.split('\n');
        prefs.setString('wordList', json.encode(wordList));
        return wordList;
      } else {
        throw Exception('Failed to load words from GitHub');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Checker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
            padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter a word',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredText = _textController.text;
                setState(() {
                  _result = wordList.contains(enteredText)
                      ? 'The word "$enteredText" exists in the list.'
                      : 'The word "$enteredText" does not exist in the list.';
                });
              },
              child: const Text('Check'),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(_result),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> wordList = ['apple', 'banana', 'orange', 'grape', 'hello'];
