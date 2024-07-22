import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myapp/wordchecker.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerState();

}


class _TimerState extends State<TimerPage> {
   Timer? _timer;
  int _secondsElapsed = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... your AppBar code ...
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Timer: $_secondsElapsed seconds'),
            ElevatedButton(
              onPressed: () {
                if (_timer == null || !_timer!.isActive) {
                  _startTimer();
                } else {
                  _stopTimer();
                }
              },
              child: Text(_timer != null && _timer!.isActive ? 'Stop Timer' : 'Start Timer'),
            ),
            ElevatedButton( // Button to navigate to BoardPage
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimerPage()),
                );
              },
              child: const Text('Go to Board'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WordChecker()),
          );
        },
        tooltip: 'Navigate to Board',
        child: const Icon(Icons.navigate_next),
      ),

      
    );
  }
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timer = null; 
    });
  }
}
