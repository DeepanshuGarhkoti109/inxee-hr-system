import 'package:flutter/material.dart';

class ApplyLeaveToAdmin extends StatefulWidget {
  const ApplyLeaveToAdmin({super.key});

  @override
  State<ApplyLeaveToAdmin> createState() => _ApplyLeaveToAdminState();
}

class _ApplyLeaveToAdminState extends State<ApplyLeaveToAdmin> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          height: 200,
          child: Text('Apply for leave to Admin'),
          color: Colors.blue,
        ),
      );
}
