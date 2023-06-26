// ignore_for_file: unnecessary_this, unused_import, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> forgotPassword({required String email}) async {
    String res = '';
    int otp = -1;

    if (email.isEmpty) {
      res = 'EMAIL_EMPTY';
      return <String>[res, otp.toString()];
    }

    try {
      otp = await this.sendEmail(email: email);
    } catch (err) {
      res = err.toString();
    }

    return <String>[res, otp.toString()];
  }

  Future<String> loginUser(
      {required String email,
      required String password,
      required bool isAdmin}) async {
    String res = '';

    try {
      final bool userValid = await this
          ._firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then<bool>((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.docs[0].data()['isAdmin'] != isAdmin) {
          if (isAdmin == false) {
            res = 'Invalid Employee Email/Password combination';
          } else {
            res = 'Invalid Admin Email/Password combination';
          }
          print(res);

          return false;
        } else {
          return true;
        }
      }, onError: (dynamic err) {
        res = err.toString();
        return false;
      }).catchError((dynamic err) {
        if (err.runtimeType == IndexError) {
          res = "Invalid email address";
        }

        return false;
      });

      if (!userValid) {
        return res;
      }

      if (email.isNotEmpty && password.isNotEmpty) {
        await this
            ._auth
            .signInWithEmailAndPassword(email: email, password: password);
        res = 'LOGGED_IN';

        // TODO REMOVE LATER
        await this._auth.signOut();
      } else {
        res = 'Email or password field empty';
      }
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'invalid-email':
          {
            res = 'Invalid email address';
          }
          break;

        case 'user-disabled':
          {
            res =
                'The user account associated with this email has been disabled';
          }
          break;

        case 'user-not-found':
          {
            res = 'No user found for $email';
          }
          break;

        case 'wrong-password':
          {
            if (isAdmin == false) {
              res = 'Invalid Employee Email/Password combination';
            } else {
              res = 'Invalid Admin Email/Password combination';
            }
          }
          break;

        case 'too-many-requests':
          {
            res = "Too many failed login attempts, try again later";
          }
          break;

        default:
          {
            print(err.stackTrace);
            res = err.message!;
          }
          break;
      }

      print(res);
    } catch (err) {
      res = err.toString();
      print(res);
    }

    return res;
  }

  Future<int> sendEmail({required String email}) async {
    const String serviceId = 'service_q7npjbw';
    const String templateId = 'template_46rto3e';
    const String userId = 'x90CTEveScWKEsO4E';
    final int otp = Random().nextInt(9999);
    final String message =
        'The one-time password for resetting the password is: ${otp.toString().padLeft(4, '0')}';

    final Uri url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final http.Response _ = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(<String, Object>{
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': <String, String>{
            'email_recipient': email,
            'email_subject': 'Password Reset',
            'email_message': message,
          }
        }));

    return otp;
  }
}
