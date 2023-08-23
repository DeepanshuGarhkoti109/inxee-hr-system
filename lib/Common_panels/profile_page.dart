// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, no_leading_underscores_for_local_identifiers, avoid_print, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inxee_hr_application/widgets/button_input.dart';
import 'package:inxee_hr_application/widgets/dropdown_button.dart';
import 'package:inxee_hr_application/widgets/text_field_input.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateofbirthController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _dateofjoiningController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final profileData = {};

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _dateofbirthController.dispose();
    _designationController.dispose();
    _dateofjoiningController.dispose();
    _ageController.dispose();
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email') ?? 'NAME';
    print(email);

    return email;
  }

  Future<void> getProfile() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final CollectionReference<Map<String, dynamic>> userDb =
        _firestore.collection('users');

    await userDb
        .where('email', isEqualTo: await getEmail())
        .get()
        .then((querySnapshot) async {
      final data = querySnapshot.docs[0].data();
      profileData.addAll({
        'fullName': data['fullName'] as String,
        'phoneNumber': data['phoneNumber'] as String,
        'email': data['email'],
        'address': data['address'],
        'dob': data['dob'],
        'designation': data['designation'],
        'dateOfJoining': data['dateOfJoining'],
        'age': data['age']
      });
    });

    print(profileData);
    print(profileData['fullName']);
  }

  Future<void> updateProfile(newProfile) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final CollectionReference<Map<String, dynamic>> userDb =
        _firestore.collection('users');

    await userDb
        .where('email', isEqualTo: await getEmail())
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs[0].reference.update(newProfile);
    });

    print(profileData);
    print(profileData['fullName']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      //appbar

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('P R O F I L E'),
      ),

      //
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey, //form
              child: Column(
                children: [
                  SizedBox(height: 10),

                  //circleavatar for photo
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1438283173091-5dbf5c5a3206?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZnVubnl8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60'),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  //text field for full name

                  TextFieldInput(
                    labeltext: 'Full Name',
                    textEditingController: _fullNameController,
                    textInputType: TextInputType.name,
                    prefix: Icon(Icons.person_rounded),
                  ),
                  SizedBox(height: 15),

                  //text field for phone number

                  TextFieldInput(
                    labeltext: 'Phone Number',
                    prefix: Icon(Icons.phone),
                    textEditingController: _phoneNumberController,
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(height: 15),

                  TextFieldInput(
                    labeltext: 'Email',
                    prefix: Icon(Icons.email),
                    textEditingController: _emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),

                  TextFieldInput(
                    labeltext: 'Address',
                    prefix: Icon(Icons.location_on_rounded),
                    textEditingController: _addressController,
                    textInputType: TextInputType.streetAddress,
                  ),
                  SizedBox(height: 15),

                  //

                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: DropdownButtonWidget(
                          options: [
                            'Male',
                            'Female',
                            'Other'
                          ], // Define the list items here
                          prefix: Icon(Icons.person_2_outlined),
                          labeltext: 'Sex',
                          Length: 150,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 160,
                        child: TextFieldInput(
                          textEditingController: _dateofbirthController,
                          textInputType: TextInputType.datetime,
                          prefix: Icon(Icons.calendar_month_outlined),
                          labeltext: 'DOB',
                          hintText: 'yyyy/mm/dd',
                          onpressed: () async {
                            DateTime? pickeddate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));

                            if (pickeddate != null) {
                              setState(() {
                                _dateofbirthController.text =
                                    DateFormat('yyyy/MM/dd').format(pickeddate);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  TextFieldInput(
                    labeltext: 'Designation ',
                    prefix: Icon(Icons.photo_camera_front_sharp),
                    textEditingController: _designationController,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 15),

                  Row(
                    children: [
                      Container(
                        width: 210,
                        child: TextFieldInput(
                          textEditingController: _dateofjoiningController,
                          textInputType: TextInputType.datetime,
                          prefix: Icon(Icons.calendar_month_outlined),
                          labeltext: 'Date of joining',
                          hintText: 'yyyy/mm/dd',
                          onpressed: () async {
                            DateTime? pickeddate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));

                            if (pickeddate != null) {
                              setState(() {
                                _dateofjoiningController.text =
                                    DateFormat('yyyy/MM/dd').format(pickeddate);
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 100,
                        child: TextFieldInput(
                          labeltext: 'Age ',
                          prefix: Icon(Icons.calendar_today_rounded),
                          textEditingController: _ageController,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  //save button
                  SizedBox(height: 15),

                  ButtonInput(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Loading')),
                        );
                        updateProfile({
                          'fullName': _fullNameController.text,
                          'phoneNumber': _phoneNumberController.text,
                          'email': _emailController.text,
                          'address': _addressController.text,
                          'dob': Timestamp.fromDate(DateTime.parse(
                              _dateofbirthController.text
                                  .replaceAll('/', '-'))),
                          'designation': _designationController.text,
                          'dateOfJoining': Timestamp.fromDate(DateTime.parse(
                              _dateofjoiningController.text
                                  .replaceAll('/', '-'))),
                          'age': _ageController.text,
                        });
                      }
                    },
                    text: 'Save',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
