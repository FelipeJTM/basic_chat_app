import 'package:basic_chat_app/service/shared_preferences_service.dart';
import 'package:basic_chat_app/pages/home_page.dart';
import 'package:basic_chat_app/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService authService = AuthService();
  final _registerKey = GlobalKey<FormState>();
  bool _isLoading = false;

  //If you need to hold field values within Stream, onChanged is what you need. In other cases you may use controller.
  var fullName = "";
  var password = "";
  var email = "";

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
                  key: _registerKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                          height: 80,
                          child: Text("Fast chat⚡️", style: textStyle)),
                      const Text(
                        "Create your account now to chat and explore.",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Image.asset(
                        "assets/register_image.png",
                        //"assets/IO_version_register.png",
                        //width: 290,
                      ),
                      TextFormField(
                        decoration: textInputDecorationForm.copyWith(
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isEmpty || val.length < 4) {
                            return "Enter a valid username (more than 3 characters).";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
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
                            register();
                          },
                          style: buttonDecoration,
                          child: const Text("Register"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Login now",
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    popScreen(context: context);
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

  register() async {
    if (_registerKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerWithEmailAndPassword(
              fullName: fullName, email: email, password: password)
          .then((val) async {
        if (val == true) {
          //saving the share preferences state.
          await SharedPreferenceService.saveUserLoggedInStatus(val);
          await SharedPreferenceService.saveUserNameSF(fullName);
          await SharedPreferenceService.saveUserEmailSF(email);
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
