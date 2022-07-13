import 'dart:convert';

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
  late String _centerId = '-1';
  static const defArr  = {'id':-1,'center_name':'Select a Center'};
  late List centersList = [];

  bool isLoading = true;
  // add group message before btn click
  final String _addGroupText   = 'Create a Group';
  // adding group message after btn click
  final String _addingGroupText   = 'Creating a Group';
  late String _buttonText = _addGroupText;

  addGroupsHandler(groupName, groupDesc, centerId) async {
    http.Response response = await CustomerGroupServices.addGroup(groupName, groupDesc,centerId);
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      successSnackBar(context, responseMap['message']);
      setState(() {
        isLoading = false;
        _buttonText = 'Create a Group';
        _centerId = '-1';
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
        centersList = [defArr,...centersList];
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
                          hintText: "Pipena Kakulu",
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
                          return 'Group Description is required please enter';
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
                          items: centersList.map((dynamic center) {
                            return DropdownMenuItem<String>(
                              value: center['id'].toString(),
                              child: Text(center['center_name'].toString()),
                            );
                          }).toList(),
                          hint: const Text("Select a Center"),
                          value: _centerId,
                          onChanged: (String? value) {
                            setState(() {
                              _centerId = value!;
                            },);
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
                              setState(() {
                                _buttonText = _addingGroupText;
                                isLoading = true;
                              });
                              if (_centerId == '-1'){
                                setState(() {
                                  _buttonText = _addGroupText;
                                  isLoading = false;
                                });
                                errorSnackBar(context, 'Please select a center');
                              }else{
                                addGroupsHandler(_groupName, _groupDesc,_centerId);
                              }
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
