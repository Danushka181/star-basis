import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/login_page.dart';

import '../services/globals.dart';
import '../services/loans.dart';
import '../widgets/app_bar.dart';
import '../widgets/approve_reject_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/single_header_card.dart';

class SingleLoanDataPending extends StatefulWidget {
  String customerName;
  String loanId;
  String phoneNumber;

  SingleLoanDataPending({Key? key,required this.customerName, required this.loanId, required this.phoneNumber}) : super(key: key);

  @override
  State<SingleLoanDataPending> createState() => _SingleLoanDataPendingState();
}

class _SingleLoanDataPendingState extends State<SingleLoanDataPending> {
  bool isLoading = true;
  bool isNoData = false;
  late dynamic loanDetails;
  late dynamic loanUserDetails;
  late dynamic loanCustomerDetails;
  late List<dynamic> loanApproval;

  getLoanDataSet() async{
    try{
      var response = await LoansService.getSingleLoanDetails(widget.loanId);
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
      appBar: const AppBarWidget( title: 'Loan Detail',),
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
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      '$approveState by : ',
                                      style: TextStyle(
                                          color: approveColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                        approvalsUsers['name'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54
                                        ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Comment : ${approvals['l_comments'] != null ? approvals['l_comments'].toString() : '-'}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15,)

                              ],
                            );
                          }else{
                            return const Text('---');
                          }
                        },
                      ),
                      const SizedBox(height: 40,),
                      Container(height: 1,color: Colors.black12,),
                      const SizedBox(height: 20,),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child:
                                Material(
                                  elevation: 3,
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(3),
                                  borderOnForeground: true,

                                  child: MaterialButton(
                                    minWidth: 320,
                                    height: 40,
                                    onPressed: () {
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
                                            child: ApproveRejectWidget(
                                              popHeading: 'Rejection Confirmation!',
                                              buttonText: 'Yes Reject',
                                              loanId: widget.loanId,
                                              approveState: '0',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Reject',
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child:
                                Material(
                                  elevation: 5,
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(3),
                                  child: MaterialButton(
                                    minWidth: 320,
                                    height: 40,
                                    onPressed: () {
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
                                            child: ApproveRejectWidget(
                                              popHeading: 'Approval Confirmation!',
                                              buttonText: 'Yes Approve',
                                              loanId: widget.loanId,
                                              approveState: '1',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Approve',
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                              ),
                            ],
                          )
                        ],
                      )

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
