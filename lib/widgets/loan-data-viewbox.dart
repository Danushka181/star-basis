import 'package:flutter/cupertino.dart';

import 'common_card_details_row.dart';

class LoanDataViewBox extends StatelessWidget {
  final dynamic loanData;
  const LoanDataViewBox({Key? key, required this.loanData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    dynamic lp   = loanData;
    return Column(
      children: [
        CommonCardUserRow(rowHeading: 'Loan Amount:', rowValue: lp['l_amount']),
        CommonCardUserRow(rowHeading: 'Loan Duration:', rowValue: lp['l_duration']+' Months'),
        CommonCardUserRow(
            rowHeading: 'Weekly Installment:',
            rowValue: lp['l_installment'] != null ? '${lp['l_installment']} LKR' : '00.00 LKR'
        ),
        CommonCardUserRow(rowHeading: 'Loan Start Date:', rowValue: lp['l_start']),
        CommonCardUserRow(rowHeading: 'Loan End Date:', rowValue: lp['l_end']),
        CommonCardUserRow(
            rowHeading: 'Last Payment Date:',
            rowValue: lp['l_last_payment'] ?? 'not-yet'
        ),
        CommonCardUserRow(
            rowHeading: 'Total Installment Count:',
            rowValue: lp['l_installment_count'] != null ? '${lp['l_installment_count']} Weeks' : '- Weeks'
        ),
        CommonCardUserRow(
            rowHeading: 'Document Charges:',
            rowValue: lp['l_document_charge'] != null ? '${lp['l_document_charge']} LKR' : '0.00 LKR'
        ),
      ],
    );
  }
}
