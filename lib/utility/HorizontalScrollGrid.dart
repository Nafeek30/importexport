import 'dart:convert';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:importexport/views/BuyerScreen.dart';
import 'package:importexport/views/CreateInvoiceScreen.dart';
import 'package:importexport/views/SellerScreen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;

  CustomRow(this.itemName, this.itemPrice, this.amount, this.total);
}

class HorizontalScrollGrid extends StatefulWidget {
  final String? buyerName;
  final String? sellerName;
  final TextEditingController searchController;
  final String? filterStatus;

  HorizontalScrollGrid(
      this.searchController, this.filterStatus, this.buyerName, this.sellerName,
      {super.key});

  @override
  HorizontalScrollGridState createState() => HorizontalScrollGridState();
}

class HorizontalScrollGridState extends State<HorizontalScrollGrid> {
  late List<Map<String, dynamic>> items = [];
  late List<Map<String, dynamic>> filteredItems;
  late List<bool> selectedRows;
  List selectedOrders = [];
  bool showEdit = false;
  late List stream;
  bool doneLoading = false;
  List changeLogs = [];

  @override
  void initState() {
    super.initState();
    selectedOrders.clear();
    fetchData().then((value) {
      getUserPermission().then((value) {
        setState(() {
          doneLoading = true;
        });
      });
    });
    // getUserPermission();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = items.where((item) {
      if (widget.searchController.text.isNotEmpty &&
          !item['Buyer Name']
              .toLowerCase()
              .contains(widget.searchController.text.toLowerCase())) {
        return false;
      }
      if (widget.filterStatus == "PAID" && item['Status']! == 'UNPAID') {
        return false;
      } else if (widget.filterStatus == "UNPAID" && item['Status']! == 'PAID') {
        return false;
      }
      return true;
    }).toList();

    return doneLoading
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        initiateInvoice();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                      ),
                      child: const Text('Create Invoice'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.teal.shade50),
                    dividerThickness: 1,
                    columns: [
                      _customDataColumn('Select'),
                      _customDataColumn('Edit'),
                      _customDataColumn('Change Log'),
                      _customDataColumn('Index'),
                      _customDataColumn('Status'),
                      _customDataColumn('Buyer name'),
                      _customDataColumn('Products'),
                      _customDataColumn('Unit Price'),
                      _customDataColumn('Quantity'),
                      _customDataColumn('Invoice Number'),
                      _customDataColumn('Invoice Date'),
                      _customDataColumn('Terms of Payment'),
                      _customDataColumn('Supplier name'),
                      _customDataColumn('Letter of Credit Number'),
                      _customDataColumn('Letter of Credit Date'),
                      _customDataColumn('LC Value'),
                      _customDataColumn('Amount for Commission'),
                      _customDataColumn('Commission %'),
                      _customDataColumn('Total Commission'),
                      _customDataColumn('Other Amount'),
                      _customDataColumn('Total Amount to be Received'),
                      _customDataColumn('Received Amount'),
                      _customDataColumn('Received Date'),
                      _customDataColumn('Commission Note'),
                      _customDataColumn('Comments'),
                    ],
                    rows: filteredItems.map((item) {
                      int index = items.indexOf(item);
                      return DataRow(
                        selected: selectedRows[index],
                        color: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.shade100),
                        cells: [
                          _customDataCellWithWidget(
                            Checkbox(
                              value: selectedRows[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedRows[index] = value!;

                                  /// if an item is added then remove it; otherwise add it
                                  if (selectedOrders
                                      .contains(items[index]['docID'])) {
                                    selectedOrders.remove(items[index]);
                                  } else {
                                    selectedOrders.add(items[index]);
                                  }
                                });
                              },
                              activeColor: Colors.teal,
                            ),
                          ),
                          showEdit
                              ? _customDataCellWithWidget(
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.teal),
                                    onPressed: () => showAddEditDialog(item),
                                  ),
                                )
                              : _customDataCellWithWidget(Container()),
                          _customDataCellWithWidget(
                            IconButton(
                              icon: Icon(Icons.description,
                                  color: Colors.blueAccent.shade100),
                              onPressed: () => showChangeLogDialog(item),
                            ),
                          ),
                          _customDataCell(item['Index'], false, false),
                          _customDataCell(item['Status'], false, false),
                          _customDataCell(item['Buyer name'], true, false),
                          _customDataCell(item['Products'], false, false),
                          _customDataCell(
                              '\$${item['Unit Price']}', false, false),
                          _customDataCell('${item['Quantity']}', false, false),
                          _customDataCell(
                              '${item['Invoice Number']}', false, false),
                          _customDataCell(
                              '${item['Invoice Date']}', false, false),
                          _customDataCell(
                              item['Terms of Payment'], false, false),
                          _customDataCell(item['Supplier name'], false, true),
                          _customDataCell('${item['Letter of Credit Number']}',
                              false, false),
                          _customDataCell(
                              '${item['Letter of Credit Date']}', false, false),
                          _customDataCell('${item['LC Value']}', false, false),
                          _customDataCell('\$${item['Amount for Commission']}',
                              false, false),
                          _customDataCell(
                              '${item['Commission %']}%', false, false),
                          _customDataCell(
                              '\$${item['Total Commission']}', false, false),
                          _customDataCell(
                              '\$${item['Other Amount']}', false, false),
                          _customDataCell(
                              '\$${item['Total Amount to be Received']}',
                              false,
                              false),
                          _customDataCell(
                              '\$${item['Received Amount']}', false, false),
                          _customDataCell(
                              '${item['Received Date']}', false, false),
                          _customDataCell(
                              item['Commission Note'], false, false),
                          _customDataCell(item['Comments'], false, false),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

  /// Get all Firestore orders
  Future<void> fetchData() async {
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('buyerName')
        .get()
        .then((snapshots) {
      setState(() {
        stream = snapshots.docs;
        items = List.generate(stream.length, (index) {
          return {
            'Index': '${index + 1}',
            'Buyer name': widget.buyerName == ''
                ? stream[index].data()['buyerName']
                : widget.buyerName,
            'Products': stream[index].data()['productName'],
            'Unit Price': stream[index].data()['unitPrice'],
            'Quantity': stream[index].data()['quantity'],
            'Invoice Number': stream[index].data()['invoiceNumber'],
            'Invoice Date':
                '${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['invoiceDate']).month}/${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['invoiceDate']).day}/${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['invoiceDate']).year}',
            'Terms of Payment': stream[index].data()['termsOfPayment'],
            'Supplier name': widget.sellerName == ''
                ? stream[index].data()['supplierName']
                : widget.sellerName,
            'Letter of Credit Number':
                stream[index].data()['letterOfCreditNumber'],
            'Letter of Credit Date':
                '${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['letterOfCreditDate']).month}/${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['letterOfCreditDate']).day}/${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['letterOfCreditDate']).year}',
            'LC Value': stream[index].data()['lcValue'],
            'Amount for Commission':
                stream[index].data()['amountForCommission'],
            'Commission %': stream[index].data()['commissionPercentage'],
            'Total Commission': stream[index].data()['totalCommission'],
            'Other Amount': stream[index].data()['otherAmount'],
            'Total Amount to be Received':
                stream[index].data()['totalAmountToBeReceived'],
            'Received Amount': stream[index].data()['receivedAmount'],
            'Received Date':
                '${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['receivedDate']).month}/${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['receivedDate']).day}/${DateTime.fromMillisecondsSinceEpoch(stream[index].data()['receivedDate']).year}',
            'Commission Note': stream[index].data()['commissionNote'],
            'Comments': stream[index].data()['comments'],
            'Status': stream[index].data()['status'],
            'createdByEmail': stream[index].data()['createdByEmail'],
            'createdOn': stream[index].data()['createdOn'],
            'docID': stream[index].id,
          };
        });
        selectedRows = List.generate(items.length, (index) => false);
      });
    });
  }

  /// Permission on whether current user can edit orders or not
  Future<void> getUserPermission() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .first
        .then((snap) {
      setState(() {
        showEdit = snap.docs[0].data()['writePermission'];
      });
    });
  }

  /// Show dialog popup to create orders
  void showAddEditDialog(Map<String, dynamic> item) {
    TextEditingController buyerNameController =
        TextEditingController(text: item['Buyer name']);
    TextEditingController productNameController =
        TextEditingController(text: item['Products']);
    TextEditingController unitPriceController =
        TextEditingController(text: item['Unit Price'].toString());
    TextEditingController quantityController =
        TextEditingController(text: item['Quantity'].toString());
    TextEditingController invoiceNumberController =
        TextEditingController(text: item['Invoice Number'].toString());
    TextEditingController termsOfPaymentController =
        TextEditingController(text: item['Terms of Payment']);
    TextEditingController supplierNameController =
        TextEditingController(text: item['Supplier name']);
    TextEditingController letterOfCreditNumberController =
        TextEditingController(text: item['Letter of Credit Number'].toString());
    TextEditingController lcValueController =
        TextEditingController(text: item['LC Value'].toString());
    TextEditingController commissionPercentageController =
        TextEditingController(text: item['Commission %'].toString());
    TextEditingController otherAmountController =
        TextEditingController(text: item['Other Amount'].toString());
    TextEditingController receivedAmountController =
        TextEditingController(text: item['Received Amount'].toString());
    TextEditingController commissionNoteController =
        TextEditingController(text: item['Commission Note']);
    TextEditingController commentsController =
        TextEditingController(text: item['Comments']);
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
        'termsOfPayment': termsOfPaymentController.text,
        'supplierName': supplierNameController.text,
        'letterOfCreditNumber': letterOfCreditNumberController.text,
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
        'status': 'UNPAID',
      };

      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(item['docID'])
            .update(data)
            .then((value) async {
          var changeLogData = {
            'changeText': FieldValue.arrayUnion([
              '${FirebaseAuth.instance.currentUser!.email} updated the order on ${DateTime.fromMillisecondsSinceEpoch(currentTime).month}/${DateTime.fromMillisecondsSinceEpoch(currentTime).day}/${DateTime.fromMillisecondsSinceEpoch(currentTime).year}.'
            ]),
          };
          await FirebaseFirestore.instance
              .collection('changeLog')
              .doc(item['docID'])
              .update(changeLogData)
              .then((value) {
            Navigator.of(context).pop();
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
                    decoration: InputDecoration(labelText: 'Unit Price'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter unit price';
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
                        InputDecoration(labelText: 'Commission Percentage'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter commission percentage';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: otherAmountController,
                    decoration: InputDecoration(labelText: 'Other Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter other amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: receivedAmountController,
                    decoration: InputDecoration(labelText: 'Received Amount'),
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

  void showChangeLogDialog(Map<String, dynamic> item) {
    fetchChangeLog(item['docID']).then((value) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              print(changeLogs.length);
              return AlertDialog(
                title: Text('Change Log'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true, // Use only as much space as needed
                    itemCount: changeLogs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.circle,
                          color: Colors.blueGrey,
                        ),
                        title: Text(changeLogs[index]),
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () =>
                        Navigator.of(context).pop(), // Close the dialog
                  ),
                ],
              );
            });
          });
    });
  }

  /// Function to fetch changelog from Firestore
  Future<void> fetchChangeLog(String docID) async {
    await FirebaseFirestore.instance
        .collection('changeLog')
        .doc(docID)
        .get()
        .then((log) {
      log.data()!.forEach((key, value) {
        setState(() {
          changeLogs = value;
        });
        print(changeLogs.toString());
      });
    });
  }

  DataColumn _customDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  DataCell _customDataCell(String? data, bool isBuyer, bool isSeller) {
    return DataCell(
      GestureDetector(
        onTap: () {
          if (isBuyer) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyerScreen(
                  buyerName: data!,
                ),
              ),
            );
          } else if (isSeller) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellerScreen(
                  sellerName: data!,
                ),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.teal[100]!, width: 0.5),
            ),
          ),
          child: Text(
            data ?? 'N/A',
            style: TextStyle(
              color: isBuyer
                  ? Colors.blueAccent
                  : isSeller
                      ? Colors.blueAccent
                      : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  DataCell _customDataCellWithWidget(Widget widget) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.teal[100]!, width: 0.5),
          ),
        ),
        child: widget,
      ),
    );
  }

  Future<void> initiateInvoice() async {
    if (selectedOrders.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Select orders to create an invoice',
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (selectedOrders.length > 10) {
      Fluttertoast.showToast(
          msg: 'Only 10 orders can be selected at a time',
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      await checkInvoicePermission();
    }
  }

  checkInvoicePermission() async {
    String buyerName = selectedOrders[0]['Buyer name'];
    bool isSameBuyer = true;
    for (var items in selectedOrders) {
      // print('-----');
      // print(buyerName);
      // print(items['Buyer name']);
      // print('-----');

      if (items['Buyer name'] != buyerName) {
        setState(() {
          isSameBuyer = false;
        });
      }
    }

    if (!isSameBuyer) {
      return Fluttertoast.showToast(
          msg: 'All the invoice item must be from the same buyer',
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      await createInvoice();
    }
  }

  createInvoice() async {
    final pdf = pw.Document();
    double subTotal = 0.0;
    String buyerName = selectedOrders[0]['Buyer name'];
    String invoiceInfo = selectedOrders[0]['Invoice Number'];
    for (var items in selectedOrders) {
      if (items['Buyer name'] != buyerName) {
        return Fluttertoast.showToast(
            msg: 'All the invoice item must be from the same buyer',
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      } else {
        subTotal += double.tryParse(items['Total Amount to be Received'])!;
      }
    }

    final List<CustomRow> elements = [
      CustomRow("Item Name", "Item Price", "Amount", "Total"),
      for (var items in selectedOrders)
        CustomRow(
          items['Products'],
          "\$${items['Unit Price'].toString()}",
          items['Quantity'].toString(),
          "\$${items['Total Amount to be Received'].toString()}",
        ),
      CustomRow(
        "Sub Total",
        "",
        "",
        "\$$subTotal",
      ),
    ];
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // pw.Column(
                  //   children: [
                  //     pw.Text("Customer Name"),
                  //     pw.Text("Customer Address"),
                  //     pw.Text("Customer City"),
                  //     pw.Text("Invoice info"),
                  //   ],
                  // ),
                  pw.Column(
                    children: [
                      pw.Text("Buyer: $buyerName"),
                      pw.Text("Invoice No: $invoiceInfo")
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 50),
              itemColumn(elements),
              pw.SizedBox(height: 25),
            ],
          );
        },
      ),
    );
    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute("download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
      ..click();
    selectedOrders.clear();
  }

  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text(element.itemName,
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(
                    child: pw.Text(element.itemPrice,
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child:
                        pw.Text(element.amount, textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child:
                        pw.Text(element.total, textAlign: pw.TextAlign.right)),
              ],
            )
        ],
      ),
    );
  }
}
