import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yoko_test/constants/color_const.dart';
import 'package:yoko_test/constants/text_const.dart';
import 'package:yoko_test/models/activity_list.dart';
import 'package:yoko_test/screens/detail_page.dart';
import 'package:yoko_test/service/service.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:  AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.appBarIconColor
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          AppTexts.activityPageAppBarText,
          style: TextStyle(
            color: AppColors.appBarTextColor,
          ),
        ),
      ),
      body: ActivityListWidget(),
    );
  }
}

class ActivityListWidget extends StatefulWidget {
  ActivityListWidget({Key? key}) : super(key: key);

  @override
  _ActivityListWidgetState createState() => _ActivityListWidgetState();
}

class _ActivityListWidgetState extends State<ActivityListWidget> {
  @override
  Widget build(BuildContext context) {

    Box tokensBox = Hive.box(AppTexts.tokenBoxName);

    Widget activityCard(String nameRu, String imageUrl){
      return Container(
        height: 220,
        margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColors.linearGradientFirstColorWithOpacity,
                AppColors.linearGradientSecondColorWithOpacity,
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 12),
                child: Text(
                  nameRu, 
                  style: const TextStyle(
                    color: AppColors.mainAppTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 14, top: 6),
                child: Text(
                  AppTexts.activitySubtitle,
                  style: TextStyle(
                    color: AppColors.mainAppTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    
    return FutureBuilder<ActivityList>(
      future: getData(tokensBox.get(AppTexts.accessName)),
      builder: (BuildContext context, AsyncSnapshot<ActivityList> snapshot) {
        switch(snapshot.connectionState){
        case ConnectionState.waiting: return const Align(
          alignment: Alignment.center,
          child: Text(
            AppTexts.systemLoadingText, 
            style: TextStyle(
              fontSize: 25, 
              color: AppColors.mainAppColor,
            ),
          )
        );
        default:
          if (snapshot.hasError){
            return Align(
              alignment: Alignment.center,
              child: Text(
                '${AppTexts.systemErrorText} ${snapshot.error}',
                style: const TextStyle(
                  fontSize: 25, 
                  color: AppColors.mainAppColor,
                ),
              )
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.activity.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => DetailPage(index: index,),
                        settings: RouteSettings(
                          arguments: snapshot.data!.activity[index],
                        ),
                      ),
                    );
                  },
                  child: activityCard(
                    snapshot.data!.activity[index].nameRu, 
                    snapshot.data!.activity[index].imageUrl,
                  ),
                );
              },
            );    
          }
        }
      },
    );
  }
}