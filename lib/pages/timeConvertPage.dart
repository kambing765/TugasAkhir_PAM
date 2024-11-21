import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TimeConvertPage extends StatefulWidget {
  @override
  _TimeConvertPageState createState() => _TimeConvertPageState();
}

class _TimeConvertPageState extends State<TimeConvertPage> {
  final List<String> timeZones = [
    'WIB (UTC+7)',
    'WITA (UTC+8)',
    'WIT (UTC+9)',
    'London (UTC+0)',
    'Sydney (UTC+11)'
  ];

  String selectedTimeZone = 'WIB (UTC+7)';
  late Timer timer;
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Update time every second
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  DateTime convertToSelectedTimeZone(DateTime time) {
    int offset = 0;

    switch (selectedTimeZone) {
      case 'WIB (UTC+7)':
        offset = 7;
        break;
      case 'WITA (UTC+8)':
        offset = 8;
        break;
      case 'WIT (UTC+9)':
        offset = 9;
        break;
      case 'London (UTC+0)':
        offset = 0;
        break;
      case 'Sydney (UTC+11)':
        offset = 11;
        break;
    }

    return time.toUtc().add(Duration(hours: offset));
  }

  @override
  Widget build(BuildContext context) {
    DateTime convertedTime = convertToSelectedTimeZone(currentTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Local Time',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Konversi ke',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                isDense: true,
                //isExpanded: true,
                value: selectedTimeZone,
                items: timeZones.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value),),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeZone = newValue!;
                  });
                },
              ),            
              SizedBox(height: 16),
              Text(
                'Waktu Terkonversi',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(convertedTime),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
        
      ),
    );
  }
}