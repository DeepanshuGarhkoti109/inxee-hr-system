// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inxee_hr_application/Common_panels/attendance_page.dart';

import 'add_new_employee.dart';
import 'navigationbar_admin.dart';

class AdminEmployeeCheckInDetails extends StatefulWidget {
  const AdminEmployeeCheckInDetails({super.key});

  @override
  State<AdminEmployeeCheckInDetails> createState() =>
      _AdminEmployeeCheckInDetailsState();
}

class _AdminEmployeeCheckInDetailsState
    extends State<AdminEmployeeCheckInDetails> {
  BoxDecoration containerDecoration = BoxDecoration(
    border: Border.all(color: Colors.black38, width: 2),
    borderRadius: BorderRadius.circular(5),
    color: Colors.white,
  );

  List<Map<String, dynamic>> dataList = <Map<String, dynamic>>[];

  Future<void> getUsers() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference<Map<String, dynamic>> userDb =
        firestore.collection("users");

    await userDb.get().then(
      (querySnapshot) {
        dataList.clear();
        for (var doc in querySnapshot.docs) {
          dataList.add(<String, dynamic>{
            'fullName': doc.data()['fullName'],
            'phoneNumber': doc.data()['phoneNumber'],
            'email': doc.data()['email'],
            'address': doc.data()['address'],
            'sex': doc.data()['sex'],
            'dateOfBirth': doc.data()['dob'],
            'designation': doc.data()['designation'],
            'dateOfJoining': doc.data()['dateOfJoining'],
            'age': doc.data()['age'],
          });
        }
        print("Done!");

        print(dataList);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // checkSlideCount();

    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('C H E C K - I N   D E T A I L S'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(Icons.add_box_sharp),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEmployeePage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: NavigationDrawerAdmin(),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        decoration: containerDecoration,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Scaffold(
                                      backgroundColor: Colors.white,
                                      appBar: AppBar(
                                        backgroundColor: Colors.black,
                                        elevation: 0,
                                        centerTitle: true,
                                        title: Text('A T T E N D A N C E'),
                                      ),
                                      body: AttendancePage(
                                          email: dataList[index]['email']
                                              .toString()));
                                },
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1517423738875-5ce310acd3da?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1970&q=80',
                            ),
                          ),
                          title: Text(
                            dataList[index]['fullName'],
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                          subtitle: Text(
                            dataList[index]['designation'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
