import 'package:flutter/material.dart';
import 'package:importexport/views/BuyerScreen.dart';
import 'package:importexport/views/SellerScreen.dart';

class HorizontalScrollGrid extends StatefulWidget {
  final String? buyerName;
  final String? sellerName;
  final TextEditingController searchController;
  final String? filterPrice;

  HorizontalScrollGrid(
      this.searchController, this.filterPrice, this.buyerName, this.sellerName,
      {super.key});

  @override
  _HorizontalScrollGridState createState() => _HorizontalScrollGridState();
}

class _HorizontalScrollGridState extends State<HorizontalScrollGrid> {
  late List<Map<String, dynamic>> items;
  late List<bool> selectedRows;

  @override
  void initState() {
    super.initState();
    items = List.generate(15, (index) {
      return {
        'Index': '${index + 1}',
        'Buyer name':
            widget.buyerName == '' ? 'Buyer ${index + 1}' : widget.buyerName,
        'Products': 'XYZ',
        'Unit Price': (index + 1) * 10,
        'Quantity': '${100 - index}',
        'Invoice Number': 'Invoice ${index + 5}',
        'Invoice Date': '${DateTime.now()}',
        'Terms of Payment': 'ABC',
        'Supplier name': widget.sellerName == ''
            ? 'Supplier ${index + 1}'
            : widget.sellerName,
        'Letter of Credit Number': '123',
        'Letter of Credit Date': '${DateTime.now()}',
        'LC Value': '789',
        'Amount for Commission': (index + 1) * 2,
        'Commission %': '20',
        'Total Commission': (index + 1) * 2,
        'Other Amount': (index + 1) * 1.5,
        'Total Amount to be Received': (index + 1) * 3.5,
        'Received Amount': (index + 1) * 3,
        'Received Date': '${DateTime.now()}',
        'Commission Note': 'EFG',
        'Comments': 'Some Comment',
      };
    });

    selectedRows = List.generate(items.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = items.where((item) {
      if (widget.searchController.text.isNotEmpty &&
          !item['Buyer name']
              .toLowerCase()
              .contains(widget.searchController.text.toLowerCase())) {
        return false;
      }
      if (widget.filterPrice == "< \$50" && item['Unit Price']! >= 50) {
        return false;
      } else if (widget.filterPrice == ">= \$50" && item['Unit Price']! < 50) {
        return false;
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.teal.shade50),
          dividerThickness: 1,
          columns: [
            _customDataColumn('Select'),
            _customDataColumn('Edit'),
            _customDataColumn('Index'),
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
                      });
                    },
                    activeColor: Colors.teal,
                  ),
                ),
                _customDataCellWithWidget(
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    onPressed: () {},
                  ),
                ),
                _customDataCell(item['Index'], false, false),
                _customDataCell(item['Buyer name'], true, false),
                _customDataCell(item['Products'], false, false),
                _customDataCell('\$${item['Unit Price']}', false, false),
                _customDataCell(item['Quantity'], false, false),
                _customDataCell(item['Invoice Number'], false, false),
                _customDataCell(item['Invoice Date'], false, false),
                _customDataCell(item['Terms of Payment'], false, false),
                _customDataCell(item['Supplier name'], false, true),
                _customDataCell(item['Letter of Credit Number'], false, false),
                _customDataCell(item['Letter of Credit Date'], false, false),
                _customDataCell(item['LC Value'], false, false),
                _customDataCell(
                    '\$${item['Amount for Commission']}', false, false),
                _customDataCell(item['Commission %'], false, false),
                _customDataCell('\$${item['Total Commission']}', false, false),
                _customDataCell('\$${item['Other Amount']}', false, false),
                _customDataCell(
                    '\$${item['Total Amount to be Received']}', false, false),
                _customDataCell('\$${item['Received Amount']}', false, false),
                _customDataCell(item['Received Date'], false, false),
                _customDataCell(item['Commission Note'], false, false),
                _customDataCell(item['Comments'], false, false),
              ],
            );
          }).toList(),
        ),
      ),
    );
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
}
