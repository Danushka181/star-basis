import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'globals.dart';

class LoanProductsData {
  // get all loan products list
  static Future getLoanProductsList() async {
    const url = '${base_url}loans-products/';
    try{
      String token = await getSavedToken();
      Response response = await Dio().get(
        url,
        options: dio.Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }
        ),
      );
      return response;
    } catch (e){
      // print(e);
      return e;
    }

  }

  // create loan product
  static Future createLoanProducts(
      productName,
      rate,
      documentCharge,
      maxLoanAmount
      ) async {
    try{
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl = base_url;
      String token = await getSavedToken();
      dioRequest.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      Map<String,dynamic> data = {
        "loan_product_name" :productName,
        "rate" :rate,
        "document_charge" : documentCharge,
        "max_loan_amount" : maxLoanAmount,
      };
      FormData formData = dio.FormData.fromMap(data); // add all data to form
      Response response = await dioRequest.post(
        'loans-products/create',
        data: formData,
      );
      return response;
    } catch (err) {
      print('ERROR  $err');
    }
  }
}
