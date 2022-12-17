import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_basis/widgets/big_text_widget.dart';
import 'package:star_basis/widgets/btn_widget.dart';

import '../screens/login_page.dart';
import '../services/globals.dart';
import '../services/loans.dart';
import '../widgets/approve_reject_widget.dart';
import '../widgets/loan-data-viewbox.dart';
import 'loan_dashboard.dart';

class LoanConfirmation extends StatefulWidget {
  final dynamic response;

  const LoanConfirmation({Key? key, required this.response}) : super(key: key);
  @override
  State<LoanConfirmation> createState() => _LoanConfirmationState();
}

class _LoanConfirmationState extends State<LoanConfirmation> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const BigTextWidget(content: 'Confirm Loan Creation!'),
          const SizedBox(height: 15,),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child:  LoanDataViewBox(loanData: widget.response['data']),
            ),
          ),
          const SizedBox(height: 15,),
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
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
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
                      // user confirmed to create a loan
                      setState(() {
                        isLoading = true;
                      });
                      createConfirmedLoan({...widget.response['data'],'is_save': 1});
                    },
                    child: isLoading ? const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                        :
                      const Text(
                        'Confirm',
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
          ),
        ],
    );
  }

  void createConfirmedLoan(Map<String,dynamic>data) async{
    Map<String, dynamic> apiData = data;
    var response = await LoansService.createNewLoans(apiData);
    if (response.statusCode == 200) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      successSnackBar(context, response.data['message']);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoanDashboard(activeTab: 0,)));
    } else {
      setState(() {
        isLoading = false;
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
