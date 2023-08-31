import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/text_form_field_widget.dart';
import '../../utils/utilities.dart';
import '/ui/auth/login_screen.dart';
import '../../widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    emailController;
    passwordController;
    super.dispose();
  }

  void login(){
    if(_formkey.currentState!.validate()){
      setState(() {
        loading = true;
      });
      _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      ).then((value){
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace){
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormFieldWidget(
                        emailController: emailController,
                        hintText: 'Email',
                        validator: (value) {
                      if(value!.isEmpty){
                        return "Enter email";
                      }
                      return null;
                    },
                        prefixIcon: const Icon(Icons.alternate_email),
                        textInputType: TextInputType.emailAddress),
                    const SizedBox(height: 10,),
                    TextFormFieldWidget(
                        emailController: passwordController,
                        hintText: 'Password',
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Enter password";
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        textInputType: TextInputType.text),
                  ],
                )),
            const SizedBox(height: 50,),
            RoundButton(
              loading: loading,
              onTap: () {
                login();
              },
              title: 'Sign up',
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Text("Already have an account"),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen(),));
                },
                    child: const Text('Login'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
