import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_exp/const/constants.dart';
import 'package:new_exp/expense_task/pages/login/login_page.dart';
import '../../shared_prefrance/prefrance.dart';
import '../home_page/home_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    await PrefrenceManager.getLoginStatus();
    Timer(const Duration(seconds: 2), _navigateUser);
  }

  Future<void> _navigateUser() async {
    bool isLoggedIn = await PrefrenceManager.getLoginStatus();
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  Homescreen()),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/images/logo.png',),
            ),
            const SizedBox(height: 20),
             Text(
              'your digital partner',
              style: TextStyle(
                fontSize: 32,
                fontFamily: myConstants.RobotoM,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
