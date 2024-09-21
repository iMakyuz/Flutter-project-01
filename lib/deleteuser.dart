import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteUser extends StatefulWidget {
  final String userId;

  const DeleteUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  Future<void> _deleteUser() async {
    final url = "http://localhost/flutter/api/delete_user.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id': widget.userId.toString()}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (result['success']) {
          Navigator.of(context).pop();
          _showDialog("Success", "User deleted successfully.");
        } else {
          _showDialog("Error", result['message']);
        }
      } else {
        _showDialog("Error", "Failed to delete user.");
      }
    } catch (e) {
      _showDialog("Error", "Error: $e");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete This User"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showConfirmationDialog,
          child: Text('Delete This User'),
        ),
      ),
    );
  }
}
