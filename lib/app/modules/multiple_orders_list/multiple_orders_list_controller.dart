import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'multiple_orders_list_controller.g.dart';

@Injectable()
class MultipleOrdersListController = _MultipleOrdersListControllerBase
    with _$MultipleOrdersListController;

abstract class _MultipleOrdersListControllerBase with Store {
  final homeController = Modular.get<HomeController>();
  @observable
  int value = 0;
  @observable
  String clickLabel = 'onGoing';
  @observable
  String sellerText = '';
  @observable
  double total = 0;
  @observable
  bool acceptDialog = false;
  @observable
  bool refuseDialog = false;

  @action
  setAcceptDialog(bool ac) => acceptDialog = ac;
  @action
  setRefuseDialog(bool ref) => refuseDialog = ref;

  @action
  setClickLabel(String _click) => clickLabel = _click;
  @action
  setText(String _sellerText) => sellerText = _sellerText;

  @action
  setStatus(status, id) async {
    if (status == 'order_requested') {
      DocumentSnapshot order =
          await Firestore.instance.collection('orders').document(id).get();

      order.reference.updateData({'status': 'order_accepted'});

      QuerySnapshot cart =
          await order.reference.collection('cart_item').getDocuments();

      QuerySnapshot orderSheetAdd = await Firestore.instance
          .collection('order_sheets')
          .where('group_id', isEqualTo: order.data['group_id'])
          .where('user_id', isEqualTo: order.data['user_id'])
          .getDocuments();

      var cartData = cart.documents.first.data;

      QuerySnapshot getMembers =
          await order.reference.collection('members').getDocuments();

      if (getMembers.documents != null) {
        if (getMembers.documents.isNotEmpty) {
          List<String> membersId = List();

          membersId.add(order['user_id']);

          getMembers.documents.forEach((member) {
            membersId.add(member.data['user_id']);
          });

          var finalPrice =
              cartData['ordered_value'] / (getMembers.documents.length + 1);

          orderSheetAdd.documents.first.reference.collection('orders').add({
            'ordered_amount': cartData['ordered_amount'],
            'ordered_value': finalPrice,
            'item_status': 'created_shared',
            'listing_id': cartData['listing_id'],
            'seller_id': order.data['seller_id'],
            'user_id': order.data['user_id'],
            'description': cartData['description'],
            'title': cartData['title'],
            'created_at': cartData['created_at'],
            'order_id': id,

            // 'id': id,
            // 'note': '',
          });

          getMembers.documents.forEach((membro) async {
            QuerySnapshot memberBill = await Firestore.instance
                .collection('order_sheets')
                .where('group_id', isEqualTo: order['group_id'])
                .where('user_id', isEqualTo: membro['user_id'])
                .getDocuments();

            memberBill.documents.first.reference.collection('orders').add({
              'ordered_amount': cartData['ordered_amount'],
              'ordered_value': finalPrice,
              'item_status': 'created_shared',
              'listing_id': cartData['listing_id'],
              'description': cartData['description'],
              'title': cartData['title'],
              'created_at': cartData['created_at'],
              // 'id': id,
              'order_id': id,
              'seller_id': order.data['seller_id'],
              'user_id': order.data['user_id'],
              // 'note': '',
            });
          });

          QuerySnapshot ordersheetsGroups = await Firestore.instance
              .collection('order_sheets')
              .where('group_id', isEqualTo: order['group_id'])
              .getDocuments();
          ordersheetsGroups.documents.forEach((element) {
            element.reference.collection('orders').getDocuments().then((value) {
              // print()
              value.documents.forEach((element) {
                if (element.data['item_status'] == 'created' ||
                    element.data['item_status'] == 'created_shared') {
                  // print(
                  //     'TODOS OS PEDIDOS =====================================:${element.data} ');
                  total += element.data['ordered_value'].toDouble();

                  Firestore.instance
                      .collection('groups')
                      .document(order['group_id'])
                      .updateData({'group_value': total.toStringAsFixed(2)});
                }
              });
            });
          });
        } else {
          orderSheetAdd.documents.first.reference.collection('orders').add({
            'ordered_amount': cartData['ordered_amount'],
            'ordered_value': cartData['ordered_value'],
            'item_status': 'created',
            'listing_id': cartData['listing_id'],
            'description': cartData['description'],
            'title': cartData['title'],
            'seller_id': order.data['seller_id'],
            'user_id': order.data['user_id'],
            'created_at': cartData['created_at'],
            'order_id': id,
          });
          QuerySnapshot ordersheetsGroups = await Firestore.instance
              .collection('order_sheets')
              .where('group_id', isEqualTo: order['group_id'])
              .getDocuments();
          ordersheetsGroups.documents.forEach((element) {
            element.reference.collection('orders').getDocuments().then((value) {
              // print()
              value.documents.forEach((element) {
                if (element.data['item_status'] == 'created' ||
                    element.data['item_status'] == 'created_shared') {
                  // print(
                  //     'TODOS OS PEDIDOS =====================================:${element.data} ');
                  total += element.data['ordered_value'].toDouble();

                  total.toStringAsFixed(2);
                  Firestore.instance
                      .collection('groups')
                      .document(order['group_id'])
                      .updateData({
                    'group_value': double.parse(total.toStringAsFixed(2))
                  });
                }
              });
            });
          });
        }
      }

      createMessage('está sendo preparado!', id);
      Modular.to.pop();
    } else if (status == 'order_accepted') {
      await Firestore.instance
          .collection('orders')
          .document(id)
          .updateData({'status': 'order_delivered'});

      await createMessage('está pronto!', id);
      Modular.to.pop();
    }
  }

  @action
  unsetStatus(status, id) async {
    if (status == 'order_requested') {
      await Firestore.instance
          .collection('orders')
          .document(id)
          .updateData({'status': 'order_refused'});
      DocumentSnapshot order =
          await Firestore.instance.collection('orders').document(id).get();

      QuerySnapshot ordersheetsGroups = await Firestore.instance
          .collection('order_sheets')
          .where('group_id', isEqualTo: order['group_id'])
          .getDocuments();
      ordersheetsGroups.documents.forEach((element) {
        element.reference.collection('orders').getDocuments().then((value) {
          // print()
          value.documents.forEach((element) {
            if (element.data['item_status'] == 'created' ||
                element.data['item_status'] == 'created_shared') {
              // print(
              //     'TODOS OS PEDIDOS =====================================:${element.data} ');
              total += element.data['ordered_value'].toDouble();

              Firestore.instance
                  .collection('groups')
                  .document(order['group_id'])
                  .updateData(
                      {'group_value': double.parse(total.toStringAsFixed(2))});
            }
          });
        });
      });
      createMessage('precisou ser recusado!', id);

      Modular.to.pop();
    } else if (status == 'order_accepted') {
      DocumentSnapshot order =
          await Firestore.instance.collection('orders').document(id).get();

      order.reference.updateData({'status': 'order_canceled'});

      QuerySnapshot orderSheet = await Firestore.instance
          .collection('order_sheets')
          .where('group_id', isEqualTo: order.data['group_id'])
          .where('user_id', isEqualTo: order.data['user_id'])
          .getDocuments();

      QuerySnapshot orderOrderSheet = await orderSheet.documents.first.reference
          .collection('orders')
          .where('order_id', isEqualTo: id)
          .getDocuments();

      if (orderOrderSheet.documents.first.data['item_status'] == 'created') {
        orderOrderSheet.documents.first.reference
            .updateData({'item_status': 'canceled'});
      } else {
        orderOrderSheet.documents.first.reference
            .updateData({'item_status': 'canceled_shared'});
      }
      QuerySnapshot ordersheetsGroups = await Firestore.instance
          .collection('order_sheets')
          .where('group_id', isEqualTo: order['group_id'])
          .getDocuments();
      ordersheetsGroups.documents.forEach((element) {
        element.reference.collection('orders').getDocuments().then((value) {
          // print()
          value.documents.forEach((element) {
            if (element.data['item_status'] == 'created' ||
                element.data['item_status'] == 'created_shared') {
              // print(
              //     'TODOS OS PEDIDOS =====================================:${element.data} ');
              total += element.data['ordered_value'].toDouble();

              Firestore.instance
                  .collection('groups')
                  .document(order['group_id'])
                  .updateData(
                      {'group_value': double.parse(total.toStringAsFixed(2))});
            }
          });
        });
      });
      createMessage('precisou ser cancelado!', id);
      Modular.to.pop();
    }
  }

  @action
  createMessage(text, orderID) async {
    Firestore.instance
        .collection('orders')
        .document(orderID)
        .get()
        .then((value) async {
      var groupID;
      QuerySnapshot cart =
          await value.reference.collection('cart_item').getDocuments();
      String note = cart.documents.first.data['note'];
      groupID = value.data['group_id'];
      Firestore.instance
          .collection('chats')
          .where('group_id', isEqualTo: groupID)
          .getDocuments()
          .then((chat) {
        chat.documents[0].reference.collection('messages').add({
          'group_id': groupID,
          'client_note': note,
          'author_id': value.data['user_id'],
          'seller_note': sellerText,
          'order_id': orderID,
          'type': 'order_status_changed',
          'seller_id': value.data['seller_id'],
          'created_at': Timestamp.now(),
          'text': text,
        }).then((valueMess) {
          setText('');
          valueMess.updateData({'id': valueMess.documentID});
        });
      });
    });
  }

  @action
  void increment() {
    value++;
  }
}
