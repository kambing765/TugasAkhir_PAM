class Driver {
  final String broadcastName;
  final int driverNumber;
  final String headshotUrl;
  final String teamColour;
  final String teamName;

  Driver({
    required this.broadcastName,
    required this.driverNumber,
    required this.headshotUrl,
    required this.teamColour,
    required this.teamName,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      broadcastName: json['broadcast_name'] ?? 'Unknown',
      driverNumber: json['driver_number'] ?? 0,
      headshotUrl: json['headshot_url'] ?? '',
      teamColour: json['team_colour'] ?? '#FFFFFF', // Default to white
      teamName: json['team_name'] ?? 'Unknown',
    );
  }
}

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}
