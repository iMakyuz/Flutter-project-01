import 'package:flutter/material.dart';
import 'package:login/adduser.dart';
import 'package:login/deleteuser.dart';
import 'package:login/edituser.dart';

class UserListScreen extends StatefulWidget {
  final List<dynamic> userData;

  UserListScreen({required this.userData});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> filteredUserData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUserData = widget.userData;
    _searchController.addListener(() {
      _filterUsers();
    });
  }

  void _filterUsers() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      filteredUserData = widget.userData
          .where((user) =>
              user['user_firstname'].toLowerCase().contains(query) ||
              user['user_lastname'].toLowerCase().contains(query) ||
              user['user_username'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text(
                    'First Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text('Last Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Age',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Address',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Username',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Password',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Level',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: filteredUserData.map<DataRow>((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item['user_firstname'] ?? '')),
                      DataCell(Text(item['user_lastname'] ?? '')),
                      DataCell(Text((item['user_age'] ?? 0).toString())),
                      DataCell(Text(item['user_address'] ?? '')),
                      DataCell(Text(item['user_username'] ?? '')),
                      DataCell(Text(item['user_password'] ?? '')),
                      DataCell(Text((item['user_level'] ?? 0).toString())),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateUser(
                                            userId: item['user_id'].toString(),
                                            userFirstname:
                                                item['user_firstname']
                                                    .toString(),
                                            userLastname: item['user_lastname']
                                                .toString(),
                                            userAge:
                                                item['user_age'].toString(),
                                            userAddress:
                                                item['user_address'].toString(),
                                            userUsername: item['user_username']
                                                .toString(),
                                            userPassword: item['user_password']
                                                .toString(),
                                            userLevel:
                                                item['user_level'].toString(),
                                          )),
                                );
                              },
                              child: Text("Update"),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeleteUser(
                                        userId: item['user_id'].toString()),
                                  ),
                                );
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddUserScreen(userLevel: 2)),
                  );
                },
                child: Text('Add User'),
              )
            ],
          )
        ],
      ),
    );
  }
}
