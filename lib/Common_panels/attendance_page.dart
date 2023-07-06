// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

class AttendancePage extends StatefulWidget {
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  const AttendancePage({super.key, this.checkInTime, this.checkOutTime});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);
  DateTime selectedDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
                              minDateTime:
                                  DateTime.now().subtract(Duration(days: 365)),
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
                    DateTime(selectedDate.year, selectedDate.month + 1, 0).day,
                itemBuilder: (context, index) {
                  DateTime currentDate = DateTime(
                      selectedDate.year, selectedDate.month, index + 1);

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
                              Text(
                                widget.checkInTime != null
                                    ? DateFormat('HH:mm a')
                                        .format(widget.checkInTime!)
                                    : '--/--',
                                style: TextStyle(
                                  fontFamily: "Trajan Pro",
                                  fontSize: 18,
                                ),
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
                              Text(
                                widget.checkOutTime != null
                                    ? DateFormat('HH:mm a')
                                        .format(widget.checkOutTime!)
                                    : '--/--',
                                style: TextStyle(
                                  fontFamily: "Trajan Pro",
                                  fontSize: 18,
                                ),
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
            SizedBox(height: 50), // Add a blank transparent box for extra space
          ],
        ),
      ),
    );
  }
}
