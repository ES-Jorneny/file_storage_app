

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  /// Create account and store user data in Firestore
  static Future<String> createAccount({
    required String email,
    required String password,
    required String username,
    String? profileImageUrl,
  }) async {
    try {
      // Step 1: Create user using FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Step 2: Get UID of the created user
      String uid = userCredential.user!.uid;

      // Step 3: Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "userId":uid,
        'username': username,
        'email': email,
        'profileImageUrl': profileImageUrl??"",
        'createdAt': Timestamp.now(),
      });
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return "An error occurred: $e";
    }
  }
/// login:
static Future<String> loginWithEmail(String email,String password)async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully Login";
  }on FirebaseAuthException catch(e){
      return e.message.toString();
    }
}
/// logout:
static Future logout()async{
  await FirebaseAuth.instance.signOut();
}
/// check whether user sign in or not:
static Future<bool> isLoggedIn()async{
  var user= FirebaseAuth.instance.currentUser;
  return user!= null;
}

}