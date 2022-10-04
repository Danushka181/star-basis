import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;

import 'globals.dart';

class LoanApproval{

  static Future createLoanApproval(
      String lComment,
      String lId,
      String lApproveState
      ) async{
    var url = '${base_url}loans-approval/create';
    try{
      Map<String,dynamic> data = {
        "l_comments" :lComment,
        "l_id" :lId,
        "l_approve_state" : lApproveState,
      };
      FormData formData = dio.FormData.fromMap(data);

      String token = await getSavedToken();
      Response response = await Dio().post(
        url,
        options: dio.Options(
            validateStatus: (_) => true,
            headers: {
              'HttpHeaders.contentTypeHeader': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
        ),
        data: formData
      );

      return response;
    } on DioError catch(e){
      return e;
    }
  }
}
