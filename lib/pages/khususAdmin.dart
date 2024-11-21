import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/services/dbHelper.dart';
import 'loginpage.dart';

class KhususAdmin extends StatefulWidget {
  final String currentUser;

  KhususAdmin({required this.currentUser});

  @override
  _KhususAdminState createState() => _KhususAdminState();
}

class _KhususAdminState extends State<KhususAdmin> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  void deleteUser(int id, String username) async {
    if (widget.currentUser == username) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You cannot delete the currently logged-in account.")),
      );
      return;
    }

    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete the account "$username"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteUser(id);
      fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account "$username" deleted successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.currentUser}'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['username']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.currentUser == user['username'])
                  Text('(Current)', style: TextStyle(color: Colors.green)),
                if (widget.currentUser != user['username'])
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(user['id'], user['username']),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
