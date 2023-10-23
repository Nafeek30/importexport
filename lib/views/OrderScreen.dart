import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:importexport/utility/HorizontalScrollGrid.dart';
import 'package:importexport/views/AccessControlScreen.dart';
import 'package:importexport/views/LoginScreen.dart';

class OrderScreen extends StatefulWidget {
  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  TextEditingController? searchController;
  bool loadpage = false;
  bool showControls = false;
  String? filterStatus;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getOwnerInfo();
  }

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadpage
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal[400],
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(),
                    ),
                  );
                },
                child: Container(
                  child: Center(
                    child: Text(
                      'Home',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              title: const Text(
                "Inventory",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    showControls
                        ? Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccessControlScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade200,
                                elevation: 5,
                              ),
                              child: Text('Controls'),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade200,
                          elevation: 5,
                        ),
                        child: Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSearchAndFilter(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: HorizontalScrollGrid(
                        searchController!, filterStatus, '', ''),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search by Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              fillColor: Colors.teal[50],
              filled: true,
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.teal[100]!),
              ),
              child: DropdownButton<String>(
                value: filterStatus,
                hint: const Text("Filter by pay status"),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    filterStatus = newValue;
                  });
                },
                items: ["PAID", "UNPAID"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal),
          ),
          child: const Text('Create Order'),
        ),
      ],
    );
  }

  Future<void> getOwnerInfo() async {
    FirebaseFirestore.instance
        .collection('workspace')
        .doc('CpcQNqCghF0F8GsU3vPq')
        .get()
        .then((workspace) {
      if (FirebaseAuth.instance.currentUser!.email == workspace['owner']) {
        setState(() {
          showControls = true;
        });
      }
      setState(() {
        loadpage = true;
      });
    });
  }
}
