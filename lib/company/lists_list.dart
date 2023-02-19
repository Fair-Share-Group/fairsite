import 'package:fairsite/company/company_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/company/list_list_item.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:fairsite/state/generic_state_notifier.dart';

final activeSort =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class Lists extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: ref.watch(colSP('company')).when(
            loading: () => [Container()],
            error: (e, s) => [ErrorWidget(e)],
            data: (entities) {
              final filter = ref.watch(listFilterProvider);

              return (entities.docs
                  // ((ref.watch(filterMine) ?? false)
                  //       ? entities.docs
                  //           .where((d) =>
                  //               d['author'] ==
                  //               FirebaseAuth.instance.currentUser!.uid)
                  //           .toList()
                  //       : entities.docs)
                  // ..sort((a, b) => a[ref.watch(activeSort) ?? 'id']
                  //     .compareTo(b[ref.watch(activeSort) ?? 'id']))
                  )
                  .map((entity) {
                return ListItem(entity.id, filter);
              }).toList();
            }));
  }
}
