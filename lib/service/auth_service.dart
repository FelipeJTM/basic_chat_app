import 'package:firebase_auth/firebase_auth.dart';
import '../helper/auth_helper.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerWithEmailAndPassword(
      {required String fullName,
      required String email,
      required String password}) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user!;

      //call database service to save user data.
      await DataBaseService(uid: user.uid).savingUserData(
        fullName: fullName,
        email: email,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      AuthHelper.cleanUserInfo();
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
