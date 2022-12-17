import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/services/loans.dart';

import '../../screens/login_page.dart';
import '../../services/globals.dart';
import '../../widgets/common_card_two.dart';
import '../../widgets/loading_widget.dart';
import '../single_loan_data_pending.dart';

class PendingLoansList extends StatefulWidget {
  const PendingLoansList({Key? key}) : super(key: key);

  @override
  State<PendingLoansList> createState() => _PendingLoansListState();
}

class _PendingLoansListState extends State<PendingLoansList> {
  late List pendingLoans;
  late List allPendingLoans;
  bool isLoading = true;
  bool isNoData = false;

  getAllPendingLoans() async{
    try{
      var response = await LoansService.getAllPendingLoansList();
      print(response);
        if (response.data['pending-loans'].length != 0) {
          setState(() {
            pendingLoans = response.data['pending-loans'];
            allPendingLoans = pendingLoans;
            isLoading = false;
          });
        } else {
          if (!mounted) return;
          notifySnackBar(context, 'Currently no issued loans, Please approve!');
          setState(() {
            pendingLoans = [];
            allPendingLoans = pendingLoans;
            isLoading = false;
            isNoData = true;
          });
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
  void initState() {
    pendingLoans = [];
    getAllPendingLoans();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            isLoading == false ?
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pendingLoans != null ? pendingLoans.length : 0,
                itemBuilder: (_, index) {
                  Map<String, dynamic> customerData   = pendingLoans[index]['customer'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleLoanDataPending(
                            customerName: customerData['c_name'].toString(),
                            loanId: pendingLoans[index]['id'].toString(),
                            phoneNumber: customerData['c_mobile_number'].toString(),
                          ),
                        ),
                      );
                    },
                    child: CommonCardTwo(
                      cardHeading: customerData['c_name'].toString(),
                      cardSubHeading: customerData['c_address'].toString(),
                      loanAmount: pendingLoans[index]['l_amount'].toString(),
                      loanId: pendingLoans[index]['id'].toString(),
                      createdAt: DateFormat.yMMMEd().format( DateTime.parse( pendingLoans[index]['created_at']) .toLocal()),
                    ),
                  );
                }
            )
                :
            const LoadingWidget(),
            isNoData ?
            infoMessage('No Pending loans Found! Please add Loans to Approve.',Colors.grey)
                :
            Container(),
          ],
        ),
      ),
    );
  }
}
