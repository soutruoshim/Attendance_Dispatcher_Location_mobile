import 'dart:io';

import 'package:hr_dispatcher/widget/buttonborder.dart';
import 'package:hr_dispatcher/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:hr_dispatcher/provider/profileprovider.dart';
import 'package:hexcolor/hexcolor.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/editprofile';

  @override
  State<StatefulWidget> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  int genderIndex = 0;

  bool isLoading = false;

  final _form = GlobalKey<FormState>();

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _form.currentState?.dispose();
    super.dispose();
  }

  String getGender() {
    var gender = '';
    switch (genderIndex) {
      case 0:
        gender = 'male';
        break;
      case 1:
        gender = 'female';
        break;
      case 2:
        gender = 'others';
        break;
    }

    return gender;
  }

  void validateValue() async {
    final value = _form.currentState!.validate();

    if (value) {
      isLoading = true;
      setState(() {
        EasyLoading.show(
            status: "Changing", maskType: EasyLoadingMaskType.black);
      });
      final response =
          await Provider.of<ProfileProvider>(context, listen: false)
              .updateProfile(
                  _nameController.text,
                  _emailController.text,
                  _addressController.text,
                  _dobController.text,
                  getGender(),
                  _phoneController.text,
                  File(''));

      if (!mounted) {
        return;
      }
      isLoading = false;
      setState(() {
        EasyLoading.dismiss(animation: true);
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
      }
    }
  }

  var initial = true;

  @override
  void didChangeDependencies() {
    if (initial) {
      final profile = Provider.of<ProfileProvider>(context).profile;
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _addressController.text = profile.address;
      _phoneController.text = profile.phone;
      _dobController.text = profile.dob;

      switch (profile.gender.toLowerCase()) {
        case 'male':
          genderIndex = 0;
          break;
        case 'female':
          genderIndex = 1;
          break;
        case 'others':
          genderIndex = 2;
          break;
        default:
          genderIndex = 0;
          break;
      }
      setState(() {});
      initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text('EditProfile'),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: HexColor("#036eb7"),
                    shape: ButtonBorder(),
                    fixedSize: Size(double.maxFinite, 55)),
                onPressed: () {
                  validateValue();
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          body: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Fullname',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon:
                            Icon(Icons.phone_android, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _dobController,
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Date of Birth',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.calendar_month_sharp,
                            color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _dobController.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ToggleSwitch(
                            borderWidth: 1,
                            borderColor: [Colors.white12],
                            dividerColor: Colors.white12,
                            activeBgColor: const [Colors.white12],
                            activeFgColor: Colors.white,
                            inactiveFgColor: Colors.white,
                            inactiveBgColor: Colors.transparent,
                            minWidth: 100,
                            minHeight: 45,
                            initialLabelIndex: genderIndex,
                            totalSwitches: 3,
                            onToggle: (index) {
                              genderIndex = index!;
                            },
                            labels: const ['Male', 'Female', 'Other'],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
