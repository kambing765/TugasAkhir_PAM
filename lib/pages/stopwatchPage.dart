import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  int _secondsElapsed = 0;
  int _millisecondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _secondsElapsed = _stopwatch.elapsed.inSeconds;
        _millisecondsElapsed = _stopwatch.elapsed.inMilliseconds % 1000;

        // Check if a minute has passed
        if (_secondsElapsed % 10 == 0 && _secondsElapsed > 0) {
          _showMinuteNotification(_secondsElapsed ~/ 10);
        }
      });
    });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer.cancel();
  }

  void _resetStopwatch() {
    _stopStopwatch();
    setState(() {
      _stopwatch.reset();
      _secondsElapsed = 0;
      _millisecondsElapsed = 0;
    });
  }

  Future<void> _showMinuteNotification(int minute) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: minute, // Unique ID
        channelKey: 'Basic_channel', // Initialized channel
        title: 'Stopwatch Update',
        body: 'Stopwatch has reached $minute minute(s)!',
        notificationLayout: NotificationLayout.Default, // Simple layout
      ),
    );
  }

  @override
  void dispose() {
    if (_stopwatch.isRunning) {
      _stopStopwatch();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(_secondsElapsed ~/ 3600).toString().padLeft(2, '0')}:'
            '${((_secondsElapsed % 3600) ~/ 60).toString().padLeft(2, '0')}:'
            '${(_secondsElapsed % 60).toString().padLeft(2, '0')}:'
            '${(_millisecondsElapsed ~/ 10).toString().padLeft(2, '0')}', // Showing milliseconds
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: _startStopwatch,
                child: Text('Start'),
              ),
              SizedBox(width: 10),
              ElevatedButton(                
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: _stopStopwatch,
                child: Text('Stop'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _resetStopwatch,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
