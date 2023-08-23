// ignore_for_file: prefer_const_constructors, unused_import

// TODO: FIX ADMIN ATTENDANCE
// TODO: ADD FUNCTIONALITY TO SEND EMAILS TO THE ADMIN FOR OTP
// TODO: ADD SALARY DETAILS

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inxee_hr_application/employee_panels/employee_panel.dart';
import 'package:inxee_hr_application/firebase_options.dart';
import 'package:inxee_hr_application/resources/leave_methods.dart';

import 'package:inxee_hr_application/screens/login_page_employee.dart';

import 'panels_ADMIN/admin_panel.dart';
import 'panels_ADMIN/leave_request_to_admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
