import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_exp/const/constants.dart';
import 'package:new_exp/expense_task/pages/sign_up/sign_up_page.dart';
import '../../app_utils/app_utils.dart';
import '../../db_helper/db_helper_class.dart';
import '../../shared_prefrance/prefrance.dart';
import '../home_page/home_page.dart';
import '../../model/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // State variable for password visibility

  @override
  Widget build(BuildContext context) {
    var sizeForHeight = MediaQuery.of(context).size.height;
    var sizeForWidth = MediaQuery.of(context).size.width;
    Constants myConstants = Constants();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 180),
              Center(
                child: Image(
                  width: 130,
                  height: 130,
                  image: AssetImage("assets/images/logo.png"),
                ),
              ),
              SizedBox(height: 200),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  "Login to your Account",
                  style: TextStyle(
                    fontFamily: myConstants.RobotoR,
                    fontSize: 23,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          style: TextStyle(fontFamily: myConstants.RobotoL),
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontFamily: myConstants.RobotoL,
                            ),
                            border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: myConstants.RobotoR,
                          ),
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontFamily: myConstants.RobotoL,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? CupertinoIcons.eye_slash
                                    : CupertinoIcons.eye,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      // GestureDetector(
                      //   onTap: () => _login(context),
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     margin: EdgeInsets.symmetric(horizontal: 20),
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       color: Colors.blue,
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Login In",
                      //         style: TextStyle(
                      //           fontSize: 18,
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: 100, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () => _login(context),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?  ",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: myConstants.RobotoR,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.off(SignUpPage(), transition: Transition.downToUp);
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        color: myConstants.secondaryColor,
                        fontFamily: myConstants.RobotoI,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    String? emailError = AppUtil.isValidEmail(email);
    String? passwordError = AppUtil.isValidPassword(password);

    if (emailError != null || passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError ?? passwordError!)),
      );
      return;
    }

    DbHelper dbHelper = DbHelper();
    User? user = await dbHelper.getUserByEmail(email);

    if (user != null && user.password == password) {
      await PrefrenceManager.statusChange(true, user.id!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }
}
