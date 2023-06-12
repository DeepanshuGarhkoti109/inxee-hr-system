import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> loginUser(
      {required String email,
      required String password,
      required bool isAdmin}) async {
    String res = "";

    try {
      final userValid = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs[0].data()["isAdmin"] != isAdmin) {
          if (isAdmin == false) {
            res = "Invalid Employee Email/Password combination";
          } else {
            res = "Invalid Admin Email/Password combination";
          }
          print(res);

          return false;
        } else {
          return true;
        }
      }, onError: (err) {
        res = err.toString();
        return false;
      });

      if (!userValid) {
        return res;
      }

      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "LOGGED_IN";

        // TODO REMOVE LATER
        await _auth.signOut();
      } else {
        res = "Email or password field empty";
      }
    } on FirebaseAuthException catch (err) {
      if (isAdmin == false) {
        res = "Invalid Employee Email/Password combination";
      } else {
        res = "Invalid Admin Email/Password combination";
      }
      
      print(res);
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> forgotPassword({required String email}) async {
    String res = "";

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
