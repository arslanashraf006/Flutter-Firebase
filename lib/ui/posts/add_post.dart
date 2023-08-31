import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../utils/utilities.dart';
import '../../widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool isloading = false;
  //create a table on in firebase it is called a node (ref('post'))
  final databaseRef=FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
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
                //child refer to id or set refers to add
                //if you want to add a subchild then add child().child()
                String id= DateTime.now().millisecondsSinceEpoch.toString();
              databaseRef.child(id).set({
                'title':postController.text.toString(),
                'id': id,
              }).then((value){
                Utils().toastMessage('Post Added');
                setState(() {
                  isloading=false;
                });
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                setState(() {
                  isloading=false;
                });
              });
            },)
          ],
        ),
      ),
    );
  }
}
