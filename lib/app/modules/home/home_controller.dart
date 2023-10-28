import 'package:pigu_seller/app/core/models/seller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'home_controller.g.dart';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  int value = 0;
  @observable
  int value2 = 0;
  @observable
  SellerModel sellerModel;
  @observable
  String categoryID = null;
  @observable
  String routerMenu = null;
  @observable
  String sellerId;
  @observable
  FirebaseUser user;
  @observable
  bool restaurantFav = false;
  @observable
  bool routerBillRequested = false;
  @observable
  List arrayTables = [];
  @observable
  String myGroupSelected;
  @observable
  String mymGroupSelected;
  @observable
  bool showDialog = false;
  @observable
  bool loading = false;
  @observable
  num amount = 0;
  @observable
  num totalDS = 0;

  @action
  void increment() {
    value++;
  }

  _HomeControllerBase() {
    getSeller();
  }

  @action
  setShowDialog(bool show) => showDialog = show;
  @action
  setLoading(bool _leading) => loading = _leading;
  @action
  setmMyGroupSelected(String _my) => myGroupSelected = _my;
  @action
  setMyGroupSelected(String _label) => mymGroupSelected = _label;
  @action
  setSellerId(String ee) => sellerId = ee;
  @action
  setCategoryID(String ee) => categoryID = ee;
  @action
  setRouterMenu(String eee) => routerMenu = eee;
  @action
  setrestfav(bool add) => restaurantFav = add;
  @action
  setSeller(SellerModel see) => sellerModel = see;
  @action
  setRouterBillRequested(bool _routerBill) => routerBillRequested = _routerBill;
  @action
  setArrayTables(List _arrayTables) => arrayTables = _arrayTables;
  @action
  setDS(num x) => totalDS = x;
  @action
  setAmount(num y) => amount = y;
  @action
  getUserAuth() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @action
  ordersAction({String orderSheetId}) async {
    DocumentSnapshot orderSheet = await Firestore.instance
        .collection('order_sheets')
        .document(orderSheetId)
        .get();

    QuerySnapshot orders = await Firestore.instance
        .collection('orders')
        .where('group_id', isEqualTo: orderSheet.data['group_id'])
        .where('status', isEqualTo: 'order_requested')
        .where('user_id', isEqualTo: orderSheet.data['user_id'])
        .getDocuments();

    orders.documents.forEach((order) async {
      String groupID = order.data['group_id'];

      QuerySnapshot cart =
          await order.reference.collection('cart_item').getDocuments();

      String note = cart.documents.first.data['note'];

      Firestore.instance
          .collection('chats')
          .where('group_id', isEqualTo: groupID)
          .getDocuments()
          .then((chat) async {
        DocumentReference message =
            await chat.documents[0].reference.collection('messages').add({
          'group_id': groupID,
          'client_note': note,
          'author_id': user.uid,
          'seller_note':
              'Pedido cancelado pois o checkout foi realizado antes dele ser aceito!',
          'order_id': order.documentID,
          'type': 'order_status_changed',
          'seller_id': order.data['seller_id'],
          'created_at': Timestamp.now(),
          'text': 'Pedido cancelado',
        });

        message.updateData({'id': message.documentID});
      });

      order.reference.updateData({'status': 'canceled'});
    });
  }

  @action
  groupPaid({String orderSheetId}) async {
    DocumentSnapshot orderSheet = await Firestore.instance
        .collection('order_sheets')
        .document(orderSheetId)
        .get();

    await orderSheet.reference
        .updateData({'status': 'paid', 'closed_at': Timestamp.now()});

    QuerySnapshot userMyGroup = await Firestore.instance
        .collection('users')
        .document(orderSheet.data['user_id'])
        .collection('my_group')
        .where('id', isEqualTo: orderSheet.data['group_id'])
        .getDocuments();

    userMyGroup.documents.first.reference.updateData({'status': 'paid'});

    QuerySnapshot globalGroup = await Firestore.instance
        .collection('order_sheets')
        .where('group_id', isEqualTo: orderSheet.data['group_id'])
        .getDocuments();

    QuerySnapshot orderSheetPaid = await Firestore.instance
        .collection('order_sheets')
        .where('group_id', isEqualTo: orderSheet.data['group_id'])
        .where('status', isEqualTo: 'paid')
        .getDocuments();

    DocumentSnapshot groupDS = await Firestore.instance
        .collection('groups')
        .document(orderSheet.data['group_id'])
        .get();

    groupDS.reference
        .collection('members')
        .where('user_id', isEqualTo: orderSheet.data['user_id'])
        .getDocuments()
        .then((value) {
      value.documents.first.reference.updateData({'role': 'paid'});
    });

    if (orderSheetPaid.documents.length == globalGroup.documents.length) {
      await groupDS.reference
          .updateData({'status': 'paid', 'closed_at': Timestamp.now()});

      clearTables(groupId: orderSheet.data['group_id']);

      createMessage(
        groupId: orderSheet.data['group_id'],
        userId: orderSheet.data['user_id'],
        groupPaid: true,
      );

      Firestore.instance
          .collection('invites')
          .where('group_id', isEqualTo: orderSheet.data['group_id'])
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.reference.delete();
        });
      });

      calculetedDuration(orderSheet.data['group_id']);
    } else {
      createMessage(
        groupId: orderSheet.data['group_id'],
        userId: orderSheet.data['user_id'],
        groupPaid: false,
      );
    }
  }

  @action
  calculetedDuration(String groupId) async {
    int y;
    int x;
    int microseconds;
    DocumentSnapshot groupDS =
        await Firestore.instance.collection('groups').document(groupId).get();

    y = await groupDS.data['closed_at'].microsecondsSinceEpoch;
    x = await groupDS.data['created_at'].microsecondsSinceEpoch;

    microseconds = y - x;
    int min;
    min = microseconds ~/ 60000000;

    if (y > 0) {
      await groupDS.reference.updateData({'duration': min});
    }
  }

  @action
  createMessage({String groupId, String userId, bool groupPaid}) async {
    // String text = '';
    QuerySnapshot chats = await Firestore.instance
        .collection('chats')
        .where('group_id', isEqualTo: groupId)
        .getDocuments();

    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(userId).get();

    DocumentReference messageUser =
        await chats.documents.first.reference.collection('messages').add({
      'author_id': userId,
      'created_at': Timestamp.now(),
      'group_id': groupId,
      'text': "Usuário '${user.data['username']}' quitou a conta",
      'type': 'create-table',
    });
    messageUser.updateData({'id': messageUser.documentID});

    if (groupPaid) {
      DocumentReference message =
          await chats.documents.first.reference.collection('messages').add({
        'author_id': userId,
        'created_at': Timestamp.now(),
        'group_id': groupId,
        'text': "Conta '${groupId.substring(0, 5).toUpperCase()}' fechada",
        'type': 'create-table',
      });
      message.updateData({'id': message.documentID});
    }
  }

  @action
  clearTables({String groupId}) async {
    QuerySnapshot groupTables = await Firestore.instance
        .collection('groups')
        .document(groupId)
        .collection('tables')
        .getDocuments();

    groupTables.documents.forEach((tables) async {
      DocumentSnapshot table = await Firestore.instance
          .collection('tables')
          .document(tables.data['table_id'])
          .get();

      table.reference.updateData({'status': 'open'});
    });
  }

  @action
  changeTables({List tables, String groupID}) async {
    QuerySnapshot grTables = await Firestore.instance
        .collection('groups')
        .document(groupID)
        .collection('tables')
        .getDocuments();

    grTables.documents.forEach((element) {
      Firestore.instance
          .collection('tables')
          .document(element.data['table_id'])
          .get()
          .then((value) async {
        await value.reference.updateData({'status': 'open'});
        await element.reference.delete();
      });
    });

    if (tables.isNotEmpty) {
      tables.forEach((element) {
        Firestore.instance
            .collection('tables')
            .document(element)
            .get()
            .then((value) async {
          await value.reference.updateData({'status': 'used'});

          DocumentSnapshot ds = await Firestore.instance
              .collection('groups')
              .document(groupID)
              .get();

          await ds.reference.collection('tables').add(
              {'table_id': value.data['id'], 'label': value.data['label']});
        });
      });
    }
  }

  @action
  getCategory() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("categories")
        .where('label_ptbr')
        .getDocuments();
    var list = querySnapshot.documents;
    list.forEach((element) {
      element.data;
    });
    // return markers;
  }

  @action
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length, (int index) {
      return Post(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }

  @action
  getAmount() async {
    num _totalAmount = 0;
    QuerySnapshot orderSheets = await Firestore.instance
        .collection('order_sheets')
        .where('status', isEqualTo: 'awaiting_checkout')
        .where('seller_id', isEqualTo: sellerId)
        .getDocuments();

    if (orderSheets.documents.isNotEmpty) {
      for (var i = 0; i < orderSheets.documents.length; i++) {
        QuerySnapshot orders = await orderSheets.documents[i].reference
            .collection('orders')
            .getDocuments();

        orders.documents.forEach((order) {
          if (order.data['item_status'] == 'created' ||
              order.data['item_status'] == 'created_shared') {
            _totalAmount += order.data['ordered_value'];
          }
        });
      }
    } else {
      amount = 0;
      totalDS = 0;
    }
    amount = _totalAmount;
    totalDS = orderSheets.documents.length;
  }

  @action
  userfav(String seller) async {}
  @action
  getSeller() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _user =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (_user.data['seller_id'] != null) {
      sellerId = await _user.data['seller_id'];
    } else {}
  }
}
