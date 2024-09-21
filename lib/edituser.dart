import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateUser extends StatefulWidget {
  final String userId;
  final String userFirstname;
  final String userLastname;
  final String userAge;
  final String userAddress;
  final String userUsername;
  final String userPassword;
  final String userLevel;

  const UpdateUser({
    required this.userId,
    required this.userFirstname,
    required this.userLastname,
    required this.userAge,
    required this.userAddress,
    required this.userUsername,
    required this.userPassword,
    required this.userLevel,
  });

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController(text: widget.userFirstname);
    _lastnameController = TextEditingController(text: widget.userLastname);
    _ageController = TextEditingController(text: widget.userAge);
    _addressController = TextEditingController(text: widget.userAddress);
    _usernameController = TextEditingController(text: widget.userUsername);
    _passwordController = TextEditingController(text: widget.userPassword);
    _selectedLevel = widget.userLevel;
  }

  Future<void> _updateUser() async {
    final url = "http://localhost/flutter/api/update_user.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'user_id': widget.userId,
          'user_firstname': _firstnameController.text,
          'user_lastname': _lastnameController.text,
          'user_age': int.tryParse(_ageController.text) ?? 0,
          'user_address': _addressController.text,
          'user_username': _usernameController.text,
          'user_password': _passwordController.text,
          'user_level': _selectedLevel,
        }),
      );

      final result = jsonDecode(response.body);

      if (result['success']) {
        Navigator.pop(
            context, true); // Return to previous screen and indicate success
      } else {
        _showError(result['message']);
      }
    } catch (e) {
      _showError("Error: $e");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstnameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastnameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: InputDecoration(labelText: 'Level'),
              items: ['1', '2'].map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLevel = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _updateUser();
                    },
                    child: Text('Update')),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
