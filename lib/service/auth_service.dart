import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_function.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerWithEmailAndPassword(
      {required String fullName,
      required String email,
      required String password}) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //call database service to save user data.
        await DataBaseService(uid: user.uid)
            .savingUserData(fullName: fullName, email: email);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

//sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
