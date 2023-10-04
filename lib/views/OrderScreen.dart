import 'package:flutter/material.dart';
import 'package:importexport/utility/HorizontalScrollGrid.dart';

class OrderScreen extends StatefulWidget {
  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  TextEditingController? searchController;
  String? filterPrice;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          GestureDetector(
            onTap: () {
              print('logout');
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Text(
                  'Logout',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
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
              child:
                  HorizontalScrollGrid(searchController!, filterPrice, '', ''),
            ),
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
                value: filterPrice,
                hint: const Text("Filter by Price"),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    filterPrice = newValue;
                  });
                },
                items: ["< \$50", ">= \$50"].map((String value) {
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
}
