import 'package:flutter/material.dart';
import '../firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices=SplashServices();
@override
  void initState() {
    // TODO: implement initState
  splashServices.isLogin(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Firebase Tutorials',
        style: TextStyle(
          fontSize: 30,
        ),
        ),
      ),
    );
  }
}
