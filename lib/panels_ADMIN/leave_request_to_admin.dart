// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplyLeaveToAdmin extends StatefulWidget {
  const ApplyLeaveToAdmin({Key? key}) : super(key: key);

  @override
  State<ApplyLeaveToAdmin> createState() => _ApplyLeaveToAdminState();
}

class _ApplyLeaveToAdminState extends State<ApplyLeaveToAdmin> {
  String _testValues = '28/02/2024';

  static BoxDecoration containerDecoration = BoxDecoration(
    border: Border.all(color: Colors.black),
    borderRadius: BorderRadius.circular(12),
  );

  static const TextStyle textStyle =
      TextStyle(fontSize: 16, color: Colors.black);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: containerDecoration,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.black,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1517423738875-5ce310acd3da?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1970&q=80',
                          ),
                        ),
                        title: Text(
                          'Deepanshu Garhkoti',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        subtitle: Text(
                          'deepanshugarhkoti@gmail.com',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoContainerL('Total Days : 75'),
                        const SizedBox(width: 50),
                        _buildInfoContainerR('Total Leave : 75'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoContainerL('Paid Leave : 05'),
                        const SizedBox(width: 50),
                        _buildInfoContainerR('Unpaid Leave : 5'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildSelectedInfoContainer(
                      'Selected date: ',
                      // _selectedDate,
                      _testValues,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
        ),
      );

  Widget _buildInfoContainerR(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade300,
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }

  Widget _buildInfoContainerL(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade300,
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }

  Widget buildSelectedInfoContainer(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade300,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                label,
                style: textStyle,
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.actor(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
