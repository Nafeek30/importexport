import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:importexport/utility/HorizontalScrollGrid.dart';
import 'package:importexport/views/AccessControlScreen.dart';
import 'package:importexport/views/LoginScreen.dart';
import 'package:importexport/views/AllOrdersScreen.dart';

class UnpaidOrderScreen extends StatefulWidget {
  @override
  UnpaidOrderScreenState createState() => UnpaidOrderScreenState();
}

class UnpaidOrderScreenState extends State<UnpaidOrderScreen> {
  bool loadpage = false;
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    getOwnerInfo();
  }

  @override
  void dispose() {
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
                      builder: (context) => UnpaidOrderScreen(),
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
                "Unpaid Orders",
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
                            padding: EdgeInsets.only(right: 4),
                            child: ElevatedButton(
                              onPressed: () => showAddEditDialog(),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              child: const Text(
                                'Create Order',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllOrdersScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: Text(
                          'All Orders',
                          style: TextStyle(
                            color: Colors.blueAccent.shade200,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    showControls
                        ? Padding(
                            padding: EdgeInsets.only(right: 4),
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
                                backgroundColor: Colors.white,
                                elevation: 5,
                              ),
                              child: Text(
                                'Controls',
                                style: TextStyle(
                                  color: Colors.orangeAccent.shade200,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(right: 4),
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
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.redAccent.shade200,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  const SizedBox(height: 20),
                  Expanded(
                    child: HorizontalScrollGrid(
                      '',
                      '',
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  /// Get the owner info of this workspace to check if [Controls] access should be given
  Future<void> getOwnerInfo() async {
    FirebaseFirestore.instance
        .collection('workspace')
        .doc('CpcQNqCghF0F8GsU3vPq')
        .get()
        .then((workspace) {
      if (FirebaseAuth.instance.currentUser!.email == workspace['owner']) {
        setState(() {
          showControls = true;
          loadpage = true;
        });
      } else {
        setState(() {
          loadpage = true;
        });
      }
    });
  }

  /// Show dialog popup to create orders
  void showAddEditDialog() {
    TextEditingController buyerNameController = TextEditingController();
    TextEditingController productNameController = TextEditingController();
    TextEditingController unitPriceController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController invoiceNumberController = TextEditingController();
    TextEditingController termsOfPaymentController = TextEditingController();
    TextEditingController supplierNameController = TextEditingController();
    TextEditingController letterOfCreditNumberController =
        TextEditingController();
    TextEditingController lcValueController = TextEditingController();
    TextEditingController commissionPercentageController =
        TextEditingController();
    TextEditingController otherAmountController = TextEditingController();
    TextEditingController receivedAmountController = TextEditingController();
    TextEditingController commissionNoteController = TextEditingController();
    TextEditingController commentsController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Future<void> saveOrder() async {
      /// validate form first
      if (!formKey.currentState!.validate()) {
        return;
      }

      int quantity = int.tryParse(quantityController.text) ?? 0;
      double unitPrice = double.tryParse(unitPriceController.text) ?? 0;
      double commissionAmount = quantity * unitPrice;
      int commissionPercentage =
          int.tryParse(commissionPercentageController.text) ?? 0;
      double totalCommission =
          commissionAmount * (commissionPercentage / 100.0).toDouble();
      double otherAmount = double.tryParse(otherAmountController.text) ?? 0;
      double totalAmountToBeReceived = totalCommission + otherAmount;
      double receivedAmount =
          double.tryParse(receivedAmountController.text) ?? 0;
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      var data = {
        'buyerName': buyerNameController.text,
        'productName': productNameController.text,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'invoiceNumber': invoiceNumberController.text,
        'invoiceDate': currentTime,
        'termsOfPayment': termsOfPaymentController.text,
        'supplierName': supplierNameController.text,
        'letterOfCreditNumber': letterOfCreditNumberController.text,
        'letterOfCreditDate': currentTime,
        'lcValue': lcValueController.text,
        'amountForCommission': commissionAmount.toStringAsFixed(2),
        'commissionPercentage': commissionPercentage,
        'totalCommission': totalCommission.toStringAsFixed(2),
        'otherAmount': otherAmount.toStringAsFixed(2),
        'totalAmountToBeReceived': totalAmountToBeReceived.toStringAsFixed(2),
        'receivedAmount': receivedAmount.toStringAsFixed(2),
        'receivedDate': currentTime,
        'commissionNote': commissionNoteController.text,
        'comments': commentsController.text,
        'createdByEmail': FirebaseAuth.instance.currentUser!.email,
        'createdOn': currentTime,
        'status': 'UNPAID',
      };

      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .add(data)
            .then((value) {
          FirebaseFirestore.instance
              .collection('orders')
              .where('createdOn', isEqualTo: currentTime)
              .get()
              .then((docs) async {
            await FirebaseFirestore.instance
                .collection('changeLog')
                .doc(docs.docs[0].id)
                .set({
              'changeText': [
                '${FirebaseAuth.instance.currentUser!.email} created a new order on ${DateTime.fromMillisecondsSinceEpoch(currentTime).month}/${DateTime.fromMillisecondsSinceEpoch(currentTime).day}/${DateTime.fromMillisecondsSinceEpoch(currentTime).year}.'
              ],
            }).then((value) {
              Navigator.of(context).pop();
            });
          });
        });
      } catch (e) {
        print(e.toString());
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Inventory',
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: buyerNameController,
                    decoration: InputDecoration(labelText: 'Buyer Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter buyer name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: unitPriceController,
                    decoration: InputDecoration(labelText: 'Unit Price(\$)'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the dollar value of the unit price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: invoiceNumberController,
                    decoration: InputDecoration(labelText: 'Invoice Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: termsOfPaymentController,
                    decoration: InputDecoration(labelText: 'Terms of Payment'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter terms of payment';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: supplierNameController,
                    decoration: InputDecoration(labelText: 'Supplier Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter supplier name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: letterOfCreditNumberController,
                    decoration:
                        InputDecoration(labelText: 'Letter of Credit Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter LOC number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lcValueController,
                    decoration: InputDecoration(labelText: 'LC Value'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter LC value';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: commissionPercentageController,
                    decoration:
                        InputDecoration(labelText: 'Commission Percentage(%)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter commission percentage';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: otherAmountController,
                    decoration: InputDecoration(labelText: 'Other Amount (\$)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter other amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: receivedAmountController,
                    decoration: InputDecoration(labelText: 'Received Amount (\$)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter received amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: commissionNoteController,
                    decoration: InputDecoration(labelText: 'Commission Note'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter commission note';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: commentsController,
                    decoration: InputDecoration(labelText: 'Comments'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          commentsController.text = '';
                        });
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Save',
              ),
              onPressed: () {
                saveOrder();
              },
            ),
          ],
        );
      },
    );
  }
}
