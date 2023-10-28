import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'open_table_controller.g.dart';

@Injectable()
class OpenTableController = _OpenTableControllerBase with _$OpenTableController;

abstract class _OpenTableControllerBase with Store {
  final homeController = Modular.get<HomeController>();

  @observable
  int value = 0;
  @observable
  int qtdMembers = 0;
  @observable
  double totalValue = 0;
  @observable
  String clickLabel = 'onGoing';
  @observable
  String clickLabelTableInfo = 'ProfileView';
  @observable
  String userView;
  @observable
  String groupSelected;
  @observable
  String sellerGroupSelected;
  @observable
  List<dynamic> openTables = new List();
  @observable
  List<dynamic> filedTables = new List();
  @observable
  List<dynamic> refusedTables = new List();
  @observable
  List<dynamic> paidTables = new List();
  @observable
  List<dynamic> allTables = new List();
  @observable
  bool promoteHoster = false;
  @observable
  bool eventVerifier = true;
  @observable
  int eventcVerifier;
  @observable
  double totalValueGroup = 0;
  @observable
  num orderShettsAmount = 0;
  @observable
  String seller;
  @observable
  String stts;
  @observable
  String id;
  @observable
  int ordersheets = 0;
  @observable
  bool acceptDialog = false;
  @observable
  bool refuseDialog = false;

  @action
  void increment() {
    value++;
  }

  @action
  setAcceptDialog(bool ac) => acceptDialog = ac;
  @action
  setRefuseDialog(bool ref) => refuseDialog = ref;

  @action
  void setOrdersheets(num value) {
    orderShettsAmount += value;
  }

  @action
  void setOrdersheetsNull() {
    orderShettsAmount = 0;
  }

  @action
  setTotalValueGroup(double vall) {
    totalValueGroup += vall;
  }

  @action
  setTotalValueGroupNull() {
    totalValueGroup = 0;
  }

  @action
  setId(String _id) => id = _id;
  @action
  setStatusLabel(String sts) => stts = sts;
  @action
  setSeller(String selid) => seller = selid;
  @action
  setEventcVerifier(int _eventcVerifier) => eventcVerifier = _eventcVerifier;
  @action
  setEventVerifier(bool _eventVerifier) => eventVerifier = _eventVerifier;
  @action
  setClearTable(List<dynamic> _clearTable) => openTables = _clearTable;
  @action
  setClearFiledTables(List<dynamic> _filedTables) => filedTables = _filedTables;
  @action
  setClearRefusedTables(List<dynamic> _refusedTables) =>
      refusedTables = _refusedTables;
  @action
  setClearPaidTables(List<dynamic> _paidTables) => paidTables = _paidTables;
  @action
  setUserView(String _clickuser) => userView = _clickuser;
  @action
  setGroupSelected(String _group) => groupSelected = _group;
  @action
  setSellerGroupSelected(String _groupse) => sellerGroupSelected = _groupse;
  @action
  setClickLabel(String _click) => clickLabel = _click;
  @action
  setClickLabelTableInfo(String _clickinfo) => clickLabelTableInfo = _clickinfo;
  @action
  setPromotehost(bool _promote) => promoteHoster = _promote;
  @action
  acceptInvite() async {}

  @action
  getOpenSheets(QuerySnapshot members) {
    members.documents.forEach((member) async {
      if (member['role'] == 'created' || member['role'] == 'accepted_invite') {
        QuerySnapshot orderSheet = await Firestore.instance
            .collection('order_sheets')
            .where('group_id', isEqualTo: member['group_id'])
            .where('user_id', isEqualTo: member['user_id'])
            .getDocuments();
        if (orderSheet.documents.first['status'] == 'opened') {
          qtdMembers = qtdMembers + 1;
        }
      }
    });
  }

  @action
  setTables({String groupId, List tablesId}) {
    tablesId.forEach((tableId) async {
      DocumentSnapshot table =
          await Firestore.instance.collection('tables').document(tableId).get();

      table.reference.updateData({'status': 'used'});

      DocumentSnapshot group =
          await Firestore.instance.collection('groups').document(groupId).get();

      group.reference
          .collection('tables')
          .add({'table_id': tableId, 'label': table.data['label']});
    });
  }

  @action
  setStatus(var context) async {
    if (stts == 'queue') {
      QuerySnapshot queue = await Firestore.instance
          .collection('sellers')
          .document(seller)
          .collection('queue')
          .getDocuments();

      queue.documents.first.reference
          .collection('queued')
          .where('group_id', isEqualTo: id)
          .getDocuments()
          .then((value2) {
        value2.documents.first.reference.delete();
      });
    }

    if (stts == 'requested' || stts == 'queue') {
      await Firestore.instance
          .collection('groups')
          .document(id)
          .updateData({'status': 'open', 'opened_at': Timestamp.now()});

// Deletando documento da fila virtual do estabelecimento

      await createMessage('Mesa aberta!', id);
      // Modular.to.pop();
      Navigator.of(context).pop();
    }
  }

  @action
  unsetStatus(status, id, context) async {
    if (status == 'requested') {
      DocumentSnapshot group =
          await Firestore.instance.collection('groups').document(id).get();

      QuerySnapshot members =
          await group.reference.collection('members').getDocuments();

      group.reference.updateData({'status': 'refused'});

      members.documents.forEach((member) async {
        DocumentSnapshot user = await Firestore.instance
            .collection('users')
            .document(member.data['user_id'])
            .get();

        QuerySnapshot myGroup = await user.reference
            .collection('my_group')
            .where('id', isEqualTo: id)
            .getDocuments();

        myGroup.documents.first.reference.updateData({'status': 'refused'});
      });

      createMessage('Mesa recusada!', id);

      QuerySnapshot queue = await Firestore.instance
          .collection('sellers')
          .document(seller)
          .collection('queue')
          .getDocuments();

      if (queue.documents.isNotEmpty) {
        QuerySnapshot queued = await queue.documents.first.reference
            .collection('queued')
            .where('group_id', isEqualTo: id)
            .getDocuments();

        if (queued.documents.isNotEmpty) {
          queued.documents.first.reference.delete();
        }
      }
      refuseDialog = false;
      Navigator.of(context).pop();
    }
  }

  @action
  createMessage(text, groupID) async {
    Firestore.instance
        .collection('groups')
        .document(groupID)
        .get()
        .then((value) async {
      Firestore.instance
          .collection('chats')
          .where('group_id', isEqualTo: groupID)
          .getDocuments()
          .then((chat) {
        chat.documents[0].reference.collection('messages').add({
          'seller_id': value.data['seller_id'],
          'author_id': homeController.user.uid,
          'group_id': groupID,
          'type': 'create-table',
          'created_at': Timestamp.now(),
          'text': text,
        });
      });
    });
  }

  @action
  Future<dynamic> getOpenGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _user =
        await Firestore.instance.collection('users').document(user.uid).get();
    List mygroup = await _user.data['my_group'];
    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i])
          .get();
      if (_mygroup.data['status'] == 'open') {
        _mygroup.reference.updateData({'id': _mygroup.documentID});

        var contain =
            openTables.where((element) => element['id'] == _mygroup.documentID);
        if (contain.isEmpty) {
          await openTables.add(_mygroup.data);
        }
      }
    }
    return openTables;
  }

  @action
  Future<dynamic> getFiledGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _user =
        await Firestore.instance.collection('users').document(user.uid).get();
    List mygroup = await _user.data['my_group'];
    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i])
          .get();
      if (_mygroup.data['status'] == 'filed') {
        _mygroup.reference.updateData({'id': _mygroup.documentID});
        var contain = filedTables
            .where((element) => element['id'] == _mygroup.documentID);
        if (contain.isEmpty) {
          await filedTables.add(_mygroup.data);
        }
      }
    }
    return filedTables;
  }

  @action
  Future<dynamic> getRefusedGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _user =
        await Firestore.instance.collection('users').document(user.uid).get();
    List mygroup = await _user.data['my_group'];
    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i])
          .get();
      if (_mygroup.data['status'] == 'refused') {
        _mygroup.reference.updateData({'id': _mygroup.documentID});
        var contain = refusedTables
            .where((element) => element['id'] == _mygroup.documentID);
        if (contain.isEmpty) {
          await refusedTables.add(_mygroup.data);
        }
      }
    }
    return refusedTables;
  }

  @action
  Future<dynamic> getPaidGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _user =
        await Firestore.instance.collection('users').document(user.uid).get();
    List mygroup = await _user.data['my_group'];
    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i])
          .get();
      if (_mygroup.data['status'] == 'paid') {
        _mygroup.reference.updateData({'id': _mygroup.documentID});
        var contain =
            paidTables.where((element) => element['id'] == _mygroup.documentID);
        if (contain.isEmpty) {
          paidTables.add(_mygroup.data);
        }
      }
    }
    return paidTables;
  }

  countNofify(String group) async {
    // print('entrou');
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    QuerySnapshot _m = await Firestore.instance
        .collection("groups")
        .document(group)
        .collection('members')
        .where('user_id', isEqualTo: user.uid)
        .getDocuments();
    _m.documents.forEach((element) {
      return element.data.length;
    });
  }

  @action
  groupEventCounter(String group) {
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance
          .collection('users')
          .document(value.uid)
          .get()
          .then((value) {
        value.data['my_group'].forEach((element) {
          if (element == group) {
            int index = value.data['my_group'].indexOf(element);
            int counter = value.data['my_group_event_counter'][index];
            if (counter > 0) {
              return setEventVerifier(true);
            } else {
              return setEventVerifier(false);
            }
          }
        });
      });
    });
  }
}
