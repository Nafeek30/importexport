import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:importexport/utility/HorizontalScrollGrid.dart';
import 'package:importexport/views/UnpaidOrderScreen.dart';

class AllOrdersScreen extends StatefulWidget {
  @override
  AllOrdersScreenState createState() => AllOrdersScreenState();
}

class AllOrdersScreenState extends State<AllOrdersScreen> {
  TextEditingController? buyerController = TextEditingController(text: '');
  TextEditingController? sellerController = TextEditingController(text: '');
  bool loadOrders = false;
  String buyerName = '';
  String sellerName = '';

  @override
  void initState() {
    super.initState();
    getOwnerInfo().then((value) => searchOrders());

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
                builder: (context) => UnpaidOrderScreen(),
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
            loadOrders
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
              labelText: 'Search by Supplier Name',
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
            searchOrders();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal),
          ),
          child: const Text('Search', style: TextStyle(color: Colors.white,),),
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

  /// When search button is clicked load the orders that match the search using [HorizontalScrollGrid] class
  void searchOrders() {
    setState(() {
      loadOrders = false;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        buyerName = buyerController!.text;
        sellerName = sellerController!.text;
        loadOrders = true;
      });
    });
  }
}
