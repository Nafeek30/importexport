import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// The [AccessTab] section displays content when the [Access] button is clicked on the Access Control screen.
class AccessTab extends StatefulWidget {
  const AccessTab({super.key});

  @override
  AccessTabState createState() => AccessTabState();
}

class AccessTabState extends State<AccessTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('approved', isEqualTo: 'false')
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
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                        '${snapshot.data!.docs[index].get('firstName')} ${snapshot.data!.docs[index].get('lastName')}'),
                    subtitle:
                        Text('${snapshot.data!.docs[index].get('email')}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            // approve user
                            approveUser(snapshot.data!.docs[index].id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // reject user
                            rejectUser(snapshot.data!.docs[index].id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      },
    );
  }

  Future<void> approveUser(String docId) async {
    Map<String, dynamic> data = {'approved': 'true'};
    FirebaseFirestore.instance.collection('users').doc(docId).update(data);
  }

  Future<void> rejectUser(String docId) async {
    Map<String, dynamic> data = {'approved': 'reject'};
    FirebaseFirestore.instance.collection('users').doc(docId).update(data);
  }
}
