import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/pages/driverList.dart';
import 'package:nyobatugasakhir2/pages/kesanPesanPage.dart';
import 'package:nyobatugasakhir2/pages/loginPage.dart';
import 'package:nyobatugasakhir2/pages/stopwatchPage.dart';
import 'package:nyobatugasakhir2/pages/timeConvertPage.dart';
import 'package:nyobatugasakhir2/pages/tukarMataUang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profilePage.dart';
import 'khususAdmin.dart';

class HomePage extends StatefulWidget {
  final String currentUser;


  HomePage({required this.currentUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String? currentUser;

  void _navigateTo(int index) {
    if (index != _currentIndex) {
      if (index == 1) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => KesanPesanPage(currentUser: widget.currentUser)),
          (route) => false,
        );
      } else if (index == 2) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(currentUser: widget.currentUser)),
          (route) => false, 
        );
      }
    }
  }

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if (!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();  
      }
    });
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    if (savedUsername == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        currentUser = savedUsername;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/f1.png',
              width: 70,
              fit: BoxFit.contain,
            ),
            SizedBox( width: 10,),
            Text(_currentIndex == 0 ? 'Home' : 'Profile'),
          ],
        )
        
      ),
      body: Center(
        child: Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.currentUser == 'admin')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(200, 40)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KhususAdmin(currentUser: widget.currentUser)),
                  );
                },
                child: Text('Admin Panel'),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(200, 40)
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => F1DriverList(currentUser: widget.currentUser)),
                );
              },
              child: Text('F1 Driver List'),
            ),
            SizedBox(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  minimumSize: Size(200, 40)
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TukarMataUangPage()),
                );
              },
              child: Text('Tukar mata uang'),
            ),
            SizedBox(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  minimumSize: Size(200, 40)
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeConvertPage()),
                );
              },
              child: Text('Konversi waktu'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(200, 40)
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StopwatchPage()),
                );
              },
              child: Text('Stopwatch'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Saran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
