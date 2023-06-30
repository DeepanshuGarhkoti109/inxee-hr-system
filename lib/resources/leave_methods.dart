import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getLeaves({required String email}) async {
    final CollectionReference<Map<String, dynamic>> userDb =
        this._firestore.collection('users');

    return await userDb
        .where('email', isEqualTo: email)
        .get()
        .then<Map<String, int>>(
            (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      return <String, int>{
        'EL': querySnapshot.docs[0].data()['EL'],
        'CL': querySnapshot.docs[0].data()['CL'],
        'SL': querySnapshot.docs[0].data()['SL'],
        'LWP': querySnapshot.docs[0].data()['LWP'],
      };
    }, onError: (dynamic err) {
      print('Error getting document: $err');
    });
  }

  Future<Map<String, Map<String, int>>> getLeavesAllUsers() async {
    final CollectionReference<Map<String, dynamic>> userDb =
        this._firestore.collection('users');
    final Map<String, Map<String, int>> mapping = <String, Map<String, int>>{};

    await userDb
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
      for (final doc in querySnapshot.docs) {
        mapping.addAll(<String, Map<String, int>>{
          doc.data()['email']: <String, int>{
            'CL': doc.data()['CL'],
            'EL': doc.data()['EL'],
            'SL': doc.data()['SL'],
            'LWP': doc.data()['LWP']
          },
        });
      }
    });

    return mapping;
  }

  Future resetLeavesHalfYear() async {
    final CollectionReference<Map<String, dynamic>> userDb =
        this._firestore.collection('users');

    await userDb
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
      for (final doc in querySnapshot.docs) {
        final int cl = doc.data()['CL'];
        final int el = doc.data()['EL'];
        await doc.reference
            .update(<String, double>{'CL': cl + 3.5, 'EL': el + 7.5});
      }
    });
  }

  Future resetLeavesEndOfYear() async {
    final CollectionReference<Map<String, dynamic>> userDb =
        this._firestore.collection('users');

    await userDb
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
      for (final doc in querySnapshot.docs) {
        final int el = doc.data()['EL'];
        await doc.reference.update(<String, double>{'CL': 7, 'EL': el + 7.5});
      }
    });
  }

  Future resetLeavesEndOfMonth() async {
    final CollectionReference<Map<String, dynamic>> userDb =
        this._firestore.collection('users');

    await userDb
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
      for (final doc in querySnapshot.docs) {
        await doc.reference.update(<String, double>{'SL': 2});
      }
    });
  }

  Future<void> applyLeave(
      {required String email,
      required Timestamp start,
      required Timestamp end}) async {
    final CollectionReference<Map<String, dynamic>> leaveDb =
        this._firestore.collection('leave-apps');

    DocumentReference leaveRef = await leaveDb.add(<String, dynamic>{
      'approved': false,
      'email': email,
      'start': start,
      'end': end,
    });

    print("Leave application generated with id ${leaveRef.id}");
  }

  Future getLeaveApps() async {
    final CollectionReference<Map<String, dynamic>> leaveDb =
        this._firestore.collection('leave-apps');

    final Map<String, Map<String, dynamic>> mapping =
        <String, Map<String, dynamic>>{};

    await leaveDb
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
      for (final doc in querySnapshot.docs) {
        mapping.addAll(<String, Map<String, dynamic>>{
          doc.id: <String, dynamic>{
            'approved': doc.data()['approved'],
            'email': doc.data()['email'],
            'start': (doc.data()['start'] as Timestamp).toDate(),
            'end': (doc.data()['end'] as Timestamp).toDate(),
          }
        });
      }
    });

    return mapping;
  }

  Future<void> approveLeave({required String lId}) async {
    final CollectionReference<Map<String, dynamic>> leaveDb =
        this._firestore.collection('leave-apps');

    final List<Object> emailAndDays = await leaveDb
        .doc(lId)
        .update(<String, bool>{'approved': true}).then<List<Object>>(
      (void _) async {
        final List<Object> emailAndDays = await leaveDb
            .doc(lId)
            .get()
            .then<List<Object>>(
                (DocumentSnapshot<Map<String, dynamic>> doc) async {
          final String email = doc.data()?['email'] as String;
          final DateTime start = DateTime.parse(
              (doc.data()?['start'] as Timestamp).toDate().toString());
          final DateTime end = DateTime.parse(
              (doc.data()?['end'] as Timestamp).toDate().toString());
          return <Object>[email, end.difference(start).inDays];
        });
        print('Leave Approved for user ${emailAndDays[0]}');

        return emailAndDays;
      },
    );

    this.reduceLeaves(emailAndDays: emailAndDays);
  }

  Future reduceLeaves({required List<Object> emailAndDays}) async {
    final CollectionReference<Map<String, dynamic>> userDb =
        this._firestore.collection('user');

    await userDb
        .where('email', isEqualTo: emailAndDays[0])
        .limit(1)
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
      final int days = emailAndDays[1] as int;
      int cl = querySnapshot.docs[0].data()['CL'];
      int el = querySnapshot.docs[0].data()['EL'];
      int lwp = querySnapshot.docs[0].data()['LWP'];

      if (days <= 2) {
        if (cl >= days) {
          cl -= days;
          print("$days CL deducted");
        } else {
          if (el >= days - cl) {
            print("$cl CL and ${days - cl} EL deducted");

            el -= days - cl;
            cl = 0;
          } else {
            print("$cl CL, $el EL and ${days - cl - el} LWP");

            lwp += days - cl - el;
            cl = 0;
            el = 0;
          }
        }
      } else {
        if (cl >= days) {
          cl -= 2;

          if (el >= days - 2) {
            el -= days - 2;
          } else {
            lwp += (days - el - 2);
            el = 0;
          }
        } else {
          if (el >= days - cl) {
            el -= days - cl;
          } else {
            lwp -= days - cl - el;
            el -= 0;
          }

          cl = 0;
        }
      }

      await querySnapshot.docs[0].reference
          .update(<String, int>{'CL': cl, 'EL': el, 'LWP': lwp});
    });
  }
}
