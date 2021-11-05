import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoko_test/constants/text_const.dart';
import 'package:yoko_test/constants/url_const.dart';
import 'package:yoko_test/models/activity_list.dart';
import 'package:yoko_test/models/tokens.dart';
import 'package:yoko_test/screens/activity_page.dart';

Future<ActivityList> getData(String? authToken) async{
  Dio dio = Dio();
  try {
    Response response = await dio.get(
      AppUrls.getActivitiesUrl,
      options: Options(
        headers: {
          AppTexts.authorizationJsonText: '${AppTexts.bearerJsonText} $authToken',
        }
      )
    );
    return ActivityList.fromJson(response.data);
  } on Exception {
    rethrow;
  }
}

Future<void> authFunc(
  BuildContext context, 
  String email, 
  String password
) async {
    Dio dio = Dio();
    Box tokensBox = Hive.box(AppTexts.tokenBoxName);
    try {
      Response response = await dio.post(
        AppUrls.authUrl,
        data: {
          AppTexts.emailJsonText: email,
          AppTexts.passwordJsonText: password,
        },
      );
    
      TokensModel tokensModel = TokensModel(
        access: response.data[AppTexts.accessTokenName],
      );
    
      tokensBox.put(AppTexts.accessName, tokensModel.access,);
    
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const ActivityPage(),
        ),
      );
    } on DioError {
      showCupertinoModalPopup(
        context: context, 
        builder: (context){
          return CupertinoAlertDialog(
            title: const Text(AppTexts.errorText),
            content: const Text(AppTexts.wrongPassOrEmailText),
            actions: [
              CupertinoButton(
                child: const Text(AppTexts.acceptText), 
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
      rethrow;
    }
  }


