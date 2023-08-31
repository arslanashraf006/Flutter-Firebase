import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/verify_code.dart';
import 'package:flutter_firebase/utils/utilities.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80,),
            TextFormField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                hintText: '+99 XXX XXXX XXX',
              ),
            ),
            const SizedBox(height: 80,),
            RoundButton(
              title: 'Login',
              onTap: () {
                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text,
                    verificationCompleted: (_){},
                    verificationFailed: (error) {
                      Utils().toastMessage(error.toString());
                    },
                    codeSent: (verificationId, forceResendingToken) {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCodeScreen(verificationId: verificationId,),),
                      );
                    },
                    codeAutoRetrievalTimeout: (error) {
                      Utils().toastMessage(error.toString());
                    }
                    );
            },)
          ],
        ),
      ),
    );
  }
}
