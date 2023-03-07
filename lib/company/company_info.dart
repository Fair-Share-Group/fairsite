import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/company/company_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:fairsite/controls/doc_field_text_edit.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'asset_list.dart';
import 'add_digital_assets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class CompanyInfo extends ConsumerWidget {
  final String entityId;

  const CompanyInfo(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(docSP('company/${entityId}'))
      .when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (companyDoc) {
          final adminDoc = ref.watch(docSP('admin/${entityId}'));
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(flex: 1, child: CompanyLogo(entityId)),
              Flexible(
                  flex: 1,
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: Text(
                          (companyDoc.data()?.containsKey('name') ?? false)
                              ? companyDoc.data()!['name']
                              : 'no name',
                        )),
                        Flexible(
                            child: Text(
                          (companyDoc.data()?.containsKey('founded') ?? false)
                              ? timeago.format(
                                  (companyDoc.data()!['founded'] as Timestamp)
                                      .toDate())
                              : 'no founded date',
                        )),
                      ])),
              Flexible(
                flex: 1,
                child: adminDoc.when(
                  loading: () => Container(),
                  error: (e, s) => ErrorWidget(e),
                  data: (adminSnap) =>
                      adminSnap.data() != null && adminSnap.data()!['exists']
                          ? AddDigitalAssetsDialog(entityId)
                          : Text("I am not an admin"),
                ),
              ),
              Flexible(flex: 5, child: AssetListView(entityId)),
            ],
          );
        },
      );
}