import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_basis/services/loans.dart';

import '../../screens/login_page.dart';
import '../../services/globals.dart';
import '../../widgets/common_card_two.dart';
import '../../widgets/loading_widget.dart';
import '../single_loan_data_pending.dart';

class RejectedLoansList extends StatefulWidget {
  const RejectedLoansList({Key? key}) : super(key: key);

  @override
  State<RejectedLoansList> createState() => _RejectedLoansListState();
}

class _RejectedLoansListState extends State<RejectedLoansList> {
  late List rejectedLoans;
  late List allRejectedLoans;
  bool isLoading = true;
  bool isNoData = false;

  getAllRejectedLoans() async{
    try{
      var response = await LoansService.getAllRejectedLoansList();
      if (response.statusCode == 200) {
        if(response.data['pending-loans'].length != 0){
          setState(() {
            rejectedLoans = response.data['pending-loans'];
            allRejectedLoans = rejectedLoans;
            isLoading = false;
          });
        }else{
          if (!mounted) return;
          notifySnackBar(context,'Currently no issued loans, Please approve!');
          setState((){
            rejectedLoans = [];
            allRejectedLoans = rejectedLoans;
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
  void initState() {
    rejectedLoans = [];
    getAllRejectedLoans();
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
                itemCount: rejectedLoans != null ? rejectedLoans.length : 0,
                itemBuilder: (_, index) {
                  Map<String, dynamic> customerData   = rejectedLoans[index]['customer'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleLoanDataPending(
                            customerName: customerData['c_name'].toString(),
                            loanId: rejectedLoans[index]['id'].toString(),
                            phoneNumber: customerData['c_mobile_number'].toString(),
                          ),
                        ),
                      );
                    },
                    child: CommonCardTwo(
                      cardHeading: customerData['c_name'].toString(),
                      cardSubHeading: customerData['c_address'].toString(),
                      loanAmount: rejectedLoans[index]['l_amount'].toString(),
                      loanId: rejectedLoans[index]['id'].toString(),
                      createdAt: DateFormat.yMMMEd().format( DateTime.parse( rejectedLoans[index]['created_at']) .toLocal()),
                    ),
                  );
                }
            )
                :
            const LoadingWidget(),
            isNoData ?
            infoMessage('No Rejected loans Found!',Colors.grey)
                :
            Container(),
          ],
        ),
      ),
    );
  }
}
