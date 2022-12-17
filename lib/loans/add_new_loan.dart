import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/loans/select_loan_customer.dart';
import 'package:star_basis/loans/select_loan_product.dart';

import '../screens/login_page.dart';
import '../services/globals.dart';
import '../services/loans.dart';
import '../widgets/app_bar.dart';
import '../widgets/common_card_details_row.dart';
import '../widgets/custom_page_heading.dart';
import '../widgets/loading_widget.dart';
import 'loan_confirmation.dart';
class AddNewLoan extends StatefulWidget {
  const AddNewLoan({Key? key}) : super(key: key);

  @override
  State<AddNewLoan> createState() => _AddNewLoanState();
}

class _AddNewLoanState extends State<AddNewLoan> {
  // adding group message after btn click
  late String _btnText   = 'Create Loan';
  late bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  // Label common Styles
  final _labelStyle = TextStyle(
    fontFamily: 'Inter',
    color: Colors.black.withOpacity(0.5),
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  late String loanAmount = '0';
  late String loanDuration = '0';
  late String _date;
  late String loanStartDate;
  late String selectedLoanProduct = '0';
  late String loanProduct   = '0';
  // Loan Customer
  late String selectedLoanCustomer = '0';
  late String loanCustomer = '0';

  TextEditingController initialDateValue = TextEditingController();

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2030));
    if (picked != null) {
      setState(() => {
        _date = picked.toString(),
        initialDateValue.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(_date).toLocal()),
        loanStartDate = initialDateValue.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Create Loan Product'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomPageHeading(smallHeading: 'ADD NEW', headerLargeText: 'LOAN'),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 20, bottom: 100, left: 20, right: 20),
              child: Column(
                children: [
                  CommonCardUserRow(rowHeading: '', rowValue: 'PRODUCT DETAILS :'),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Loan Amount
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Loan Amount',
                            hintText: "20000",
                            suffixText: 'Rs',
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState((){
                              loanAmount = value.toString();
                            });
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Loan amount is required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox( height: 20, ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Loan Durations',
                            hintText: "4",
                            suffixText: 'Months',
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            loanDuration = value.toString();
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter loan Duration!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox( height: 20, ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Loan Start Date',
                            hintText: "1992 01 20",
                            hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                            ),
                            labelStyle: _labelStyle,
                            suffixIcon: const Icon(Icons.today),
                          ),
                          keyboardType: TextInputType.phone,
                          autocorrect: false,
                          controller: initialDateValue,
                          onSaved: (value) {
                            _date = value.toString();
                          },
                          onTap: () {
                            _selectDate();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          maxLines: 1,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Loan Start Date is required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox( height: 20, ),
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled:true,
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height-150,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30)),
                                  ),
                                  child: SelectLoanProducts(
                                    onTap: (String value) {
                                      setState(() {
                                        selectedLoanProduct = value.toString();
                                        loanProduct = selectedLoanProduct;
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    activeColor: selectedLoanProduct,
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                              margin: const EdgeInsets.only(top: 20, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueGrey,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Select a Loan Product',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  selectedLoanProduct == '0' ?
                                  const Icon(Icons.add,color: Colors.white,)
                                      :
                                  const Icon(
                                      Icons.check_box,
                                      color:Colors.white
                                  ),
                                ],
                              )
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled:true,
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height-150,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  ),
                                  child: SelectLoanCustomer(
                                    onTap: (String value) {
                                      setState(() {
                                        selectedLoanCustomer = value.toString();
                                        loanCustomer = selectedLoanCustomer;
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    activeColor: selectedLoanCustomer,
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
                                color: Colors.black87,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Select a Customer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  selectedLoanCustomer == '0' ?
                                  const Icon(
                                    Icons.add,color: Colors.white,
                                  )
                                      :
                                  const Icon(
                                      Icons.check_box,
                                      color:Colors.white
                                  ),
                                ],
                              )
                          ),
                        ),
                        const SizedBox( height: 50, ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            minimumSize: const Size.fromHeight(60),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right:30,left: 20),
                                  child: Text(
                                    _btnText,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                isLoading ?
                                const LoadingWidget()
                                    :
                                const Text(''),
                              ]),
                          onPressed: () {
                            // It returns true if the form is valid, otherwise returns false
                            if (_formKey.currentState!.validate()) {
                              if(loanProduct != '0') {
                                if (loanCustomer != '0') {
                                  setState(() {
                                    isLoading = false;
                                    _btnText = 'Create Loan';
                                  });
                                  createNewLoan(
                                      loanAmount,
                                      loanDuration,
                                      loanStartDate,
                                      loanProduct,
                                      loanCustomer
                                  );
                                } else {
                                  errorSnackBar(context, 'Please Select a loan customer!');
                                }
                              }else{
                                errorSnackBar(context, 'Please Select a loan Product to process!');
                              }
                            }else{
                              errorSnackBar(context, 'Please fill all the required fields!');
                            }
                          },
                        )
                      ],
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  createNewLoan(
      String loanAmount,
      String loanDuration,
      String loanStartDate,
      String loanProduct,
      String loanCustomer ) async {

    Map<String,dynamic> data = {
      'l_amount':loanAmount,
      'l_duration':loanDuration,
      'l_start': loanStartDate,
      'l_product':loanProduct,
      'l_customer':loanCustomer,
      'is_save': 0,
    };

    var response = await LoansService.createNewLoans(data);
    if (response.statusCode == 200) {
      if (!mounted) return;
      successSnackBar(context, response.data['message']);
      setState(() {
        isLoading = false;
        _btnText = 'Create Loan';
      });
      // get confirmation before save loan data
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled:true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height-150,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)),
            ),
            child: LoanConfirmation(response: response.data),
          );
        },
      );
      // _formKey.currentState?.reset();
    } else {
      setState(() {
        isLoading = false;
        _btnText = 'Create Loan';
      });
      if (response.statusCode == 500) {
        if (!mounted) return;
        Route route =  MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        if (!mounted) return;
        Map<String,dynamic> errors  = response.data;
        errorSnackBar(context, errors['error']);
      }
    }

  }
}
