import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_exp/expense_task/pages/login/login_page.dart';
import '../../../const/constants.dart';
import '../../app_utils/app_utils.dart';
import '../../db_helper/db_helper_class.dart';
import '../../shared_prefrance/prefrance.dart';
import '../home_page/home_page.dart';
import '../../model/user.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    var sizeForHeight = MediaQuery.of(context).size.height;
    var sizeForWidth = MediaQuery.of(context).size.width;
    Constants myConstants = Constants();

    return Scaffold(
      body: SingleChildScrollView(
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
            SizedBox(height: 140),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text("Create account",
                  style:
                      TextStyle(fontFamily: myConstants.RobotoR, fontSize: 23)),
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildTextField(
                //   controller: _emailController,
                //   label: 'Email',
                //   icon: Icons.email_outlined,
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontFamily: myConstants.RobotoL,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontFamily: myConstants.RobotoL,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _confirmController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        fontFamily: myConstants.RobotoL,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                // Center(
                //   child: GestureDetector(
                //     onTap: () => _signUp(context),
                //     child: Container(
                //       padding: EdgeInsets.all(15),
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: Colors.blue,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Sign Up",
                //           style: TextStyle(
                //             fontSize: 18,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //           ),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => _signUp(context),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: myConstants.RobotoR,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an Account?  ",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: myConstants.RobotoR,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.off(LoginPage(), transition: Transition.downToUp);
                      },
                      child: Text(
                        "Sign In",
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
            // SizedBox(height: 20),
            // Center(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         "Already have an account?  ",
            //         style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.black,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.pushReplacement(
            //             context,
            //             MaterialPageRoute(builder: (context) => LoginPage()),
            //           );
            //         },
            //         child: Text(
            //           "Log In Now",
            //           style: TextStyle(
            //             fontSize: 18,
            //             color: Colors.blue,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.0, color: Colors.black12),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.blue,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  void _signUp(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmController.text;

    String? emailError = AppUtil.isValidEmail(email);
    String? passwordError = AppUtil.isValidPassword(password);
    String? confirmPasswordError =
        AppUtil.isValidConfirmPassword(password, confirmPassword);

    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(emailError ?? passwordError ?? confirmPasswordError!)),
      );
      return;
    }

    User newUser = User(email: email, password: password);

    DbHelper dbHelper = DbHelper(); // Ensure that the instance is created
    int userId = await dbHelper.insertUser(newUser);

    await PrefrenceManager.statusChange(true, userId);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
