import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/pages/homePage.dart';
import 'package:nyobatugasakhir2/pages/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KesanPesanPage extends StatefulWidget {
  final String currentUser;

  KesanPesanPage({required this.currentUser});

  @override
  _KesanPesanPageState createState() => _KesanPesanPageState();
}

class _KesanPesanPageState extends State<KesanPesanPage> {
  String _currentUser = '';
  int _currentIndex = 1;
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
      } else if (index == 2) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(currentUser: widget.currentUser)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesan dan Pesan PAM'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Kesan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Saya jujur berharap kelas ini dapat saya selesaikan dengan mudah karena pak Bagus adalah salah satu dosen favorit saya.'
                'Namun kenyataan menampar saya dengan keras. Pemrograman mobile ternyata jauh lebih ruwet daripada yang saya kira, bahkan lebih dari pemrograman web.'
                'Tugasnya juga sangat banyak terutama untuk projek akhir. Saya jujur tidak keberatan dengan programnya, karena memang membantu dalam memahami tata cara pemrograman mobile'
                'Namun laporan dan dokumen-dokumen lainnya itu yang cukup sulit saya terima. Waktu praktikum RKPL sudah pernah membuat SKPL dan itu sangat panjang.'
                'Saya juga kurang suka dalam membuat dokumen. Belum lagi program ini sudah beberapa kali membuat saya hampir gila.'
                'Pembuatannya berhari-hari dari siang sampai malam (-+ 10 jam/hari) sehingga tugas mata kuliah saya yang lain ada beberapa yang terbengkalai.'
                'Sampai-sampai saya beberapa kali terbesit ide untuk memacu motor saya secepat mungkin di jalan Solo dan menghantam sebuah truk yang terparkir.'
                'Untung saja saya masih dapat menahan ide tersebut untuk tidak terealisasikan.'
                'Ini mungkin juga merupakan kesalahan saya dimana saya baru mulai menyicil tugas 1,5 minggu sebelum deadline.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Pesan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Saya mohon pak, untuk semester-semester berikutnya ketentuannya jangan sebanyak ini.'
                'Halaman ini saya buat saat program sudah hampir selesai (Page ini adalah fungsi terakhir yang saya buat).'
                'dan dokumen-dokumennya bahkan belum saya buat',
                style: TextStyle(fontSize: 16),
              ),
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

