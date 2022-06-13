import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_basis/services/globals.dart';
import 'package:star_basis/widgets/app_bar.dart';

import 'package:http/http.dart' as http;

import '../screens/login_page.dart';
import '../services/centers_service.dart';

class EditCenters extends StatefulWidget {
  String centerId,centerName,centerAddress;

  EditCenters({Key? key, required this.centerId, required this.centerName, required this.centerAddress,}) : super(key: key);

  @override
  State<EditCenters> createState() => _EditCentersState();
}

class _EditCentersState extends State<EditCenters> {
  final _formKey = GlobalKey<FormState>();

  late String _centerName;
  late String _centerAddress;

  bool isLoading = false;
  late String _buttonText = 'Edit a Center';

  addCentersHandler(centerName, centerAddress) async {
    http.Response response =
        await CentersService.addCenters(centerName, centerAddress);
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      successSnackBar(context, responseMap['message']);
      setState(() {
        isLoading = false;
        _buttonText = 'Create a Center';
      });
      _formKey.currentState?.reset();
    } else {
      setState(() {
        isLoading = false;
        _buttonText = 'Create a Center';
      });
      if (response.statusCode == 500) {
        Route route =
            MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Add New Center'),
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
                      controller: TextEditingController()..text = widget.centerName,
                      decoration: InputDecoration(
                          labelText: 'Center Name',
                          hintText: "Anamaduwa",
                          hintStyle: TextStyle(
                            color: Colors.black54.withOpacity(0.3),
                          ),
                          labelStyle: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.lightGreen,
                            fontSize: 17,
                          )),
                      onChanged: (value) {
                        _centerName = value;
                      },
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Center Name is required please enter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: TextEditingController()..text = widget.centerAddress,
                      decoration: InputDecoration(
                          labelText: 'Center Address',
                          hintText: "Colombo Road Seeduwa",
                          hintStyle: TextStyle(
                            color: Colors.black54.withOpacity(0.3),
                          ),
                          labelStyle: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.lightGreen,
                            fontSize: 17,
                          )),
                      onChanged: (value) {
                        _centerAddress = value;
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            minimumSize: const Size.fromHeight(60),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 30, left: 20),
                                  child: Text(
                                    _buttonText,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                isLoading
                                    ? const SizedBox(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                        width: 30,
                                        height: 30,
                                      )
                                    : const Text(''),
                              ]),
                          onPressed: () {
                            // It returns true if the form is valid, otherwise returns false
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a Snackbar.
                              setState(() {
                                _buttonText = 'Updating center..';
                                isLoading = true;
                              });
                              addCentersHandler(_centerName, _centerAddress);
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
