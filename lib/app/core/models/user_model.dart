import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String avatar;
  Timestamp created_at;
  String email;
  String fullname;
  String username;
  String mobile_full_number;
  String mobile_phone_number;
  String mobile_region_code;
  String status;
  String cpf;
  bool notification_enabled;

  UserModel(
      {this.avatar,
      this.created_at,
      this.email,
      this.fullname,
      this.username,
      this.mobile_phone_number,
      this.mobile_full_number,
      this.mobile_region_code,
      this.status,
      this.cpf,
      this.notification_enabled,
      this.id});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        id: doc['id'],
        avatar: doc['avatar'],
        created_at: doc['created_at'],
        email: doc['email'],
        fullname: doc['fullname'],
        username: doc['username'],
        mobile_phone_number: doc['mobile_phone_number'],
        mobile_region_code: doc['mobile_region_code'],
        status: doc['status'],
        cpf: doc['cpf'],
        mobile_full_number: doc['mobile_full_number'],
        notification_enabled: doc['notification_enabled']);
  }
  Map<String, dynamic> convertUser(UserModel user) {
    Map<String, dynamic> map = {};
    map['id'] = user.id;
    map['avatar'] = user.avatar;
    map['created_at'] = user.created_at;
    map['email'] = user.email;
    map['fullname'] = user.fullname;
    map['username'] = user.username;
    map['mobile_phone_number'] = user.mobile_phone_number;
    map['mobile_region_code'] = user.mobile_region_code;
    map['status'] = user.status;
    map['cpf'] = user.cpf;
    map['notification_enabled'] = user.notification_enabled;
    map['mobile_full_number'] = user.mobile_full_number;

    return map;
  }

  Map<String, dynamic> toJson(UserModel user) => {
        'id': user.id,
        'avatar': user.avatar,
        'created_at': user.created_at,
        'email': user.email,
        'fullname': user.fullname,
        'username': user.username,
        'mobile_phone_number': user.mobile_phone_number,
        'mobile_region_code': user.mobile_region_code,
        'status': user.status,
        'cpf': user.cpf,
        'notification_enabled': user.notification_enabled,
        'mobile_full_number': user.mobile_full_number
      };

  // userPhotoUpdate(String userPhoto) {
  //   reference.updateData({'avatar': userPhoto});
  // }
}
