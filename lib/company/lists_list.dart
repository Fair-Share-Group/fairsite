import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/company/list_list_item.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:fairsite/state/generic_state_notifier.dart';

final activeSort =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class Lists extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          // Row(
          //   children: [
          //     Text('sort by: '),
          //     DropdownButton<String>(
          //       value: ref.watch(activeSort) ?? 'id',
          //       icon: const Icon(Icons.arrow_downward),
          //       elevation: 16,
          //       // style: const TextStyle(color: Colors.deepPurple),
          //       underline: Container(
          //         height: 2,
          //         // color: Colors.deepPurpleAccent,
          //       ),
          //       onChanged: (String? newValue) {
          //         ref.read(activeSort.notifier).value = newValue;
          //       },
          //       items: <String>['name', 'id', 'time Created']
          //           .map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Text(value.toUpperCase()),
          //         );
          //       }).toList(),
          //     ),
          //     FilterMyEntities(),
          //   ],
          // ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: ref.watch(colSP('company')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (entities) {
                    List<Widget> memberCompany = [];
                    var companyList = entities.docs.map((e) {
                      ref
                          .watch(docSP(
                              'company/${e.id}/member/${CURRENT_USER.uid}'))
                          .when(
                              loading: () => Container(),
                              error: (e, s) => ErrorWidget(e),
                              data: (memberDoc) => memberDoc.exists
                                  ? memberCompany.add(ListItem(e.id))
                                  : memberCompany.add(SizedBox(
                                      width: 0,
                                      height: 0,
                                    )));
                    }).toList();
                    return memberCompany;
                  }))
          // ((ref.watch(filterMine) ?? false)
          //       ? entities.docs
          //           .where((d) =>
          //               d['author'] ==
          //               FirebaseAuth.instance.currentUser!.uid)
          //           .toList()
          //       : entities.docs)
          // ..sort((a, b) => a[ref.watch(activeSort) ?? 'id']
          //     .compareTo(b[ref.watch(activeSort) ?? 'id']))
        ],
      );
}
