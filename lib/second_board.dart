import 'package:flutter/material.dart';
import 'dart:math';

List<List<String>> generateRandomBoard() {
  final random = Random();
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  List<List<String>> board = [];

  for (int i = 0; i < 4; i++) {
    List<String> row = [];
    for (int j = 0; j < 4; j++) {
      row.add(letters[random.nextInt(letters.length)]);
    }
    board.add(row);
  }

  return board;
}

class BoggleBoard extends StatelessWidget {
  final List<List<String>> board;

  const BoggleBoard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 16, // 4x4 grid
      itemBuilder: (context, index) {
        final row = index ~/ 4;
        final col = index % 4;
        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              board[row][col],
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  String currentWord = '';
  List<List<bool>> buttonPressed = List.generate(
    4,
    (_) => List.generate(4, (_) => false),
  );
  List<String> words = [];
  late List<List<String>> board;

  void handleButtonPress(int index) {
    setState(() {
      final row = index ~/ 4;
      final col = index % 4;

      buttonPressed[row][col] = !buttonPressed[row][col]; // Toggle button state

      if (buttonPressed[row][col]) {
        currentWord += board[row][col];
      } else {
        // Remove the letter (consider edge cases here)
        currentWord = currentWord.substring(0, currentWord.length - 1);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    board = generateRandomBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Current Word: $currentWord'), // Display the formed word
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: 16,
          shrinkWrap: true, // Prevent GridView from taking up full height
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          itemBuilder: (context, index) {
            final row = index ~/ 4;
            final col = index % 4;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () => handleButtonPress(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonPressed[row][col] ? Colors.blue : null,
                ),
                child: Text(
                  board[row][col],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
