import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/controls/doc_field_text_edit.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

// import '../extensions/string_validations.dart';
// import '../search/search_details.dart';

class ListItem extends ConsumerWidget {
  final String entityId;
  final String filter;
  const ListItem(this.entityId, this.filter);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('company/' + entityId)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => entityDoc.exists == false
              ? Center(child: Text('No entity data exists'))
              : entityDoc
                      .data()!['name']
                      .toString()
                      .toLowerCase()
                      .contains(filter)
                  ? Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                          color: ref.read(activeList.notifier).value == entityId
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              (entityDoc.data()!['name'] != null)
                                  ? entityDoc.data()!['name']
                                  : 'undefined list name',
                            ),
                            subtitle: Text('Last changed: ' +
                                Jiffy(entityDoc.data()!['lastUpdateTime'] ==
                                            null
                                        ? DateTime(0001, 1, 1, 00, 00)
                                        : entityDoc
                                            .data()!['lastUpdateTime']
                                            .toDate())
                                    .format() +
                                '\n' +
                                'Last updated: ' +
                                Jiffy(entityDoc.data()!['lastUpdateTime'] ==
                                            null
                                        ? DateTime(0001, 1, 1, 00, 00)
                                        : entityDoc
                                            .data()!['lastUpdateTime']
                                            .toDate())
                                    .format()),
                            isThreeLine: true,
                            onTap: () {
                              ref.read(activeList.notifier).value = entityId;
                            },
                          ),
                          // Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: <Widget>[
                          //       Container(
                          //           padding: EdgeInsets.all(8.0),
                          //           child: Text.rich(TextSpan(
                          //               style: TextStyle(
                          //                   decoration: TextDecoration.underline),
                          //               //make link underline
                          //               text: "View source page",
                          //               recognizer: TapGestureRecognizer()
                          //                 ..onTap = () async {
                          //                   //on tap code here, you can navigate to other page or URL
                          //                   final url = Uri.parse(
                          //                       entityDoc.data()!['domainURL'] ?? '#');
                          //                   var urllaunchable = await canLaunchUrl(
                          //                       url); //canLaunch is from url_launcher package
                          //                   if (urllaunchable) {
                          //                     await launchUrl(
                          //                         url); //launch is from url_launcher package to launch URL
                          //                   } else {
                          //                     print("URL can't be launched.");
                          //                   }
                          //                 })))
                          //     ]),
                          // Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: <Widget>[
                          //       Container(
                          //           padding: EdgeInsets.all(8.0),
                          //           child: Text.rich(TextSpan(
                          //               style: TextStyle(
                          //                   decoration: TextDecoration.underline),
                          //               //make link underline
                          //               text: "View source list",
                          //               recognizer: TapGestureRecognizer()
                          //                 ..onTap = () async {
                          //                   //on tap code here, you can navigate to other page or URL
                          //                   final url = Uri.parse(
                          //                       entityDoc.data()!['listURL'] ?? '#');
                          //                   var urllaunchable = await canLaunchUrl(
                          //                       url); //canLaunch is from url_launcher package
                          //                   if (urllaunchable) {
                          //                     await launchUrl(
                          //                         url); //launch is from url_launcher package to launch URL
                          //                   } else {
                          //                     print("URL can't be launched.");
                          //                   }
                          //                 })))
                          //     ]),
                          // InkWell(
                          //     child: IconButton(
                          //         icon: const Icon(Icons.edit),
                          //         onPressed: () {
                          //           // showDialog(
                          //           //     context: context,
                          //           //     builder: (BuildContext context) {
                          //           //       final _formKey = GlobalKey<FormState>();
                          //           //       return AlertDialog(
                          //           //         scrollable: true,
                          //           //         title: Text('Sanction list entity fields'),
                          //           //         content: Padding(
                          //           //           padding: const EdgeInsets.all(8.0),
                          //           //           child: Form(
                          //           //             key: _formKey,
                          //           //             child: Column(
                          //           //               children: <Widget>[
                          //           //                 DocFieldTextEdit(
                          //           //                     FirebaseFirestore.instance
                          //           //                         .doc('list/${entityId}'),
                          //           //                     'name',
                          //           //                     decoration: InputDecoration(
                          //           //                         hintText: "Entity Name")),
                          //           //                 DocFieldTextEdit(
                          //           //                     FirebaseFirestore.instance
                          //           //                         .doc('list/${entityId}'),
                          //           //                     'address',
                          //           //                     decoration: InputDecoration(
                          //           //                         hintText: "Entity address")),
                          //           //                 DocFieldTextEdit(
                          //           //                     FirebaseFirestore.instance
                          //           //                         .doc('list/${entityId}'),
                          //           //                     'dataSource',
                          //           //                     decoration: InputDecoration(
                          //           //                         hintText: "Data Source")),
                          //           //                 DocFieldTextEdit(
                          //           //                     FirebaseFirestore.instance
                          //           //                         .doc('list/${entityId}'),
                          //           //                     'website',
                          //           //                     decoration: InputDecoration(
                          //           //                         hintText: "Website")),
                          //           //               ],
                          //           //             ),
                          //           //           ),
                          //           //         ),
                          //           //         actions: [
                          //           //           ElevatedButton(
                          //           //             onPressed: () {
                          //           //               Navigator.of(context).pop();
                          //           //             },
                          //           //             child: const Text('Done'),
                          //           //           )
                          //           //         ],
                          //           //       );
                          //           //     });
                          //         })),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
        );
  }
}
