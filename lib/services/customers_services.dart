import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'globals.dart';

class CustomersService {

  /* all Customers */
  static Future allCustomers() async {
    const url = base_url + 'customers/';
    try{
      String _token = await getSavedToken();
      Response response = await Dio().get(
          url,
          options: dio.Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ' + _token,
            }
          ),
      );
      return response;
    } catch (e){
      print(e);
    }

  }


  static Future<http.Response> singleCustomer(String id) async {
    String _token = await getSavedToken();
    var url = Uri.parse(base_url + 'customers/show/' + id);
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _token,
      },
    );
    return response;
  }

  //add customers to server
  static Future addCustomersToServer(
      cName,
      cAddress,
      cBday,
      cAge,
      cIdNumber,
      cMobileNumber,
      cLandNumber,
      cMonthIncome,
      cCebNumber,
      cJob,
      cOfficeNumber,
      cGender,
      cMarried,
      cSupName,
      cSupJob,
      cSupPhone,
      cSupIdNumber,
      cBankAccount,
      cBankName,
      cBranchName,
      cIdCopy,
      cIdCopyBack,
      cCebBill,
      cBankBook,
      cGroup
      ) async{

    try{
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl = base_url;

      String _token = await getSavedToken();
      dioRequest.options.headers = {
        'Authorization': 'Bearer ' + _token,
        'Content-Type': 'application/x-www-form-urlencoded'
      };

      Map<String,dynamic> data = {
        "c_name" :cName,
        "c_address" :cAddress,
        "c_bday" : cBday,
        "c_age" : cAge,
        "c_id_number" : cIdNumber,
        "c_mobile_number" : cMobileNumber,
        "c_land_number" : cLandNumber,
        "c_month_income" : cMonthIncome,
        "c_ceb_number" :cCebNumber,
        "c_job" :cJob,
        "c_office_number" :cOfficeNumber,
        "c_gender" :cGender,
        "c_married" :cMarried,
        "c_sup_name" :cSupName,
        "c_sup_job" :cSupJob,
        "c_sup_phone" :cSupPhone,
        "c_sup_id_number" :cSupIdNumber,
        "c_bank_account" :cBankAccount,
        "c_bank_name" :cBankName,
        "c_bank_branch" :cBranchName,
        "c_status" : '1',
        "c_user" : '0',
        "c_group" :cGroup,
        "c_id_copy" : await MultipartFile.fromFile(cIdCopy.path, filename:cIdCopy.path.split('/').last),
        "c_id_copy_back" : await MultipartFile.fromFile(cIdCopyBack.path, filename:cIdCopyBack.path.split('/').last),
        "c_ceb_bill" : await MultipartFile.fromFile(cIdCopyBack.path, filename:cIdCopyBack.path.split('/').last),
        "c_bank_book" : await MultipartFile.fromFile(cIdCopyBack.path, filename:cIdCopyBack.path.split('/').last),
      };

      FormData formData = dio.FormData.fromMap(data); // add all data to form

      Response response = await dioRequest.post(
        'customers/create',
        data: formData,
      );

      return response;

    } catch (err) {
      print('ERROR  $err');
    }
  }



  static Future<http.Response> addCustomers(
      cName,
      cAddress,
      cBday,
      cAge,
      cIdNumber,
      cMobileNumber,
      cLandNumber,
      cMonthIncome,
      cCebNumber,
      cJob,
      cOfficeNumber,
      cGender,
      cMarried,
      cSupName,
      cSupJob,
      cSupPhone,
      cSupIdNumber,
      cBankAccount,
      cBankName,
      cBranchName,
      cIdCopy,
      cIdCopyBack,
      cCebBill,
      cBankBook,
      cGroup) async {
    String _token = await getSavedToken();

    Map data = {
      "c_name" :cName,
      "c_address" :cAddress,
      "c_bday" : cBday,
      "c_age" : cAge,
      "c_id_number" : cIdNumber,
      "c_mobile_number" : cMobileNumber,
      "c_land_number" : cLandNumber,
      "c_month_income" : cMonthIncome,
      "c_ceb_number" :cCebNumber,
      "c_job" :cJob,
      "c_office_number" :cOfficeNumber,
      "c_gender" :cGender,
      "c_married" :cMarried,
      "c_sup_name" :cSupName,
      "c_sup_job" :cSupJob,
      "c_sup_phone" :cSupPhone,
      "c_sup_id_number" :cSupIdNumber,
      "c_bank_account" :cBankAccount,
      "c_bank_name" :cBankName,
      "c_bank_branch" :cBranchName,
      "c_id_copy" :cIdCopy != '' ? cIdCopy : 'ss',
      "c_id_copy_back" :cIdCopyBack != '' ? cIdCopyBack : 'ss',
      "c_ceb_bill" :cCebBill != '' ? cCebBill : 'ss',
      "c_bank_book" :cBankBook != '' ? cBankBook : 'ss',
      "c_status" : '1',
      "c_user" : '0',
      "c_group" :cGroup,
    };

    print(data);

    // ready data for send to the server
    var body = json.encode(data);
    var url = Uri.parse(base_url + 'customers/create'); // api centers
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _token,
      },
      body: body,
    );
    return response;
  }




  //
  // static Future<http.Response> deleteCenters(centerId) async {
  //   String _token = await getSavedToken();
  //   Map data = {};
  //
  //   // ready data for send to the server
  //   var body = json.encode(data);
  //   var url = Uri.parse(base_url + 'centers/delete-center/'+centerId); // api centers
  //   http.Response response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer '+_token,
  //     },
  //     body:body,
  //   );
  //   return response;
  //
  // }
}
