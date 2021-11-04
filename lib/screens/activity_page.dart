import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yoko_test/models/activity_list.dart';
import 'package:yoko_test/screens/detail_page.dart';
import 'package:yoko_test/service/service.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Активности',
          style: TextStyle(
            color: Colors.black
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

    Box tokensBox = Hive.box('tokens');

    Widget activityCard(String name, String url){
      return Container(
        height: 220,
        margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(url)
          )
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.5),
                Colors.black.withOpacity(0.5)
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 12),
                child: Text(
                  name, 
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold
                  )
                )
              ),
              const Padding(
                padding: EdgeInsets.only(left: 14, top: 6),
                child: Text(
                  'Оплачивайте частые\nуслуги просто!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),
                )
              )
            ],
          )
        )
      );
    }
    return FutureBuilder<ActivityList>(
      future: getData(tokensBox.get('access')),
      builder: (BuildContext context, AsyncSnapshot<ActivityList> snapshot) {
        switch(snapshot.connectionState){
        case ConnectionState.waiting: return const Align(
          alignment: Alignment.center,
          child: Text('Loading...', style: TextStyle(fontSize: 25, color: Colors.blue),
          )
        );
        default: 
          if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: snapshot.data!.activity.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => DetailPage(index: index,),
                        settings: RouteSettings(arguments: snapshot.data!.activity[index]),
                      )
                    );
                  },
                  child: activityCard(snapshot.data!.activity[index].nameRu, snapshot.data!.activity[index].imageUrl),
                );
              }
            );    
          }
        }
      }
    );
  }
}