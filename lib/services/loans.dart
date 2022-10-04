import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;

import 'globals.dart';

class LoansService{

    // get all loans list
    static Future getAllLoansList() async {
        const url = '${base_url}loans/';
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

    static Future getAllPendingLoansList() async{
        const url = '${base_url}loans/pending-loans';
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

    static Future getIssuedLoansList() async {
        const url = '${base_url}loans/issued-loans';
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

    static Future getAllRejectedLoansList() async {
        const url = '${base_url}loans/rejected-loans';
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


    static Future getSingleLoanDetails(String loanId) async {
        var url = '${base_url}loans/show/$loanId';
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
            );
            return response;
        } on DioError catch(e){
            return e;
        }

    }
}
