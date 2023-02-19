import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:fairsite/company/asset/ShareAllocationWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/app_bar.dart';
import 'package:fairsite/company/lists_list.dart';
import 'package:fairsite/company/company_details.dart';
import 'package:fairsite/state/generic_state_notifier.dart';
import 'package:fairsite/drawer.dart';
import 'package:fairsite/common.dart';
// import '../controls/custom_json_viewer.dart';
// import 'package:flutter_json_viewer/flutter_json_viewer.dart';

final activeList =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final selectedItem =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

StateNotifierProvider listFilterProvider =
    StateNotifierProvider<GenericStateNotifier<String>, String?>(
        (ref) => GenericStateNotifier<String>(""));

class CompanyListPage extends ConsumerWidget {
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFD9D9D9),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0)),
                                ),
                                hintText: 'Search',
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                ),
                              ),
                              focusNode: searchFocus,
                              onChanged: (value) => ref
                                  .read(listFilterProvider.notifier)
                                  .state = searchController.text,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: Lists(),
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('company')
                                    .add({'name': 'New company'}).then((ref) {
                                  ref
                                      .collection('admin')
                                      .doc(CURRENT_USER.uid)
                                      .set({
                                    'timeJoined': FieldValue.serverTimestamp()
                                  });
                                  ref
                                      .collection('member')
                                      .doc(CURRENT_USER.uid)
                                      .set({
                                    'timeJoined': FieldValue.serverTimestamp()
                                  });
                                });
                              },
                              icon: const Icon(Icons.add)),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: ref.watch(activeList) == null
                        ? Container()
                        : CompanyDetails(
                            ref.watch(activeList)!, selectedItem.notifier),
                  ),
                  Flexible(
                      child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ref.watch(selectedItem) == null
                                      ? Container()
                                      : Text(ref.watch(selectedItem)!))
                            ],
                          ),
                        ))
                      ])))
                    Flexible(child: ShareAllocationWidget())
                ])));
  }
}
