import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:importexport/views/UnpaidOrderScreen.dart';
import 'package:pdf/pdf.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final List selectedOrders;
  const CreateInvoiceScreen({super.key, required this.selectedOrders});

  @override
  CreateInvoiceScreenState createState() => CreateInvoiceScreenState();
}

class CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  List invoiceDocuments = [];
  @override
  void initState() {
    super.initState();
    loadInvoiceData();
    invoiceDocuments.clear();
  }

  @override
  void dispose() {
    invoiceDocuments.clear();
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
        title: Text('Invoice'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where(FieldPath.documentId, whereIn: widget.selectedOrders)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  for (var i in snapshot.data!.docs)
                    Container(
                      child: Text(i.get('buyerName')),
                    )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> loadInvoiceData() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .where(FieldPath.documentId, whereIn: widget.selectedOrders)
        .get()
        .then((snapshots) {
      setState(() {
        invoiceDocuments = snapshots.docs;
      });
    });
  }
}
