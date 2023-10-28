import 'package:cloud_firestore/cloud_firestore.dart';

class SellerModel {
  final DocumentReference reference;
  String adress;
  String avatar;
  String background_image;
  String category_id;
  GeoPoint location;
  String name;
  String seller_id;

  

  SellerModel(
      {this.reference,
      this.seller_id,
      this.adress,
      this.avatar,
      this.background_image,
      this.category_id,
      this.location,
      this.name,
    });

  factory SellerModel.fromDocument(DocumentSnapshot doc) {
    return SellerModel(
      reference: doc.reference,
      avatar: doc['avatar'],
      adress: doc['adress'],
      background_image: doc['backGroud_image'],
      category_id: doc['category_id'],
      location: doc['location'],
      name: doc['name'],
      seller_id: doc['seller_id']
    );
  }
  // Map<String, dynamic> convertUser(UserModel user) {
  //   Map<String, dynamic> map = {};
  //   map['reference'] = user.reference;
  //   map['avatar'] = user.avatar;
  //   map['birthdate'] = user.birthdate;
  //   map['country'] = user.country;
  //   map['countryPhoneCode'] = user.countryPhoneCode;
  //   map['createdAt'] = user.createdAt;
  //   map['email'] = user.email;
  //   map['firstName'] = user.firstName;
  //   map['mobilePhoneNumber'] = user.mobilePhoneNumber;
  //   map['regionPhoneCode'] = user.regionPhoneCode;
  //   map['sellerId'] = user.sellerId;
  //   map['status'] = user.status;
  //   map['surname'] = user.surname;

  //   return map;
  // }

  Map<String, dynamic> toJson(SellerModel user) => {
        'reference': user.reference,
        'avatar': user.avatar,
        'adress': user.adress,
        'background_image': user.background_image,
        'category_id': user.category_id,
        'location': user.location,
        'name': user.name,
        'seller_id': user.seller_id
     
      };

  userPhotoUpdate(String userPhoto) {
    reference.updateData({'avatar': userPhoto});
  }
}
