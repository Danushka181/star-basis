import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/login_page.dart';
import '../services/globals.dart';
import '../services/loan_product_service.dart';
import '../widgets/app_bar.dart';
import '../widgets/common_card_details_row.dart';
import '../widgets/custom_page_heading.dart';
class LoanProductsAdd extends StatefulWidget {
  const LoanProductsAdd({Key? key}) : super(key: key);

  @override
  State<LoanProductsAdd> createState() => _LoanProductsAddState();
}

class _LoanProductsAddState extends State<LoanProductsAdd> {
  // adding group message after btn click
  late String _btnText   = 'Add Loan Product';
  late bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  // Label common Styles
  final _labelStyle = TextStyle(
    fontFamily: 'Inter',
    color: Colors.black.withOpacity(0.5),
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  late String loanProductName;
  late String maxLoanAmount;
  late String documentChargeRate;
  late String interestRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Create Loan Product'),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CustomPageHeading(smallHeading: 'ADD NEW', headerLargeText: 'LOAN PRODUCT'),
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
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Product Name',
                              hintText: "Basic Loans",
                              hintStyle: TextStyle(
                                color: Colors.black54.withOpacity(0.3),
                              ),
                              labelStyle: _labelStyle,
                            ),
                            onChanged: (value) {
                              loanProductName = value.toString();
                            },
                            validator: (String? value) {
                              if (value != null && value.isEmpty) {
                                return 'Name is required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox( height: 20, ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Interest Rate',
                              hintText: "11",
                              suffixText: '%',
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
                              interestRate = value.toString();
                            },
                            validator: (String? value) {
                              if (value != null && value.isEmpty) {
                                return 'Interest Rate is required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox( height: 20, ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Document Charge Rate',
                              hintText: "4",
                              suffixText: '%',
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
                              documentChargeRate = value.toString();
                            },
                            validator: (String? value) {
                              if (value != null && value.isEmpty) {
                                return 'Document Charges Rate is required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox( height: 20, ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Max Loan Amount',
                              hintText: "15000",
                              suffixText: 'RS',
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
                              maxLoanAmount = value.toString();
                            },
                            validator: (String? value) {
                              if (value != null && value.isEmpty) {
                                return 'Please add Max Loan amount!';
                              }
                              return null;
                            },
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
                                    isLoading ? const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ): const Text(''),
                                  ]),
                              onPressed: () {
                                // It returns true if the form is valid, otherwise returns false
                                if (_formKey.currentState!.validate()) {
                                  setState((){
                                    isLoading = false;
                                    _btnText = 'Add Loan Product..';
                                  });
                                  createLoanProduct(loanProductName,interestRate,maxLoanAmount,documentChargeRate);
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

  createLoanProduct(String loanProductName, String interestRate, String maxLoanAmount, String documentChargeRate) async {
    // print('sssssss');
    var response = await LoanProductsData.createLoanProducts(
      loanProductName,
      interestRate,
      documentChargeRate,
      maxLoanAmount
    );
    if (response.statusCode == 200) {
      successSnackBar(context, response.data['message']);
      setState(() {
        isLoading = false;
        _btnText = 'Add Customer';
      });
      // _formKey.currentState?.reset();
    } else {
      setState(() {
        isLoading = false;
        _btnText = 'Add Customer';
      });
      if (response.statusCode == 500) {
        Route route =  MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        print(response);
        Map<String,dynamic> errors  = response.data;
        errorSnackBar(context, errors.values.first[0].toString());
      }
    }

  }
}
