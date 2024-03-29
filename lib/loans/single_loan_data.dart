import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/login_page.dart';

import '../services/globals.dart';
import '../services/loans.dart';
import '../widgets/app_bar.dart';
import '../widgets/loading_widget.dart';
import '../widgets/single_header_card.dart';

class SingleLoanData extends StatefulWidget {
  String customerName;
  String loanId;
  String phoneNumber;
  SingleLoanData({Key? key,required this.customerName, required this.loanId, required this.phoneNumber}) : super(key: key);

  @override
  State<SingleLoanData> createState() => _SingleLoanDataState();
}

class _SingleLoanDataState extends State<SingleLoanData> {
  bool isLoading = true;
  bool isNoData = false;
  late dynamic loanDetails;
  late dynamic loanUserDetails;
  late dynamic loanCustomerDetails;
  late List<dynamic> loanApproval;

  getLoanDataSet() async{
    try{
      var response = await LoansService.getSingleLoanDetails(widget.loanId);
      print(response.data);
      if (response.statusCode == 200) {
        if(response.data['loans'].length != 0){
          setState(() {
            loanDetails = response.data['loans'];
            loanUserDetails = response.data['loans']['user'];
            loanCustomerDetails = response.data['loans']['customer'];
            loanApproval = response.data['loans']['approval'];
            isLoading = false;
          });
        }else{
          if (!mounted) return;
          notifySnackBar(context,'Currently no issued loans, Please approve!');
          setState((){
            loanDetails = [];
            loanUserDetails = [];
            loanCustomerDetails = [];
            loanApproval = [];
            isLoading = false;
            isNoData = true;
          });
        }
      } else {
        if (response.statusCode == 401) {
          if (!mounted) return;
          Route route = MaterialPageRoute(builder: (context) => const LoginPage());
          Navigator.pushReplacement(context, route);
        } else {
          if (!mounted) return;
          errorSnackBar(context, response['error']);
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
    getLoanDataSet();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget( title: 'Loan Details',),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SingleHeaderCard(headerLargeText: widget.loanId, phoneNumber: widget.phoneNumber, smallHeading: 'LOAN DETAILS', nameHeading: widget.customerName),
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
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isLoading == false ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Loan Amount : ${loanDetails['l_amount']}/='),
                            Text('Loan Pending Amount : ${loanDetails['l_pending_amount']}/='),
                            Text('Loan Duration : ${loanDetails['l_duration']} Months'),
                            Text('Weekly Installment : ${loanDetails['l_installment']} /='),
                            Text('Loan Start Date : ${loanDetails['l_start']}'),
                            Text('Loan End Date : ${loanDetails['l_end']}'),
                            Text('Loan Last Payment : ${loanDetails['l_last_payment']}'),
                            Text('Loan Installment Weeks Count : ${loanDetails['l_installment_count']}'),
                            Text('Loan Document Charges : ${loanDetails['l_document_charge']}'),
                            Text('Loan Approved Count : ${loanDetails['get_approved_loans_count']}'),
                            SizedBox(height: 30,),
                            Text('LOAN USER DETAILS :'),
                            Text('Loan Created By : ${loanUserDetails['name']}'),
                            SizedBox(height: 30,),
                            Text('LOAN CUSTOMER DETAILS :'),
                            Text('Customer Name : ${loanCustomerDetails['c_name']}'),
                            Text('Customer Address : ${loanCustomerDetails['c_address']}'),
                            SizedBox(height: 30,),
                            // loan approvals list
                            ListView.builder(
                              itemCount: loanApproval.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                if( loanApproval[index]['user']!= null) {
                                  Map<String, dynamic> approvals = loanApproval[index];
                                  Map<String, dynamic> approvalsUsers = loanApproval[index]['user'];
                                  var approveState  =  approvals['l_approve_state'] == '1' ? 'Approved' : 'Rejected';
                                  approveState   =  loanUserDetails['id'] ==  approvalsUsers['id'] ? 'Approved and Created ' : approveState;
                                  Color approveColor = approvals['l_approve_state'] == '1' ? Colors.green : Colors.redAccent;
                                  return Row(
                                    children: <Widget>[
                                      Text(
                                          '$approveState by : ',
                                        style: TextStyle(
                                          color: approveColor
                                        ),
                                      ),
                                      Text(approvalsUsers['name'].toString())
                                    ],
                                  );
                                }else{
                                  return const Text('---');
                                }
                              },
                            ),
                          ],
                        )
                      :
                        const LoadingWidget(),
                      isNoData ?
                        infoMessage('No issued loans Found! Please approve Loans.',Colors.grey)
                      :
                        Container(),
                    ],
                  ),
              ),
            ],
          ),
        ),
    );
  }
}
