import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_basis/services/globals.dart';
import 'package:star_basis/widgets/app_bar.dart';

import 'package:http/http.dart' as http;

import '../screens/login_page.dart';
import '../services/centers_service.dart';
import '../services/customer_groups.dart';

class AddNewGroup extends StatefulWidget {
  const AddNewGroup({Key? key}) : super(key: key);

  @override
  State<AddNewGroup> createState() => _AddNewGroupState();
}

class _AddNewGroupState extends State<AddNewGroup> {
  final _formKey = GlobalKey<FormState>();

  late String _groupName;
  late String _groupDesc;
  late String _centerId;
  late List centersList;

  bool isLoading = true;
  late String _buttonText = 'Create a Group';

  addGroupsHandler(groupName, groupDesc, centerId) async {
    http.Response response = await CustomerGroupServices.addGroup(groupName, groupDesc,centerId);
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      successSnackBar(context, responseMap['message']);
      setState(() {
        isLoading = false;
        _buttonText = 'Create a Group';
      });
      _formKey.currentState?.reset();
    } else {
      setState(() {
        isLoading = false;
        _buttonText = 'Create a Group';
      });
      if (response.statusCode == 500) {
        Route route =  MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    }
  }
  getAllCenters() async {
    http.Response response = await CentersService.allCenters();
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        centersList = responseMap['centers'];
        isLoading = false;
      });
    } else {
      if (response.statusCode == 401) {
        Route route =
        MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        errorSnackBar(context, responseMap['error']);
      }
    }
  }


  @override
  void initState() {
    getAllCenters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Register new group'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Group Name',
                          hintText: "Bodubalasena",
                          hintStyle: TextStyle(
                            color: Colors.black54.withOpacity(0.3),
                          ),
                          labelStyle: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.lightGreen,
                            fontSize: 17,
                          )),
                      onChanged: (String? value) {
                        _groupName = value!;
                      },
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Group Name is required please enter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Group Description',
                          hintText: "This is group description..",
                          hintStyle: TextStyle(
                            color: Colors.black54.withOpacity(0.3),
                          ),
                          labelStyle: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.lightGreen,
                            fontSize: 17,
                          )),
                      onChanged: (value) {
                        _groupDesc = value;
                      },
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Address is required please enter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Column(
                      children: [
                        DropdownButton(
                          items: isLoading ? centersList.map((dynamic center) {
                            return DropdownMenuItem<String>(
                              value: center['id'].toString(),
                              child: Text(center['center_name'].toString()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _centerId = value!;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            minimumSize: const Size.fromHeight(60),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right:30,left: 20),
                                  child: Text(
                                    _buttonText,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                isLoading ? const SizedBox(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                  width: 30,
                                  height: 30,
                                ): const Text(''),
                              ]),
                          onPressed: () {
                            // It returns true if the form is valid, otherwise returns false
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a Snackbar.
                              setState(() {
                                _buttonText = 'Adding group..';
                                isLoading = true;
                              });
                              addGroupsHandler(_groupName, _groupDesc,_centerId);
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
