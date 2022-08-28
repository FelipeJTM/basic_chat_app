import 'package:basic_chat_app/main.dart';
import 'package:basic_chat_app/pages/auth/register_page.dart';
import 'package:basic_chat_app/service/auth_service.dart';
import 'package:basic_chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../helper/helper_function.dart';
import '../../widgets/widgets.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthService authService = AuthService();

  var email = "";

  var password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 80.0),
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        child: AnimatedTextKit(
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText("Enjoy❤️",
                                  textStyle: textStyle),
                              TyperAnimatedText("Keep in touch🫂",
                                  textStyle: textStyle),
                              TyperAnimatedText("Fast chat⚡️",
                                  textStyle: textStyle),
                            ]),
                      ),
                      const Text(
                        "Login now to see what they are talking!",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Image.asset(
                        "assets/login_image.png",
                        //"assets/IO_version_login.png",
                        width: 290,
                      ),
                      TextFormField(
                        decoration: textInputDecorationForm.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecorationForm.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Enter a password greater than 6 characters.";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          style: buttonDecoration,
                          child: const Text("Sign in"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Register now",
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(
                                        context: context,
                                        page: const RegisterPage());
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (_loginKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithEmailAndPassword(email: email, password: password).then((val) async {
        if (val == true) {
          if (kDebugMode) {
            print("val = true");
          }
          QuerySnapshot snapshot =
              await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          //saving the share preferences state.
          await HelperFunctions.saveUserLoggedInStatus(val);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context: context, page: const HomePage());
        } else {
          showSnackBar(
            context: context,
            message: val,
            color: Colors.red,
          );
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
