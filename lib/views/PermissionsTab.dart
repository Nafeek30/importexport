import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PermissionsTab extends StatefulWidget {
  const PermissionsTab({super.key});

  @override
  PermisisonsTabState createState() => PermisisonsTabState();
}

class PermisisonsTabState extends State<PermissionsTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('approved', isEqualTo: 'true')
          .where('email', isNotEqualTo: 'nafeek30@gmai.com')
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
                    subtitle: Text(
                        'Current status: ${snapshot.data!.docs[index].get('writePermission') ? 'Read and Write' : 'Read Only'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            readAndWrite(snapshot.data!.docs[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 5,
                          ),
                          child: const Text('Read and Write'),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            readOnly(snapshot.data!.docs[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 5,
                          ),
                          child: const Text('Read Only'),
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

  Future<void> readAndWrite(String docId) async {
    Map<String, dynamic> data = {'writePermission': true};
    FirebaseFirestore.instance.collection('users').doc(docId).update(data);
  }

  Future<void> readOnly(String docId) async {
    Map<String, dynamic> data = {'writePermission': false};
    FirebaseFirestore.instance.collection('users').doc(docId).update(data);
  }
}
