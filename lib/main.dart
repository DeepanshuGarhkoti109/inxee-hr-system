import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inxee_hr_application/firebase_options.dart';
import 'package:inxee_hr_application/resources/leave_methods.dart';
import 'package:inxee_hr_application/panels_ADMIN/admin_panel.dart';
import 'package:inxee_hr_application/screens/login_page_employee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // print(await LeaveMethods().getLeavesAllUsers());
  // await LeaveMethods().applyLeave(
  //     email: 'admin@inxee.com',
  //     start: Timestamp.fromDate(DateTime.utc(2023, 07, 21)),
  //     end: Timestamp.fromDate(DateTime.utc(2023, 07, 23)));
  // print(await LeaveMethods().getLeaveApps());
  // await LeaveMethods().approveLeave(lId: 'Z3fRBOYlMeJbOY6V3KVN');

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
