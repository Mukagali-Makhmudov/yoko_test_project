import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoko_test/models/activity_list.dart';
import 'package:yoko_test/service/service.dart';

class DetailPage extends StatefulWidget {
  int? index;
  DetailPage({Key? key, required this.index}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState(index: index);
}

class _DetailPageState extends State<DetailPage> {
  int? index;
  _DetailPageState({required this.index});
  @override
  Widget build(BuildContext context) {
    Box tokensBox = Hive.box('tokens');

    Widget backScreen(String imageUrl, String nameRu){
      return Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            colorFilter: const ColorFilter.mode(Color(0xFF5E94C8), BlendMode.color),
            image: NetworkImage(imageUrl)
          )
        ),
        child: Center(
          child: Text(
            nameRu, 
            textAlign: TextAlign.center, 
            style: const TextStyle(
              fontSize: 32, 
              color: Colors.white, 
              fontWeight: FontWeight.bold)),
        )
      );
    }

    Widget visitDateInfo(){
      return const SizedBox(
        height: 70,
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 0),
          title: Text('Дата посещения', style: TextStyle(fontSize: 14)),
          subtitle: Text('Подзаголовок', style: TextStyle(fontSize: 13)),
        ),
      );
    }

    Widget selectVisitDateWidget(){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(13)
          ),
          child: const ListTile(
            contentPadding: EdgeInsets.only(left: 10, right: 12),
            leading: Icon(Icons.calendar_today, color: Colors.blue,),
            title: Align(child: Text('Выберите дату'), alignment: Alignment(-1.3, 0),),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue,),
          ),
        )
      );
    }

    Widget tariff(String tariffNameRu, double price, String currency){
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(13)
          ),
          child: ListTile(
            title: Text(tariffNameRu, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text('${price.toInt()} $currency'),
            trailing: const Icon(Icons.add_circle_outline, size: 30, color: Colors.blue,)
          ),
        )
      );
    }

    Widget paymentButton(){
      return OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF4271B5)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
        ),
        onPressed: (){},
        child: const Text('Перейти к оплате', style: TextStyle(fontSize: 18, color: Colors.white),),
      );
    }

    Widget frontScreen(String tariffNameRu, double price, String currency){
      return Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                visitDateInfo(),
                const Divider(height: 1, color: Colors.grey),
                selectVisitDateWidget(),
                tariff(tariffNameRu, price, currency),
                paymentButton(),
              ],
            ),
          ),
        ),
      );
    }

    Widget forCustomInfoScreen(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Divider(height: 1, color: Colors.grey),
            ListTile(
              title: Text('Правила поведения в сноупарке'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
            ),
            Divider(height: 1, color: Colors.grey),
            ListTile(
              title: Text('Позвонить', style: TextStyle(color: Colors.blue)),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder<ActivityList>(
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
              return Scaffold(
                body: Stack(
                  children: [
                    backScreen(snapshot.data!.activity[index!].imageUrl, snapshot.data!.activity[index!].nameRu),
                    frontScreen(
                      snapshot.data!.activity[index!].tariffs[0].nameRu,
                      snapshot.data!.activity[index!].tariffs[0].priceInfo.price,
                      snapshot.data!.activity[index!].tariffs[0].priceInfo.currency
                    ),
                    forCustomInfoScreen(),
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                      body: Container(
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        }
      ),
    );
  }
}