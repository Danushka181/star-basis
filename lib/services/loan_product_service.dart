import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
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
            validateStatus: (_) => true,
            headers: {
              'HttpHeaders.contentTypeHeader': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }
        ),
      );
      return response;
    } on DioError catch(e){
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

    const url = '${base_url}loans-products/create';
    // set form data before send to backend
    Map<String,dynamic> data = {
      'loan_product_name':productName,
      'rate':rate,
      'document_charge': documentCharge,
      'max_loan_amount':maxLoanAmount
    };

    try{
      String token = await getSavedToken();
      Response response = await Dio().post(
        url,
        options: dio.Options(
            validateStatus: (_) => true,
            headers: {
              'HttpHeaders.contentTypeHeader': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }
        ),
        data:data
      );
      return response;
    } catch (err) {
      return err;
    }
  }
}
