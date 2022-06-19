import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:star_basis/centers/centers_page.dart';

import '../services/centers_service.dart';
import '../services/globals.dart';
import '../widgets/app_bar.dart';
import '../widgets/big_text_widget.dart';
import '../widgets/label_text.dart';

class SingleGroup extends StatefulWidget {
  String centerId, centerName, centerAddress, centerUser, centerCreated;

  SingleGroup({Key? key,
    required this.centerId,
    required this.centerName,
    required this.centerAddress,
    required this.centerCreated,
    required this.centerUser})
      : super(key: key);

  @override
  State<SingleGroup> createState() {
    return _SingleGroupState();
  }
}

class _SingleGroupState extends State<SingleGroup> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.centerName,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BigTextWidget(
                        content: '#' + widget.centerId,
                        fontWeight: FontWeight.w700,
                        fontSize: 60,
                        colorCode: Colors.blueGrey,
                      ),
                    ],
                  ),
                  //center name is here
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      LabelText(content: 'Name :', fontSize: 18,colorCode: Colors.blueGrey,),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      LabelText(content: widget.centerName, fontSize: 22, colorCode: Colors.grey,),
                    ],
                  ),

                  //center address is here
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      LabelText(content: 'Address :', fontSize: 18,colorCode: Colors.blueGrey,),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      LabelText(content: widget.centerAddress, fontSize: 22, colorCode: Colors.grey,),
                    ],
                  ),

                  //center Creater is here
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      LabelText(content: 'Added By :', fontSize: 18,colorCode: Colors.blueGrey,),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      LabelText(content: widget.centerUser, fontSize: 22, colorCode: Colors.grey,),
                    ],
                  ),

                  //center Created Date is here
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      LabelText(content: 'Created Date :', fontSize: 18,colorCode: Colors.blueGrey,),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      LabelText(content: DateFormat.yMMMEd().format(
                          DateTime.parse(widget.centerCreated)
                              .toLocal()) , fontSize: 22, colorCode: Colors.grey,),
                    ],
                  ),


                  const SizedBox(
                    height: 30,
                  ),
                  isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightGreen,
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
          height: 70,
          width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.delete_forever),
                //child widget inside this button
                backgroundColor: Colors.redAccent,
                onPressed: () async {
                  // make after confirmation
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context, builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const LabelText(content: 'Please confirm to delete this center', fontSize: 18,colorCode: Colors.blueGrey,),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightGreen,
                                  // minimumSize: const Size.fromHeight(60),
                                ),
                                child: const Text('Confirm'),
                                onPressed: () async {
                                http.Response response = await CentersService.deleteCenters(widget.centerId);
                                Map responseMap = jsonDecode(response.body);
                                if (response.statusCode == 200) {
                                  successSnackBar(context, responseMap['message']);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const CentersPage()));
                                } else {
                                  Navigator.pop(context);
                                  errorSnackBar(context, responseMap['error']);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          const CentersPage()));
                                }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}
