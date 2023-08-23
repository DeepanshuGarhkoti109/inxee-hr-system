// ignore_for_file: prefer_const_constructors, unused_import, unused_field, prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:inxee_hr_application/resources/leave_methods.dart';

class ApplyLeaveToAdmin extends StatefulWidget {
  const ApplyLeaveToAdmin({Key? key}) : super(key: key);

  @override
  State<ApplyLeaveToAdmin> createState() => _ApplyLeaveToAdminState();
}

class _ApplyLeaveToAdminState extends State<ApplyLeaveToAdmin> {
  String _testValues = '28/02/2024';
  String _testrangeCount = '5';
  String _applicationTitleController = 'Leave title';
  Map mapping = {};
  Map userLeaves = {};

  static BoxDecoration containerDecoration = BoxDecoration(
    border: Border.all(
      color: Colors.black,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration subcontainerDecoration = BoxDecoration(
    border: Border.all(color: Colors.black, width: 10),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
    color: Colors.black,
  );

  static const TextStyle textStyle =
      TextStyle(fontSize: 16, color: Colors.black);

  @override
  void initState() {
    super.initState();
    getLeaveData();
  }

  Future<void> getLeaveData() async {
    mapping = await LeaveMethods().getLeaveApps();
    userLeaves = await LeaveMethods().getLeavesAllUsers();

    List badkeys = [];

    for (var m in mapping.keys) {
      if (mapping[m]['approved']) {
        badkeys.add(m);
      }
    }

    for (var key in badkeys) {
      mapping.remove(key);
    }

    print("mapping: $mapping");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: FutureBuilder(
            future: getLeaveData(),
            builder: ((context, snapshot) {
              return ListView.separated(
                itemCount: mapping.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentKey = mapping.keys.toList()[index];
                  final currentLeave = mapping[currentKey];
                  final currentUserLeaves =
                      userLeaves[mapping[currentKey]["email"]];
                  print(currentUserLeaves);

                  print(currentLeave["approved"]);

                  // if (!currentLeave["approved"]) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        decoration: containerDecoration,
                        child: Column(
                          children: [
                            Container(
                              decoration: subcontainerDecoration,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1517423738875-5ce310acd3da?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1970&q=80',
                                  ),
                                ),
                                title: Text(
                                  currentKey,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${currentLeave["email"]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildInfoContainerL(
                                    'CL : ${currentUserLeaves["CL"]}'),
                                const SizedBox(width: 20),
                                _buildInfoContainerR(
                                    'EL : ${currentUserLeaves["EL"]}'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildInfoContainerL(
                                    'SL : ${currentUserLeaves["SL"]}'),
                                const SizedBox(width: 20),
                                _buildInfoContainerR(
                                    'LWP : ${currentUserLeaves["LWP"]}'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            buildSelectedInfoContainer(
                              'Selected dates: ',
                              // _selectedDate,
                              '${DateFormat("dd/MM/yyyy").format(currentLeave["start"])} to ${DateFormat("dd/MM/yyyy").format(currentLeave["end"])}',
                            ),
                            const SizedBox(height: 10),
                            buildSelectedInfoContainer(
                              'No. of days: ',
                              '${currentLeave["end"].difference(currentLeave["start"]).inDays}',
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _applicationForLeave,
                              child: buildSelectedInfoContainer(
                                'Application: ',
                                '${currentLeave["title"]}: ${currentLeave["application"]}',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Date of Application: ${DateFormat('dd/MM/yyyy').format(currentLeave["dateOfApplication"].toDate())}',
                                    style: textStyle,
                                  ),
                                ),
                                submitAndCancelButton(lId: currentKey),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  );
                  // }
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              );
            }),
          )));

  Widget _buildInfoContainerR(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 20, bottom: 20),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  Widget _buildInfoContainerL(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  Widget buildSelectedInfoContainer(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    );
  }

  void _applicationForLeave() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Application'),
          content: Text(
              'sdasdhckscbsknchsdbxcjkcuidbchabxchjdbxcuvdc bhxbc dcasbcgasvcsah cas cscfsytcsachavschsv  sgvcyts cscv yatscscsctsgc c'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget submitAndCancelButton({required String lId}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              border: Border.all(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              iconSize: 20,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Cancel Application'),
                      content: Text(
                          'Are you sure you want to cancel the leave application?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            //
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.close_sharp,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              iconSize: 20,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Accept Application'),
                      content: Text(
                          'Are you sure you want to accept the leave application?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: Text('Accept'),
                          onPressed: () async {
                            await LeaveMethods().approveLeave(lId: lId);
                            await getLeaveData();
                            Navigator.of(context).pop(); // Close the dialog
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
