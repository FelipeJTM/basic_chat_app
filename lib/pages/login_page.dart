import 'package:basic_chat_app/helper/login_helper.dart';
import 'package:basic_chat_app/pages/register_page.dart';
import 'package:basic_chat_app/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../widgets/widgets.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  bool _amILogging = false;
  AuthService authenticationService = AuthService();
  var formEmailValue = "";
  var formPasswordValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: widgetSelector());
  }

  Widget widgetSelector() {
    if (_amILogging) {
      return loadingWidget();
    } else {
      return loginViewWidget();
    }
  }

  Widget loadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget loginViewWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleWidget(),
              const Text(
                "Login now to see what they are talking!",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
              Image.asset(
                "assets/login_image.png",
                width: 290,
              ),
              const SizedBox(height: 20),
              formFieldEmailWidget(),
              const SizedBox(height: 20),
              formFieldPasswordWidget(),
              const SizedBox(height: 20),
              signInButtonWidget(),
              const SizedBox(height: 20),
              createAccountWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return SizedBox(
      height: 80,
      child: AnimatedTextKit(totalRepeatCount: 1, animatedTexts: [
        TyperAnimatedText("Enjoy❤️", textStyle: textStyle),
        TyperAnimatedText("Keep in touch🫂", textStyle: textStyle),
        TyperAnimatedText("Fast chat⚡️", textStyle: textStyle),
      ]),
    );
  }

  Widget formFieldEmailWidget() {
    return TextFormField(
      decoration: textInputDecorationForm.copyWith(
          labelText: "Email",
          prefixIcon: Icon(
            Icons.email,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) {
        setState(() {
          formEmailValue = val;
        });
      },
      validator: (val) {
        return RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
            ? null
            : "Please enter a valid email";
      },
    );
  }

  Widget formFieldPasswordWidget() {
    return TextFormField(
      obscureText: true,
      decoration: textInputDecorationForm.copyWith(
          labelText: "Password",
          prefixIcon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) {
        setState(() {
          formPasswordValue = val;
        });
      },
      validator: (val) {
        if (val!.length < 6) {
          return "Enter a password greater than 6 characters.";
        } else {
          return null;
        }
      },
    );
  }

  Widget signInButtonWidget() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          toggleLoadingIndicator();
          LoginHelper loginHelperInstance = createLoginHelperInstance();
          bool loginStatus = await loginIn(helperInstance: loginHelperInstance);
          bool saveDataStatus = loginStatus
              ? await saveData(helperInstance: loginHelperInstance, loginStatus: loginStatus)
              : false;
          proceedToHome(loginStatus: loginStatus, dataStatus: saveDataStatus);
          toggleLoadingIndicator();
        },
        style: buttonDecoration,
        child: const Text("Sign in"),
      ),
    );
  }

  Widget createAccountWidget() {
    return Text.rich(
      TextSpan(
        text: "Don't have an account? ",
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              text: "Register now",
              style: const TextStyle(
                  color: Colors.black, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  nextScreen(context: context, page: const RegisterPage());
                }),
        ],
      ),
    );
  }

  void toggleLoadingIndicator() {
    setState(() {
      _amILogging = !_amILogging;
    });
  }

  LoginHelper createLoginHelperInstance() {
    return LoginHelper.initialize(
        formEmailValue, formPasswordValue, authenticationService);
  }

  Future<bool> loginIn({required LoginHelper helperInstance}) async {
    if (!formIsValid()) return false;
    try {
      return await helperInstance.login();
    } catch (exception) {
      failedToLogin(exception.toString());
      return false;
    }
  }

  bool formIsValid() {
    return _loginKey.currentState!.validate();
  }

  void failedToLogin(dynamic response) {
    showSnackBar(context: context, message: response, color: Colors.red);
  }

  Future<bool> saveData({
    required bool loginStatus,
    required LoginHelper helperInstance,
  }) async {
    return await helperInstance.saveDataSnapshot(status: loginStatus);
  }

  void proceedToHome({required bool loginStatus, required bool dataStatus}) {
    if (loginStatus && dataStatus) {
      nextScreenReplace(context: context, page: const HomePage());
    }
  }
}
