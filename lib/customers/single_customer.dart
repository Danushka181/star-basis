import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/widgets/common_card_details_row.dart';

import '../screens/login_page.dart';
import '../services/customers_services.dart';
import '../services/globals.dart';
import '../widgets/app_bar.dart';
import '../widgets/loading_widget.dart';
import '../widgets/single_header_card.dart';

class SingleCustomer extends StatefulWidget {
  String customerId;
  String customerName;
  SingleCustomer({Key? key, required this.customerName,required this.customerId}) : super(key: key);

  @override
  State<SingleCustomer> createState() => _SingleCustomerState();
}

class _SingleCustomerState extends State<SingleCustomer> {
  late dynamic _customerDetails;
  bool isLoading  = true;
  late String phoneNumber = '0';
  getSingleCustomerData() async{
    try{
      http.Response response = await CustomersService.singleCustomer(widget.customerId);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _customerDetails = responseMap['customer'];
          isLoading = false;
          phoneNumber = _customerDetails['c_mobile_number'];
        });
      } else {
        if (response.statusCode == 401) {
          errorSnackBar(context, 'Session is time out Please log in!');
          Route route = MaterialPageRoute(builder: (context) => const LoginPage());
          Navigator.pushReplacement(context, route);
        } else {
          errorSnackBar(context, responseMap['error']);
        }
      }
    }on SocketException {
      errorSnackBar(context, "No internet connection!");
      Navigator.pop(context);
    } on HttpException {
      errorSnackBar(context, "There is a problem when connecting to server!");
      Navigator.pop(context);
    } on FormatException {
      errorSnackBar(context, "Can't reach the server at the moment");
      Navigator.pop(context);
    }
  }

  @override
  void initState(){
    getSingleCustomerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget( title: widget.customerName,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SingleHeaderCard(headerLargeText: widget.customerId, phoneNumber: phoneNumber, smallHeading: 'CUSTOMER DETAILS', nameHeading: widget.customerName),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.green.withOpacity(0.05),
                    Colors.white,
                  ],
                )
              ),
              child: isLoading ? const LoadingWidget() : Column(
              children: [
                const SizedBox(height: 20,),
                CommonCardUserRow(rowHeading: 'ADDRESS:', rowValue: _customerDetails['c_address'].toString()),
                CommonCardUserRow(rowHeading: 'DATE OF BIRTH :', rowValue: DateFormat('yyyy-MM-dd').format(DateTime.parse(_customerDetails['c_bday'].toString()).toLocal())),
                CommonCardUserRow(rowHeading: 'AGE :', rowValue: _customerDetails['c_age'].toString()),
                CommonCardUserRow(rowHeading: 'ID CARD NUMBER  :', rowValue: _customerDetails['c_id_number'].toString()),
                CommonCardUserRow(rowHeading: 'MOBILE NUMBER :', rowValue: _customerDetails['c_mobile_number'].toString()),
                CommonCardUserRow(rowHeading: 'HOME NUMBER :', rowValue: _customerDetails['c_land_number'].toString()),
                CommonCardUserRow(rowHeading: 'MONTHLY INCOME :', rowValue: 'Rs '+ _customerDetails['c_month_income'].toString()),
                CommonCardUserRow(rowHeading: 'GENDER :', rowValue: _customerDetails['c_gender'] == '1' ? "Male" : 'Female' ),
                CommonCardUserRow(rowHeading: 'MARITAL STATE :', rowValue: _customerDetails['c_married'] == '1' ? "Married" : "Single"),
                CommonCardUserRow(rowHeading: 'BANK ACCOUNT NUMBER :', rowValue: _customerDetails['c_bank_account'].toString()),
                CommonCardUserRow(rowHeading: 'ELECTRICITY BILL NUMBER :', rowValue: _customerDetails['c_ceb_number'].toString()),
              ],
            ),
            ),
          ]
        ),
      ),
    );
  }
}
