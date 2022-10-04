import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../loans/loan_dashboard.dart';
import '../screens/login_page.dart';
import '../services/globals.dart';
import '../services/loan_approval.dart';
import 'big_text_widget.dart';
import 'label_text.dart';

class ApproveRejectWidget extends StatefulWidget {
  String popHeading;
  String buttonText;
  String loanId;
  String approveState;
  ApproveRejectWidget({
    Key? key,
    required this.popHeading,
    required this.buttonText,
    required this.loanId,
    required this.approveState,
  }) : super(key: key);


  @override
  State<ApproveRejectWidget> createState() => _ApproveRejectWidgetState();
}

class _ApproveRejectWidgetState extends State<ApproveRejectWidget> {

  bool isLoading = false;
  late String lComment = '';
  late String lId = '';

  updateLoanApprovalData(String lComment,String lId,String lApproveState) async{
    try{
      var response = await LoanApproval.createLoanApproval(
        lComment,lId,lApproveState
      );
      print(response);
      if (response.statusCode == 200) {
        if(response.data.length != 0){
          setState(() {
            isLoading = false;
          });
          if (!mounted) return;
          Navigator.pop(context);
          successSnackBar(context, response.data['message']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoanDashboard(activeTab: 1,)),
          );
        }else{
          if (!mounted) return;
          notifySnackBar(context,'Loan is not approved!');
          setState((){
            isLoading = false;
          });
        }
      } else {
        if (response.statusCode == 401) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          if (!mounted) return;
          Navigator.pop(context);
          errorSnackBar(context, response.data['error']);
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        BigTextWidget(content: widget.popHeading),
        const SizedBox(height: 10,),
        const LabelText(content: 'Please leave a comment if needed!',fontSize: 13,fontWeight: FontWeight.w500,),
        const SizedBox(height: 40,),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 25),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: 'Add your comment here..',
                  border: OutlineInputBorder(borderSide: BorderSide(
                    color: Colors.black12,
                    strokeAlign: StrokeAlign.center,
                    style: BorderStyle.solid,
                  ),
                  )
              ),
              onChanged: (value){
                lComment = value.toString();
              },
            ),
        ),
        const SizedBox(height: 50,),
        Material(
          elevation: 3,
          color: Colors.black,
          borderRadius: BorderRadius.circular(3),
          borderOnForeground: true,
          child: MaterialButton(
            minWidth: 320,
            height: 40,
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              updateLoanApprovalData(lComment,widget.loanId,widget.approveState);
            },
            child: Text(
              widget.buttonText,
              style:  const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
