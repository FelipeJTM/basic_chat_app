import 'package:basic_chat_app/constants/image_constants.dart';
import 'package:basic_chat_app/pages/home_page.dart';
import 'package:basic_chat_app/service/auth_service.dart';
import 'package:basic_chat_app/theme/form_decorations.dart';
import "package:flutter/material.dart";

import '../../widgets/general_purpose_widget.dart';
import '../helper/auth_helper.dart';
import '../helper/screen_nav_helper.dart';
import '../models/form_config_data.dart';
import '../widgets/custom_form_widgets.dart';
import '../widgets/loading_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthService authenticationService = AuthService();

  //If you need to hold field values within Stream, onChanged is what you need.
  // In other cases you may use controller.
  var _formFullNameValue = "";
  var _formPasswordValue = "";
  var _formEmailValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: registerBody(),
    );
  }

  Widget registerBody() {
    if (_isLoading) return loadingWidget();
    return registerViewWidget();
  }

  Widget loadingWidget() {
    return LoadingWidgets.simpleCircle(context);
  }

  Widget registerViewWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _registerKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleWidget(),
              subtitleWidget(),
              mainImage(),
              formFieldUserNameWidget(),
              const SizedBox(height: 20),
              formFieldEmailWidget(),
              const SizedBox(height: 20),
              formFieldPasswordWidget(),
              const SizedBox(height: 20),
              registerButtonWidget(),
              const SizedBox(height: 20),
              loginNowWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return const SizedBox(
        height: 80,
        child: Text("Fast chat⚡️", style: FormDecorations.textStyle));
  }

  Widget subtitleWidget() {
    return const Text(
      "Create your account now to chat and explore.",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
    );
  }

  Widget mainImage() {
    return Image.asset(
      ImageConstants.imageRegister1,
    );
  }

  Widget formFieldUserNameWidget() {
    return CustomFormWidgets.textField(
        context,
        FormConfigData(
          inputMinLength: 3,
          labelText: "Full Name",
          icon: Icons.person,
          assignNewValue: (mewValue) {
            setState(() {
              _formFullNameValue = mewValue;
            });
          },
        ));
  }

  Widget formFieldEmailWidget() {
    return CustomFormWidgets.textField(
        context,
        FormConfigData(
          inputMinLength: 3,
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
          inputMinLength: 6,
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

  Widget loginNowWidget() {
    return GeneralPurposeWidget.bottomMessageWithLink(
        context: context,
        mainPhrase: "Already have an account? ",
        linkPhrase: "Login now",
        navigationFunction: () {
          ScreenNavHelper.popScreen(context: context);
        });
  }

  Widget registerButtonWidget() {
    return CustomFormWidgets.button("Register", () => registerButtonEvent());
  }

  registerButtonEvent() async {
    toggleLoadingIndicator();
    AuthHelper registerHelper = createAuthHelperInstance();
    bool registerStatus = await registerUser(helperInstance: registerHelper);
    bool saveDataStatus = registerStatus
        ? await saveUserData(
            helperInstance: registerHelper, loginStatus: registerStatus)
        : false;
    proceedToHome(loginStatus: registerStatus, dataStatus: saveDataStatus);
    toggleLoadingIndicator();
  }

  void toggleLoadingIndicator() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  AuthHelper createAuthHelperInstance() {
    return AuthHelper.initialize(
      fullUserName: _formFullNameValue,
      formEmailValue: _formEmailValue,
      formPasswordValue: _formPasswordValue,
      authService: authenticationService,
    );
  }

  Future<bool> registerUser({required AuthHelper helperInstance}) async {
    if (!formIsValid()) return false;
    try {
      return await helperInstance.register();
    } catch (exception) {
      failedToRegister(exception.toString());
      return false;
    }
  }

  bool formIsValid() {
    return _registerKey.currentState!.validate();
  }

  void failedToRegister(dynamic response) {
    GeneralPurposeWidget.showSnackBar(
        context: context, message: response, color: Colors.red);
  }

  Future<bool> saveUserData(
      {required bool loginStatus, required AuthHelper helperInstance}) async {
    return await helperInstance.saveRegisterData(status: loginStatus);
  }

  void proceedToHome({required bool loginStatus, required bool dataStatus}) {
    if (loginStatus && dataStatus) {
      ScreenNavHelper.nextScreenReplace(
          context: context, page: const HomePage());
    }
  }
}
