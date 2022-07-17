import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/customers/select_member_group.dart';

import '../widgets/app_bar.dart';
import '../widgets/common_card_details_row.dart';
import '../widgets/custom_page_heading.dart';

class AddNewCustomers extends StatefulWidget {
  const AddNewCustomers({Key? key}) : super(key: key);

  @override
  State<AddNewCustomers> createState() => _AddNewCustomersState();
}

class _AddNewCustomersState extends State<AddNewCustomers> {
  final _formKey = GlobalKey<FormState>();

  late String _date;
  late List<bool> isSelected = [true, false];
  late bool married = true;
  late List<bool> gender = [true, false];
  late bool sexType = true;

// birth day date select adding here
  TextEditingController intialdateval = TextEditingController();

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2030));
    if (picked != null) {
      setState(() => {
            _date = picked.toString(),
            intialdateval.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(_date).toLocal())
          });
    }
  }

// Label common Styles
  final _labelStyle = TextStyle(
    fontFamily: 'Inter',
    color: Colors.black.withOpacity(0.5),
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Add New Customer'),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CustomPageHeading(smallHeading: 'ADD NEW', headerLargeText: 'CUSTOMERS'),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20, bottom: 100, left: 20, right: 20),
                child: Column(
                  children: [
                    CommonCardUserRow(rowHeading: '', rowValue: 'PERSONAL DETAILS :'),
                    Form(
                      key: _formKey,
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//full name with initials
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full name with Initials',
                            hintText: "W D Mdushanka",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Name is required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Permanent Address
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Permanent Address',
                            hintText: "163-c, Raddolugama,Seeduwa",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Address is required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

// Date of birth
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Date Of Birth',
                            hintText: "1992 01 20",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                            suffixIcon: const Icon(Icons.today),
                          ),
                          keyboardType: TextInputType.phone,
                          autocorrect: false,
                          controller: intialdateval,
                          onSaved: (value) {
                            _date = value!.toString();
                          },
                          onTap: () {
                            _selectDate();
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          maxLines: 1,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 1) {
                              return 'Birthday is required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Customer age
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Age',
                            hintText: "40",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Age is required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Customer ID card
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Identity Card Number',
                            hintText: "94022930V",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Identity card number required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Job data
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Job',
                              hintText: "Software Engineer",
                              hintStyle: TextStyle(
                                color: Colors.black54.withOpacity(0.3),
                              ),
                              labelStyle: _labelStyle,
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
// _centerName = value;
                            }),

                        const SizedBox(
                          height: 20,
                        ),

//Month income
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Monthly Income',
                            hintText: "50000",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Mobile number is require!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 50,
                        ),

//Gender collect
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ToggleButtons(
                            borderColor: Colors.black,
                            fillColor: Colors.green.withOpacity(0.2),
                            borderWidth: 2,
                            selectedBorderColor: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Male',
                                  style: _labelStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Female',
                                  style: _labelStyle,
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < gender.length; i++) {
                                  gender[i] = i == index;
                                  if (index == 0) {
                                    sexType = true;
                                  } else {
                                    sexType = false;
                                  }
                                }
                              });
                            },
                            isSelected: gender,
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

//Married or Unmarried
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ToggleButtons(
                            borderColor: Colors.black,
                            fillColor: Colors.green.withOpacity(0.2),
                            borderWidth: 2,
                            selectedBorderColor: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Married',
                                  style: _labelStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Single',
                                  style: _labelStyle,
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                  if (index == 0) {
                                    married = true;
                                  } else {
                                    married = false;
                                  }
                                }
                              });
                            },
                            isSelected: isSelected,
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        married
                            ? Column(
                                children: [
                                  CommonCardUserRow(rowHeading: '', rowValue: 'SUPPOSE DETAILS :'),

//Suppose Name
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Suppose Full Name',
                                      hintText: "W M Lorem ipsum",
                                      hintStyle: TextStyle(
                                        color: Colors.black54.withOpacity(0.3),
                                      ),
                                      labelStyle: _labelStyle,
                                    ),
                                    onChanged: (value) {
// _centerName = value;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

//Suppose Job details
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Suppose Job',
                                      hintText: "Title of the job",
                                      hintStyle: TextStyle(
                                        color: Colors.black54.withOpacity(0.3),
                                      ),
                                      labelStyle: _labelStyle,
                                    ),
                                    onChanged: (value) {
// _centerName = value;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

//Suppose Land number
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Suppose Phone Number',
                                      hintText: "0112123456",
                                      hintStyle: TextStyle(
                                        color: Colors.black54.withOpacity(0.3),
                                      ),
                                      labelStyle: _labelStyle,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {
// _centerName = value;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

//Customer ID card
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Suppose Identity Card Number',
                                      hintText: "94022930V",
                                      hintStyle: TextStyle(
                                        color: Colors.black54.withOpacity(0.3),
                                      ),
                                      labelStyle: _labelStyle,
                                    ),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
// _centerName = value;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : Container(),

                        CommonCardUserRow(rowHeading: '', rowValue: 'CONTACT DETAILS :'),

//Customer Land number
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Land Phone Number',
                            hintText: "0112123456",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Mobile number is require!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Customer Mobile
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Mobile Phone Number',
                            hintText: "0774123391",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Mobile number is require!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Customer Office Number
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Office Number',
                            hintText: "0112123456",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
// _centerName = value;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        CommonCardUserRow(rowHeading: '', rowValue: 'BANK DETAILS :'),

//Bank Name
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Bank Name',
                            hintText: "Bank of Ceylon",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Bank name is require!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Bank Account Number
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Bank Account Number',
                            hintText: "12345678",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Bank account number is required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//Branch Name
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Branch Name',
                            hintText: "Account opened branch name",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Branch name is required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        CommonCardUserRow(rowHeading: '', rowValue: 'OFFICIAL DATA :'),

//Branch Name
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Electricity Bill Number',
                            hintText: "Account number of CEB",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
// _centerName = value;
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Electricity bill number required!';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        GestureDetector(
													onTap: () async {
														showModalBottomSheet(
															backgroundColor: Colors.transparent,
															context: context,
															builder: (BuildContext context) {
																return Container(
																	height: MediaQuery.of(context).size.height,
																	padding: const EdgeInsets.all(20),
																	decoration: const BoxDecoration(
																		color: Colors.white,
																		borderRadius: BorderRadius.only(
																				topLeft: Radius.circular(30),
																				topRight: Radius.circular(30)),
																	),
																	child: SelectMemberGroup(
                                    onTap: () {
                                      print('ss');
                                    },
                                  ),
																);
															},
														);
													},
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: const Text(
                              'Add this member to a Group',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

// DropdownButton(
//   items: centersList.map((dynamic center) {
//     return DropdownMenuItem<String>(
//       value: center['id'].toString(),
//       child: Text(center['center_name'].toString()),
//     );
//   }).toList(),
//   hint: const Text("Select a Center"),
//   value: _centerId,
//   onChanged: (String? value) {
//     setState(() {
//       // _centerId = value!;
//     },);
//   },
// )
                      ]),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
