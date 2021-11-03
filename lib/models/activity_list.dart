import 'package:flutter/animation.dart';

class ActivityList{
  ActivityList({
    required this.activity
  });

  final List<Activity> activity;

  factory ActivityList.fromJson(List<dynamic> parsedJson) {

    List<Activity>? activity = <Activity>[];
    activity = parsedJson.map((i)=>Activity.fromJson(i)).cast<Activity>().toList();

    return ActivityList(
      activity: activity,
    );
  }
}

class Activity{
  Activity({
    //required this.availableDates,
    required this.nameRu,
    required this.imageUrl,
    required this.tariffs    
  });

  //final List<AvailableDate> availableDates;
  final String nameRu;
  final String imageUrl;
  final List<Tariff> tariffs;

  factory Activity.fromJson(Map<String, dynamic> data){
    final nameRu = data['nameRu'] as String;
    final imageUrl = data['imageUrl'] as String;
    final tariffsData = data['tariffs'] as List<dynamic>;
    final tariffs = tariffsData != null
      ? tariffsData.map((tariffsDatadata) => Tariff.fromJson(tariffsDatadata)).toList()
      : <Tariff>[];
    
    return Activity(
      nameRu: nameRu,
      imageUrl: imageUrl,
      tariffs: tariffs
    );
  }
}

class Tariff{
  Tariff({
    required this.nameRu,
    required this.priceInfo,
  });

  final String nameRu;
  final PriceInfo priceInfo;

  factory Tariff.fromJson(Map<String, dynamic> data){
    final nameRu = data['nameRu'] as String;
    final priceInfo = PriceInfo.fromJson(data['priceInfo']);

    return Tariff(
      nameRu: nameRu,
      priceInfo: priceInfo,
    );
  }
}

class PriceInfo{
  PriceInfo({
    required this.price,
    required this.currency,
  });

  final double price;
  final String currency; 

  factory PriceInfo.fromJson(Map<String, dynamic> data){
    final price = data['price'] as double;
    final currency = data['currency'] as String;

    return PriceInfo(
      price: price,
      currency: currency
    );
  }
}