import 'package:basic_chat_app/helper/auth_helper.dart';
import 'package:basic_chat_app/pages/register_page.dart';
import 'package:basic_chat_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../constants/image_constants.dart';
import '../helper/screen_nav_helper.dart';
import '../models/form_config_data.dart';
import '../theme/form_decorations.dart';
import '../widgets/custom_form_widgets.dart';
import '../widgets/loading_widget.dart';
import '../widgets/general_purpose_widget.dart';
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
  var _formEmailValue = "";
  var _formPasswordValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginBody(),
    );
  }

  Widget loginBody() {
    if (_amILogging) return loadingWidget();
    return loginViewWidget();
  }

  Widget loadingWidget() {
    return LoadingWidgets.simpleCircle(context);
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
              subtitleWidget(),
              mainImage(),
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
        TyperAnimatedText("Enjoy❤️", textStyle: FormDecorations.textStyle),
        TyperAnimatedText("Keep in touch🫂",
            textStyle: FormDecorations.textStyle),
        TyperAnimatedText("Fast chat⚡️", textStyle: FormDecorations.textStyle),
      ]),
    );
  }

  Widget subtitleWidget() {
    return const Text(
      "Login now to see what they are talking!",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
    );
  }

  Widget mainImage() {
    return Image.asset(
      ImageConstants.imageLogin1,
      width: 290,
    );
  }

  Widget formFieldEmailWidget() {
    return CustomFormWidgets.textField(
        context,
        FormConfigData(
          labelText: "Email",
          icon: Icons.email,
          assignNewValue: (mewValue) {
            setState(() {
              _formEmailValue = mewValue;
            });
          },
          isItAnEmailField: true,
        ));
  }

  Widget formFieldPasswordWidget() {
    return CustomFormWidgets.textField(
        context,
        FormConfigData(
          labelText: "Password",
          icon: Icons.lock,
          assignNewValue: (mewValue) {
            setState(() {
              _formPasswordValue = mewValue;
            });
          },
          hideText: true,
        ));
  }

  Widget createAccountWidget() {
    return GeneralPurposeWidget.bottomMessageWithLink(
        context: context,
        mainPhrase: "Don't have an account? ",
        linkPhrase: "Register now",
        navigationFunction: () {
          ScreenNavHelper.nextScreen(
            context: context,
            page: const RegisterPage(),
          );
        });
  }

  Widget signInButtonWidget() {
    return CustomFormWidgets.button("Sign in", () => loginButtonEvent());
  }

  void loginButtonEvent() async {
    toggleLoadingIndicator();
    AuthHelper loginHelper = createAuthHelperInstance();
    bool loginStatus = await loginIn(helperInstance: loginHelper);
    bool saveDataStatus = loginStatus
        ? await saveData(helperInstance: loginHelper, loginStatus: loginStatus)
        : false;
    proceedToHome(loginStatus: loginStatus, dataStatus: saveDataStatus);
    toggleLoadingIndicator();
  }

  void toggleLoadingIndicator() {
    setState(() {
      _amILogging = !_amILogging;
    });
  }

  AuthHelper createAuthHelperInstance() {
    return AuthHelper.initialize(
      formEmailValue: _formEmailValue,
      formPasswordValue: _formPasswordValue,
      authService: authenticationService,
    );
  }

  Future<bool> loginIn({required AuthHelper helperInstance}) async {
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
    GeneralPurposeWidget.showSnackBar(
        context: context, message: response, color: Colors.red);
  }

  Future<bool> saveData(
      {required bool loginStatus, required AuthHelper helperInstance}) async {
    return await helperInstance.saveLoginDataSnapshot(status: loginStatus);
  }

  void proceedToHome({required bool loginStatus, required bool dataStatus}) {
    if (loginStatus && dataStatus) {
      ScreenNavHelper.nextScreenReplace(
          context: context, page: const HomePage());
    }
  }
}
