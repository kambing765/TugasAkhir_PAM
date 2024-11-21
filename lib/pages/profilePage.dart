import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/pages/homePage.dart';
import 'package:nyobatugasakhir2/pages/kesanPesanPage.dart';
import 'package:nyobatugasakhir2/services/dbHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';

class ProfilePage extends StatefulWidget {
  final String currentUser;

  ProfilePage({required this.currentUser});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _currentUser = '';
  int _currentIndex = 2;
  String? currentUser;

  void _navigateTo(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(currentUser: widget.currentUser)),
          (route) => false, // Menghapus semua rute sebelumnya
        );
      } else if (index == 1) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => KesanPesanPage(currentUser: widget.currentUser)),
          (route) => false, // Menghapus semua rute sebelumnya
        );
      }
    }
  }


  @override
  void initState() {
    super.initState();
    loadSession();
  }

  /// Memuat sesi pengguna dari SharedPreferences
  void loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser') ?? widget.currentUser;
    });
  }




  void deleteAccount() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[900],
        title: Text('Delete Account'),
        content: Text('Anda yakin ingin menghapus akun? Akun anda akan terhapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Hapus akun dari database
      final users = await DatabaseHelper.instance.getAllUsers();
      final user = users.firstWhere((u) => u['username'] == widget.currentUser);

      await DatabaseHelper.instance.deleteUser(user['id']);

      // Hapus sesi
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');

      // Kembali ke halaman login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your account has been deleted.')),
      );
    }
  }

  void logout() async {

    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Yakin ingin Logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil Logout')),
      );
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: deleteAccount,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center( 
          child: Padding( 
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/DSC_0052.jpg',
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20,),
              Text(
                'Nama : Nauval Ghaina Mochamad Hanif',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'NIM : 124220069',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Tempat tanggal lahir: Pekanbaru, 13 Juli 2004',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Username: ${widget.currentUser}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
            ],
          ),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
