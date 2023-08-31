import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/app_color.dart';
import '../../widgets/text_form_field_widget.dart';
import '../notification_screen.dart';
import '/ui/posts/post_screen.dart';
import '../../utils/utilities.dart';
import '/ui/auth/signup_screen.dart';
import '../../widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;
///check the app is open through notification and navigate it to a page
  void getInitialMessage() async{
    RemoteMessage? message= await FirebaseMessaging.instance.getInitialMessage();
    ///check the message is not null as the app is open through notification & navigate to screen
    if(message!=null){
      if(message.data['page']=='notification'){
       Navigator.push(context, MaterialPageRoute(builder:  (context) => NotificationScreen(),));
      }else if(message.data['page']!='notification'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Page provided to navigate'),
          duration: Duration(seconds: 3),
          backgroundColor: AppColors.appDefaultColor,
        ));
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitialMessage();
    ///show the firebase message data on app screen like dialog box, snackbar, or page etc
    FirebaseMessaging.onMessage.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.notification!.body.toString()),
      duration: const Duration(seconds: 3),
        backgroundColor: AppColors.appDefaultColor,
      ));
    });
/// sends the notification when app is in background and shows up on app opened & shows snackbar, pages etc
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('App was opened by a notification'),
        duration: Duration(seconds: 3),
        backgroundColor: AppColors.appDefaultColor,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100,),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          textInputType: TextInputType.emailAddress,
                            emailController: emailController,
                        hintText: 'Email',
                          prefixIcon: const Icon(Icons.alternate_email),
                          validator: (value) {
                            if(value!.isEmpty){
                              return "Enter email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormFieldWidget(
                          textInputType: TextInputType.text,
                            emailController: passwordController,
                            hintText: 'Password',
                            validator: (value) {
                              if(value!.isEmpty){
                                return "Enter password";
                              }
                              return null;
                            },
                            prefixIcon: const Icon(Icons.lock_open_outlined),
                        ),
                      ],
                    )),
                const SizedBox(height: 50,),
                RoundButton(
                  loading: loading,
                  onTap: () {
                    if(_formkey.currentState!.validate()){
                      login();
                    }
                  },
                    title: 'Login',
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text("Don't have an account"),
                  TextButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen(),));
                  },
                      child: const Text('Sign up'))
                  ],
                ),
                const SizedBox(height: 30,),
                RoundButton(
                  onTap: () {
                    signInWithGoogle();
                  },
                  title: 'Login with Google with firebase',
                ),
                const SizedBox(height: 5,),
                RoundButton(
                  onTap: () {
                    googleLogin();
                  },
                  title: 'Login with Google',
                ),
                const SizedBox(height: 5,),
                RoundButton(
                  onTap: () {
                    signInWithFacebook().then((value){
                      Utils().toastMessage(value.user!.email.toString());
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => const PostScreen(),),
                      );
                      setState(() {
                        loading=false;
                      });
                    });
                  },
                  title: 'Login with Facebook with firebase',
                ),
                const SizedBox(height: 5,),
                RoundButton(
                  onTap: () {
                    facebookLogin().then((value){
                      Utils().toastMessage(value.user!.email.toString());
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => const PostScreen(),),
                      );
                      setState(() {
                        loading=false;
                      });
                    });
                  },
                  title: 'Login with Facebook',
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => const LoginWithPhoneNumber(),));
                //   },
                //   child: Container(
                //     height: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50),
                //       border: Border.all(
                //         color: Colors.black
                //       ),
                //     ),
                //     child: const Center(
                //       child: Text('Login with phone number'),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 60,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future signInWithGoogle() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser==null) return;
    //_user = googleUser;
    final googleAuthentication = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );
    await _auth.signInWithCredential(credential).then((value){
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => const PostScreen(),),
      );
      setState(() {
        loading=false;
      });
    });
    debugPrint("Google User Name :${googleUser.displayName}");
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile','user_birthday'],
    );
    AccessToken? token =  loginResult.accessToken;
    AccessToken accessToken =token!;
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =  FacebookAuthProvider.credential(accessToken.token);

    final userData = await FacebookAuth.instance.getUserData();

    var userEmail = userData['email'];

    // Once signed in, return the UserCredential
    return _auth.signInWithCredential(facebookAuthCredential);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailController;
    passwordController;
    super.dispose();
  }
  void googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );

    _googleSignIn.signIn().whenComplete(() async {
      GoogleSignInAccount? acc;
      GoogleSignInAuthentication auth = await acc!.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);
      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);
      });
    });

  }

  facebookLogin() async{
    await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile','user_birthday'],
    );
    final userData = await FacebookAuth.instance.getUserData();
    debugPrint(userData['email']);
    debugPrint(userData['public_profile']);
  }

  void login(){
    setState(() {
      loading=true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => const PostScreen(),),
      );
      setState(() {
        loading=false;
      });
    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });
  }
}

