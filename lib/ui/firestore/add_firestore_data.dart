import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../utils/utilities.dart';
import '../../widgets/round_button.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {
  final postController = TextEditingController();
  bool isloading = false;
  //create collection ('users'))
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add firestore data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30.0,),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30.0,),
            RoundButton(
              title: 'Add',
              loading: isloading,
              onTap: () {
                setState(() {
                  isloading=true;
                });
                String id= DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title': postController.text.toString(),
                  'id' : id,
                }).then((value) {
                  setState(() {
                    isloading=false;
                  });
                  Utils().toastMessage('post added');
                }).onError((error, stackTrace) {
                  setState(() {
                    isloading=false;
                  });
                  Utils().toastMessage(error.toString());
                });
              },)
          ],
        ),
      ),
    );
  }
}
