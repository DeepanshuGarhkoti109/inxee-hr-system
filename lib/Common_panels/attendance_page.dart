// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors, avoid_print, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

class AttendancePage extends StatefulWidget {
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  const AttendancePage({Key? key, this.checkInTime, this.checkOutTime})
      : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);
  DateTime selectedDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  List<String> attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    getAttendance();
    // loadAttendanceHistory();
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email') ?? 'NAME';
    print(email);

    return email;
  }

  Future<void> getAttendance() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    attendanceHistory.clear();

    final CollectionReference<Map<String, dynamic>> userDb =
        _firestore.collection('users');

    await userDb
        .where('email', isEqualTo: await getEmail())
        .get()
        .then((querySnapshot) async {
      await querySnapshot.docs[0].reference
          .collection('attendance')
          .get()
          .then((querySnapshot) {
        for (final doc in querySnapshot.docs) {
          final DateTime entryTime =
              (doc.data()["entry"] as Timestamp).toDate();
          final DateTime? exitTime = doc.data()["exit"].runtimeType == Timestamp
              ? (doc.data()["entry"] as Timestamp).toDate()
              : null;
          attendanceHistory.add('$entryTime\n$exitTime');
        }
      });
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('attendanceHistory', []);
    await prefs.setStringList('attendanceHistory', attendanceHistory);

    saveAttendanceHistory();
  }

  Future<void> loadAttendanceHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    attendanceHistory = prefs.getStringList('attendanceHistory') ?? [];
  }

  Future<void> saveAttendanceHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('attendanceHistory'));
    await prefs.setStringList('attendanceHistory', []);

    String checkInTimeString = DateFormat('HH:mm').format(DateTime.now());
    String checkOutTimeString = widget.checkOutTime != null
        ? DateFormat('HH:mm').format(widget.checkOutTime!)
        : '';

    // Append check-in and check-out times to the attendance history list
    attendanceHistory.add('$checkInTimeString\n$checkOutTimeString');

    // Save the attendance history list to shared preferences
    await prefs.setStringList('attendanceHistory', attendanceHistory);
  }

  Future<String> getFormattedTime(
      DateTime? time, DateTime currentDate, bool isCheckIn) async {
    if (time != null &&
        time.year == currentDate.year &&
        time.month == currentDate.month &&
        time.day == currentDate.day) {
      return DateFormat('HH:mm a').format(time);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? lines = prefs.getStringList('attendanceHistory');
      print(lines);

      if (lines != null) {
        for (String line in lines) {
          if (line.isNotEmpty) {
            List<String> times = line.split('\n');
            if (times.length == 2) {
              DateTime checkInTime = DateTime.parse(times[0]);
              DateTime checkOutTime = DateTime.parse(times[1]);

              print(times);
              if (isCheckIn) {
                if (checkInTime.year == currentDate.year &&
                    checkInTime.month == currentDate.month &&
                    checkInTime.day == currentDate.day) {
                  return DateFormat('HH:mm a').format(checkInTime);
                }
              } else {
                if (checkOutTime.year == currentDate.year &&
                    checkOutTime.month == currentDate.month &&
                    checkOutTime.day == currentDate.day) {
                  return DateFormat('HH:mm a').format(checkOutTime);
                }
              }
            }
          }
        }
      }

      return '--/--';
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<void>(
      future: loadAttendanceHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    "My Attendance",
                    style: TextStyle(
                      fontFamily: "Trajan Pro",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 32),
                      child: Text(
                        DateFormat('MMMM').format(selectedDate),
                        style: TextStyle(
                          fontFamily: "Trajan Pro",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 300,
                                child: DatePickerWidget(
                                  initialDateTime: selectedDate,
                                  minDateTime: DateTime.now()
                                      .subtract(Duration(days: 365)),
                                  maxDateTime:
                                      DateTime.now().add(Duration(days: 365)),
                                  dateFormat: "MMMM yyyy",
                                  pickerTheme: DateTimePickerTheme(
                                    confirm: Text("Done"),
                                    cancel: Text("Cancel"),
                                  ),
                                  onChange: (dateTime, selectedIndex) {
                                    setState(() {
                                      selectedDate = dateTime;
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          "Pick a Month",
                          style: TextStyle(
                            fontFamily: "Trajan Pro",
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight -
                      screenHeight / 5 -
                      MediaQuery.of(context).padding.bottom,
                  child: ListView.builder(
                    itemCount:
                        DateTime(selectedDate.year, selectedDate.month + 1, 0)
                            .day,
                    itemBuilder: (context, index) {
                      DateTime currentDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        index + 1,
                      );

                      return Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('EEE').format(currentDate),
                                      style: TextStyle(
                                        fontFamily: "Trajan Pro",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      currentDate.day.toString(),
                                      style: TextStyle(
                                        fontFamily: "Trajan Pro",
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Check-In",
                                    style: TextStyle(
                                      fontFamily: "Trajan Pro",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FutureBuilder<String>(
                                    future: getFormattedTime(
                                        widget.checkInTime, currentDate, true),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        String formattedTime =
                                            snapshot.data ?? '--/--';
                                        return Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontFamily: "Trajan Pro",
                                            fontSize: 18,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Check-Out",
                                    style: TextStyle(
                                      fontFamily: "Trajan Pro",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FutureBuilder<String>(
                                    future: getFormattedTime(
                                        widget.checkOutTime,
                                        currentDate,
                                        false),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        String formattedTime =
                                            snapshot.data ?? '--/--';
                                        return Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontFamily: "Trajan Pro",
                                            fontSize: 18,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                    height: 50), // Add a blank transparent box for extra space
              ],
            ),
          ),
        );
      },
    );
  }
}
