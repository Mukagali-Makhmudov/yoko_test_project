import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoko_test/constants/color_const.dart';
import 'package:yoko_test/constants/text_const.dart';
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
  List <String> tariffNameRuList = [];
  List <double> tariffPriceList = [];
  List <String> tariffPriceCurrencyList = [];

  _DetailPageState({required this.index});
  @override
  Widget build(BuildContext context) {
    Box tokensBox = Hive.box(AppTexts.tokenBoxName);

    Widget visitDateInfo(){
      return const SizedBox(
        height: 70,
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 0),
          title: Text(
            AppTexts.visitDateTitle, 
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.bold
            )
          ),
          subtitle: Text(
            AppTexts.visitDateSubtitle, 
            style: TextStyle(fontSize: 13),
          ),
        ),
      );
    }

    Widget selectVisitDateWidget(){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.backgroundVisibleLineColor
            ),
            borderRadius: BorderRadius.circular(13)
          ),
          child: const ListTile(
            contentPadding: EdgeInsets.only(left: 10, right: 12),
            leading: Icon(
              Icons.calendar_today, 
              color: AppColors.mainAppColor,
            ),
            title: Align(
              child: Text(
                AppTexts.dateChooseActionText
              ), 
              alignment: Alignment(-1.3, 0),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right, 
              color: AppColors.mainAppColor,
            ),
          ),
        )
      );
    }

    Widget tariff(
      List <String> tariffNameRuList, 
      List <double> tariffPriceList, 
      List <String> tariffPriceCurrencyList, 
      ScrollController scrollController
    ){
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.tariffElementBackgroundColor,
            borderRadius: BorderRadius.circular(13)
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            itemCount: tariffNameRuList.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(
                  tariffNameRuList[index], 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
                subtitle: Text(
                  '${
                    tariffPriceList[index].toInt()
                  } ${
                    tariffPriceCurrencyList[index]
                  }'
                ),
                trailing: const Icon(
                  Icons.add_circle_outline, 
                  size: 30, 
                  color: AppColors.mainAppColor
                )
              );
            }
          )
        )
      );
    }

    Widget paymentButton(){
      return OutlinedButton(
        child: const Text(
          AppTexts.paymentButtonText, 
          style: TextStyle(
            fontSize: 18, 
            color: AppColors.mainAppTextColor
          )
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 20)
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors.paymentButtonColor
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13)
            )
          )
        ),
        onPressed: (){}
      );
    }

    Widget forCustomInfoScreen(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Divider(height: 1, color: AppColors.dividerColor),
            ListTile(
              title: Text(AppTexts.openRulesActionText),
              trailing: Icon(
                Icons.keyboard_arrow_right, 
                color: AppColors.mainAppColor
              )
            ),
            Divider(height: 1, color: AppColors.dividerColor),
            ListTile(
              title: Text(
                AppTexts.callActionText, 
                style: TextStyle(
                  color: AppColors.mainAppColor,
                ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right, 
                color: AppColors.mainAppColor
              ),
            ),
          ],
        ),
      );
    }

    Widget backImagePart(String imageUrl, String nameRu){
      return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            colorFilter: const ColorFilter.mode(
              AppColors.detailPageImageEffectColor, 
              BlendMode.color
            ),
            image: NetworkImage(imageUrl)
          ),
        ),
        child: Center(
          child: Text(
            nameRu, 
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32, 
              color: AppColors.mainAppTextColor, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    }

    Widget frontScrollPart(){
      return DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.65,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollcontroller){
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), 
                topRight: Radius.circular(15)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  controller: scrollcontroller,
                  children: [
                    visitDateInfo(),
                    const Divider(height: 1, color: Colors.grey),
                    selectVisitDateWidget(),
                    tariff(
                      tariffNameRuList, 
                      tariffPriceList, 
                      tariffPriceCurrencyList, 
                      scrollcontroller
                    ),
                    paymentButton(),
                    const SizedBox(height: 100),
                    forCustomInfoScreen()
                  ],
                ),
              ),
            ),
          );
        }
      );
    }

    return Scaffold(
      body: FutureBuilder<ActivityList>(
        future: getData(tokensBox.get(AppTexts.accessName)),
        builder: (BuildContext context, AsyncSnapshot<ActivityList> snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting: 
              return const Align(
                alignment: Alignment.center,
                child: Text(
                  AppTexts.systemLoadingText, 
                  style: TextStyle(
                    fontSize: 25, 
                    color: AppColors.mainAppColor,
                  ),
                ),
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
                for(
                  int tariffIndex = 0; 
                  tariffIndex<snapshot.data!.activity[index!].tariffs.length; 
                  tariffIndex++
                ){
                  tariffNameRuList.add(
                    snapshot.data!.activity[index!].tariffs[tariffIndex].nameRu
                  );
                  tariffPriceList.add(
                    snapshot.data!.activity[index!].tariffs[tariffIndex].priceInfo.price
                  );
                  tariffPriceCurrencyList.add(
                    snapshot.data!.activity[index!].tariffs[tariffIndex].priceInfo.currency
                  );
                }
                return Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: AppColors.transparentBackgroundColor,
                    elevation: 0
                  ),
                  body: Stack(
                    children: [
                      backImagePart(
                        snapshot.data!.activity[index!].imageUrl, 
                        snapshot.data!.activity[index!].nameRu
                      ),
                      frontScrollPart()
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