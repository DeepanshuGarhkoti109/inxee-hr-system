import 'package:flutter/material.dart';

class AttendanceAdminPage extends StatefulWidget {
  const AttendanceAdminPage({super.key});

  @override
  State<AttendanceAdminPage> createState() => _AttendanceAdminPageState();
}

class _AttendanceAdminPageState extends State<AttendanceAdminPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          height: 200,
          child: Text('Attendance PAGE ADMIN'),
          color: Colors.amber,
        ),
      );
}
