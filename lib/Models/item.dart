import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String? name;
  String? serviceName;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;
  double? rating;
  String? serviceAge;
  String? serviceCategory;
  int? numberOfServices;
  String? date;
  String? time;
  String? orderStatus;

  ItemModel({
    this.serviceName,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.name,
    this.rating,
    this.serviceAge,
    this.serviceCategory,
    this.numberOfServices,
    this.date,
    this.time,
    this.orderStatus,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
    shortInfo = json['shortInfo'];
    serviceCategory = json['serviceCategory'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    serviceAge = json['serviceAge'];
    name = json['name'];
    rating = json['rating'];
    price = json['price'];
    numberOfServices = json['numberOfServices'];
    time = json['time'];
    date = json['date'];
    date = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceName'] = this.serviceName;
    data['serviceCategory'] = this.serviceCategory;
    data['name'] = this.name;
    data['shortInfo'] = shortInfo;
    data['serviceAge'] = serviceAge;
    data['price'] = this.price;
    data['orderStatus'] = this.orderStatus;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    data['numberOfServices'] = this.numberOfServices;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}

// class PublishedDate {
//   String date;

//   PublishedDate({this.date});

//   PublishedDate.fromJson(Map<String, dynamic> json) {
//     date = json[date];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$date'] = this.date;
//     return data;
//   }
// }
