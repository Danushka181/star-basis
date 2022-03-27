import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/big_text_widget.dart';
import '../widgets/common_card_one.dart';
import '../widgets/common_card_three.dart';
import '../widgets/common_card_two.dart';

class CentersPage extends StatefulWidget {
  const CentersPage({Key? key}) : super(key: key);

  @override
  State<CentersPage> createState() => _CentersPageState();
}

class _CentersPageState extends State<CentersPage>{

  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black54, //change your color here
        ),
        elevation: 4,
        title: const Text(
          "Centers List",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily:'Inter',
            color: Colors.black54,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10,left: 15,right: 15),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search centers..",
                prefixIcon: Icon(Icons.search,color: Colors.black54.withOpacity(0.5),),
                hintStyle: TextStyle(
                  color: Colors.black54.withOpacity(0.5),
                  fontStyle: FontStyle.italic
                ),
              ),
              style: TextStyle(
                color: Colors.black54.withOpacity(0.5),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500
              ),
              onChanged: (value){
                centersSearch(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20,top: 30,right: 20,bottom: 5),
            child: BigTextWidget(content: 'Centers',fontSize: 20, fontWeight: FontWeight.w600, colorCode: Colors.black54.withOpacity(0.5),),
          ),
          CommonCardThree( cardNumber:'23', cardHeading:'Anamaduwa', createdDate: '2022-03-13', createdBy: 'Nadun', cardSubHeading: '163-c, Kotarupe, Raddolugama'),

        ],
      ),
    );
  }
}

void centersSearch(String value) {
  print(value);
}
