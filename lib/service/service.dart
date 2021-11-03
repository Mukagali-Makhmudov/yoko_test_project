import 'package:dio/dio.dart';
import 'package:yoko_test/models/activity_list.dart';

Future<ActivityList> getData(String authToken) async{
  Dio dio = Dio();
  try {
    print(authToken);
    Response response = await dio.get(
      'https://api.shymbulak-dev.com/ticket-service/ticket-types/by-category-code/ACTIVITIES',
      options: Options(
        headers: {
          'Authorization': 'Bearer $authToken',
        }
      )
    );
    print(authToken);
    return ActivityList.fromJson(response.data);
  } on Exception catch (e) {
    rethrow;
  }
}