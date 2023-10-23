import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BanUnbanTab extends StatefulWidget {
  const BanUnbanTab({super.key});

  @override
  BanUnbanTabState createState() => BanUnbanTabState();
}

class BanUnbanTabState extends State<BanUnbanTab> {
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
          print(snapshot.error);
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
                        'Current status: ${snapshot.data!.docs[index].get('banned') ? 'Banned' : 'Active'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            banUser(snapshot.data!.docs[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 5,
                          ),
                          child: const Text('Ban'),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            unbanUser(snapshot.data!.docs[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 5,
                          ),
                          child: const Text('Unban'),
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

  Future<void> banUser(String docId) async {
    Map<String, dynamic> data = {'banned': true};
    FirebaseFirestore.instance.collection('users').doc(docId).update(data);
  }

  Future<void> unbanUser(String docId) async {
    Map<String, dynamic> data = {'banned': false};
    FirebaseFirestore.instance.collection('users').doc(docId).update(data);
  }
}
