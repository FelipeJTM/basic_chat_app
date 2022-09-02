import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import '../service/database_service.dart';
import '../service/shared_preferences_service.dart';

class LoginHelper {
  final String formEmailValue;
  final String formPasswordValue;
  final AuthService authService;

  LoginHelper.initialize(this.formEmailValue, this.formPasswordValue, this.authService);

  Future<bool> login() async {
    dynamic loginResponse = await authService.loginWithEmailAndPassword(email: formEmailValue, password: formPasswordValue);
    try {
      return loginResponse;
    }catch(_){
      throw Exception(loginResponse.toString());
    }
  }

  //save data local storage
  Future<bool> saveDataSnapshot({required bool status}) async {
    QuerySnapshot dataBaseSnapshot = await getDataBaseSnapshot();
    await storeWithSharedPreference(loginStatus: status, snapshot: dataBaseSnapshot);
    return true;
  }

  Future<QuerySnapshot<Object?>> getDataBaseSnapshot() async {
    return await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(formEmailValue);
  }

  Future<bool> storeWithSharedPreference({required bool loginStatus, required QuerySnapshot snapshot}) async {
    await SharedPreferenceService.saveUserLoggedInStatus(loginStatus);
    await SharedPreferenceService.saveUserEmailSF(formEmailValue);
    await SharedPreferenceService.saveUserNameSF(snapshot.docs[0]['fullName']);
    return true;
  }
}
