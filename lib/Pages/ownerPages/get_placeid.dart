import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class getPlaceID extends StatelessWidget {
  final String documentId;

  getPlaceID({required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get collection
    CollectionReference users =
        FirebaseFirestore.instance.collection('parkings');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Text(
            '''
Location ID: ${data['gmaps_id']}
''',
            maxLines: 1,
          );
        }
        return Text('loading...');
      }),
    );
  }
}
