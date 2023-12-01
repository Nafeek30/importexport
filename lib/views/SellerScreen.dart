// import 'package:flutter/material.dart';
// import 'package:importexport/utility/HorizontalScrollGrid.dart';
// import 'package:importexport/views/OrderScreen.dart';
//
// class SellerScreen extends StatefulWidget {
//   final String sellerName;
//   const SellerScreen({super.key, required this.sellerName});
//
//   @override
//   SellerScreenState createState() => SellerScreenState();
// }
//
// class SellerScreenState extends State<SellerScreen> {
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal[400],
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OrderScreen(),
//               ),
//             );
//           },
//           child: Container(
//             child: Center(
//               child: Text(
//                 'Home',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           widget.sellerName,
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               print('logout');
//             },
//             child: Center(
//               child: Container(
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 4,
//                 ),
//                 child: Text(
//                   'Logout',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             const Text(
//               'All current orders:',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: HorizontalScrollGrid(
//                   searchController, '10', '', widget.sellerName),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
