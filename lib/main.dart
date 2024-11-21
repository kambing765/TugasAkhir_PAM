import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/pages/loginPage.dart';

void main() {
  AwesomeNotifications().initialize(
    null, 
    [
      NotificationChannel(
        channelKey: 'Basic_channel', 
        channelName: 'Stopwatch notifications', 
        channelDescription: 'Notifikasi untuk tes basic'
      ),
    ],
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white), // Default label color
          floatingLabelStyle: TextStyle(color: Colors.blue), // Warna label saat fokus
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue, // Warna garis saat fokus
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red, // Warna garis saat error
            ),
          ),
        ),        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(203, 176, 176, 176),
            foregroundColor: Colors.white,
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueGrey[300]
          )
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      title: 'F1 driver app',
      home: LoginPage(),
    );
  }
}
