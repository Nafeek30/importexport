import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:importexport/utility/HorizontalScrollGrid.dart';
import 'package:importexport/views/AccessControlScreen.dart';
import 'package:importexport/views/LoginScreen.dart';
import 'package:importexport/views/OrderScreen.dart';

class PaidOrdersScreen extends StatefulWidget {
  @override
  PaidOrdersScreenState createState() => PaidOrdersScreenState();
}

class PaidOrdersScreenState extends State<PaidOrdersScreen> {
  TextEditingController? buyerController = TextEditingController(text: '');
  TextEditingController? sellerController = TextEditingController(text: '');
  bool loadpage = false;
  int counter = 0;
  String buyerName = '';
  String sellerName = '';

  @override
  void initState() {
    super.initState();
    getOwnerInfo();
  }

  @override
  void dispose() {
    buyerController?.dispose();
    sellerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderScreen(),
              ),
            );
          },
        ),
        title: const Text(
          "Paid Orders",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSearchAndFilter(),
            const SizedBox(height: 20),
            counter > 0
                ? Expanded(
                    child: HorizontalScrollGrid(
                      buyerName,
                      sellerName,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: buyerController,
            decoration: InputDecoration(
              labelText: 'Search by Buyer Name',
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
          child: TextField(
            controller: sellerController,
            decoration: InputDecoration(
              labelText: 'Search by Seller Name',
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
        ElevatedButton(
          onPressed: () {
            // Function to search based on buyer and seller names
            // setFalse();
            reloadOrders();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal),
          ),
          child: const Text('Search'),
        ),
      ],
    );
  }

  /// Get the owner info of this workspace to check if [Controls] access should be given
  Future<void> getOwnerInfo() async {
    FirebaseFirestore.instance
        .collection('workspace')
        .doc('CpcQNqCghF0F8GsU3vPq')
        .get()
        .then((workspace) {
      if (FirebaseAuth.instance.currentUser!.email == workspace['owner']) {}
    });
  }

  void setFalse() {
    setState(() {
      buyerName = buyerController!.text;
      sellerName = sellerController!.text;
      loadpage = false;
    });
  }

  void reloadOrders() {
    setState(() {
      buyerName = buyerController!.text;
      sellerName = sellerController!.text;
      counter++;
    });
  }
}
