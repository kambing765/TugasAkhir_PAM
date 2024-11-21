import 'package:flutter/material.dart';

class DriverDetailsPage extends StatelessWidget {
  final Map<String, dynamic> driver;

  const DriverDetailsPage({Key? key, required this.driver}) : super(key: key);

  /// Helper function to parse the team color
  Color _parseColour(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return Colors.grey;
    final color = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$color', radix: 16));
  }

  /// Widget to display the team logo
  Widget buildTeamLogo(String? teamName) {
    final normalizedTeamName = (teamName ?? '').toLowerCase().replaceAll(' ', '');
    if (normalizedTeamName == 'mclaren' || normalizedTeamName == 'alfaromeo') {
      if (normalizedTeamName == 'mclaren') {
        return Opacity(
          opacity: 0.5,
          child: Container(
            width: 300,
            height: 300,
            child: Image.asset(
              'images/${normalizedTeamName}white.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 30,
                  color: Colors.grey,
                );
              },
            ),
          ),
        );
      } else {
        return Opacity(
          opacity: 0.5,
          child: Container(
            width: 300,
            height: 300,
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
          ),
        );
      }
    } else {
      return Opacity(
        opacity: 0.5,
        child: Container(
          width: 300,
          height: 300,
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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        backgroundColor: _parseColour(driver['team_colour']),
        title: Text(driver['broadcast_name'] ?? 'Driver'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Headshot with Team Logo and Background Color
            Container(
              width: double.infinity, // Fills the width of the screen
              color: _parseColour(driver['team_colour']), // Background color
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Stack(
                children: [
                  // Team Logo in the Top Right Corner
                  if (driver['team_name'] != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: buildTeamLogo(driver['team_name']),
                    ),
                  // Headshot in the Center
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        driver['headshot_url'] ?? '',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 200,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Driver Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: driver['full_name'] ?? 'Unknown',
                      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  ${driver['country_code']}',
                            style: TextStyle(fontSize: 14.0)
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 8.0),
                  Text(
                    'Number: ${driver['driver_number'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Team: ${driver['team_name'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
