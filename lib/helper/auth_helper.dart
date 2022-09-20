import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import '../service/database_service.dart';
import '../service/shared_preferences_service.dart';

class AuthHelper {
  final String? fullUserName;
  final String formEmailValue;
  final String formPasswordValue;
  final AuthService authService;

  AuthHelper.initialize({
    required this.formEmailValue,
    required this.formPasswordValue,
    required this.authService,
    this.fullUserName,
  });

  Future<bool> login() async {
    dynamic loginResponse = await authService.loginWithEmailAndPassword(
        email: formEmailValue, password: formPasswordValue);
    try {
      return loginResponse;
    } catch (_) {
      throw Exception(loginResponse.toString());
    }
  }

  Future<bool> register() async {
    dynamic registerResponse = await authService.registerWithEmailAndPassword(
      fullName: fullUserName!,
      email: formEmailValue,
      password: formPasswordValue,
    );
    try {
      return registerResponse;
    } catch (_) {
      throw Exception(registerResponse.toString());
    }
  }

  //save data local storage
  Future<bool> saveLoginDataSnapshot({required bool status}) async {
    QuerySnapshot dataBaseSnapshot = await getDataBaseSnapshot();
    await saveLoggedInStatus(loginStatus: status);
    await saveUserEmail();
    await saveUserNameFromSnapshot(snapshot: dataBaseSnapshot);
    return true;
  }

  Future<bool> saveRegisterData({required bool status}) async {
    await saveLoggedInStatus(loginStatus: status);
    await saveUserEmail();
    await saveUserName();
    return true;
  }

  Future<QuerySnapshot<Object?>> getDataBaseSnapshot() async {
    return await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserData(formEmailValue);
  }

  Future<void> saveLoggedInStatus({required bool loginStatus}) async {
    await SharedPreferenceService.saveUserLoggedInStatusIntoSP(loginStatus);
  }

  Future<void> saveUserEmail() async {
    await SharedPreferenceService.saveUserEmailSP(formEmailValue);
  }

  Future<void> saveUserName() async {
    await SharedPreferenceService.saveUserNameSP(fullUserName!);
  }

  Future<void> saveUserNameFromSnapshot(
      {required QuerySnapshot snapshot}) async {
    await SharedPreferenceService.saveUserNameSP(snapshot.docs[0]['fullName']);
  }

  static Future cleanUserInfo() async {
    try {
      await SharedPreferenceService.saveUserLoggedInStatusIntoSP(false);
      await SharedPreferenceService.saveUserNameSP("");
      await SharedPreferenceService.saveUserEmailSP("");
    } catch (e) {
      return null;
    }
  }
}
