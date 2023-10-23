import 'package:flutter/material.dart';
import 'package:importexport/views/AccessTab.dart';
import 'package:importexport/views/BanUnbanTab.dart';
import 'package:importexport/views/PermissionsTab.dart';

class AccessControlScreen extends StatefulWidget {
  @override
  AccessControlScreenState createState() => AccessControlScreenState();
}

class AccessControlScreenState extends State<AccessControlScreen> {
  // This variable will hold the current tab's index
  int currentTabIndex = 0;

  // This function could be called to update the state when necessary
  void _updateTabIndex(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[400],
          title: Text('Access Control'),
          bottom: TabBar(
            onTap: (index) {
              // Update the current tab's index when a tab is tapped
              _updateTabIndex(index);
            },
            tabs: [
              Tab(text: 'Access'),
              Tab(text: 'Ban/Unban'),
              Tab(text: 'Permissions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AccessTab(),
            BanUnbanTab(),
            PermissionsTab(),
          ],
        ),
      ),
    );
  }
}
