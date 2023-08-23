// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:inxee_hr_application/widgets/text_field_input.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('P R O F I L E'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey, //form
            child: Column(
              children: [
                SizedBox(height: 25),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Add Employee ',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),

                    TextFieldInput(
                      labeltext: 'Full Name',
                      textEditingController: _nameController,
                      textInputType: TextInputType.name,
                      prefix: Icon(Icons.person_rounded),
                    ),
                    SizedBox(height: 10.0),
                    TextFieldInput(
                      labeltext: 'Email',
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      prefix: Icon(Icons.email),
                    ),
                    SizedBox(height: 10.0),
                    TextFieldInput(
                      labeltext: 'Designation',
                      textEditingController: _designationController,
                      textInputType: TextInputType.text,
                      prefix: Icon(Icons.photo_camera_front_sharp),
                    ),
                    SizedBox(height: 10.0),
                    TextFieldInput(
                      labeltext: 'Password',
                      textEditingController: _passwordController,
                      textInputType: TextInputType.text,
                      prefix: Icon(Icons.password),
                    ),
                    SizedBox(height: 10.0),

                    TextFieldInput(
                      labeltext: 'Confirm Password',
                      textEditingController: _passwordController,
                      textInputType: TextInputType.text,
                      prefix: Icon(Icons.password),
                    ),

                    //
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
