import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/pages/driverDetailPage.dart';
import 'package:nyobatugasakhir2/pages/homePage.dart';
import 'package:nyobatugasakhir2/pages/kesanPesanPage.dart';
import 'package:nyobatugasakhir2/pages/profilePage.dart';
import 'package:nyobatugasakhir2/services/f1APIService.dart';

class F1DriverList extends StatefulWidget {
  final String currentUser;

  F1DriverList({required this.currentUser});

  @override
  _F1DriverListState createState() => _F1DriverListState();
}

class _F1DriverListState extends State<F1DriverList> {
  int _currentIndex = 1;

  void _navigateTo(int index) {
    if (index != _currentIndex) {
      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(currentUser: widget.currentUser)),
          (route) => false,
        );
      }  else if (index == 2) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(currentUser: widget.currentUser)),
          (route) => false, 
        );
      }
    } else if (index == 1) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => KesanPesanPage(currentUser: widget.currentUser)),
          (route) => false, // Menghapus semua rute sebelumnya
        );
      }
  }

  final F1APIService apiService = F1APIService();
  List<Map<String, dynamic>> drivers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    try {
      final fetchedDrivers = await apiService.fetchDriversRaw();
      setState(() {
        // Filter drivers without headshot and remove duplicates
        drivers = _removeDuplicates(fetchedDrivers
            .where((driver) => (driver['headshot_url'] ?? '').isNotEmpty)
            .toList());

        // Sort drivers by driver_number
        drivers.sort((a, b) => (a['driver_number'] ?? 0).compareTo(b['driver_number'] ?? 0));

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching drivers: $e');
    }
  }

  List<Map<String, dynamic>> _removeDuplicates(List<Map<String, dynamic>> fetchedDrivers) {
    final seenNumbers = <int>{};
    return fetchedDrivers.where((driver) {
      final driverNumber = driver['driver_number'] ?? 0;
      final isUnique = !seenNumbers.contains(driverNumber);
      if (isUnique) {
        seenNumbers.add(driverNumber);
      }
      return isUnique;
    }).toList();
  }

  Color _parseColour(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return Colors.grey;
    final color = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$color', radix: 16));
  }

  Widget buildTeamLogo(String? teamName) {
    final normalizedTeamName = (teamName ?? '').toLowerCase().replaceAll(' ', '');
     if (normalizedTeamName == 'mclaren' || normalizedTeamName == 'alfaromeo') {
      return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white, // White background
          border: Border.all(color: Colors.white, width: 4), // White border
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Image.asset(
          'images/$normalizedTeamName.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.image_not_supported,
              size: 30,
              color: Colors.grey,
            );
          },
        ),
      );
    } else {
      return Image.asset(
        'images/$normalizedTeamName.png',
        width: 70,
        height: 70,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.white,
          );
        },
      );
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
            Text('Driver List'),
          ],
        )
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : drivers.isEmpty
              ? Center(child: Text('No drivers found.'))
              : ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverDetailsPage(driver: driver),
                          ),
                        );
                      },
                      child:Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4.0,
                        color: _parseColour(driver['team_colour']), // Set background color
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Driver Headshot
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  driver['headshot_url'] ?? '',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image_not_supported,
                                      size: 80,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 16.0),
                              // Driver Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${driver['driver_number'] ?? ''}. ${driver['broadcast_name'] ?? 'Unknown'}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    
                                    Text(
                                      'Country: ${driver['country_code'] ?? 'Unknown'}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.0),
                              // Team Logo
                              buildTeamLogo(driver['team_name']),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
