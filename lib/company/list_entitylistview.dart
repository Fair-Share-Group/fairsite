import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fairsite/state/generic_state_notifier.dart';

class EntityListView extends ConsumerWidget {
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<String?>> selectedItem;

  const EntityListView(this.entityId, this.selectedItem);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: ref.watch(docSP('company/${entityId}')).when(
              loading: () => [],
              error: (e, s) => [],
              data: (entityDoc) => ref
                  .watch(colSP('company/$entityId/item'))
                  .when(
                      loading: () => [],
                      error: (e, s) => [ErrorWidget(e)],
                      data: (entities) => entities.docs
                          .map((entity) => ListTile(
                              title: Text((entityDoc.data()!['entitiesName1'] == null
                                      ? ''
                                      : entity.get(
                                          entityDoc.data()!['entitiesName1'])) +
                                  (entityDoc.data()!['entitiesName2'] == null
                                      ? ''
                                      : entity.get(
                                          entityDoc.data()!['entitiesName2'])) +
                                  (entityDoc.data()!['entitiesName3'] == null
                                      ? ''
                                      : entity.get(
                                          entityDoc.data()!['entitiesName3']))),
                              subtitle: Text(
                                  (entity.data()[entityDoc.data()!['entitiesAddress']] != null)
                                      ? 'Location: ' +
                                          entity.data()[entityDoc
                                              .data()!['entitiesAddress']]
                                      : 'Location: undefined'),
                              isThreeLine: true,
                              onTap: () {
                                ref.read(selectedItem).value = entityId;
                                // Map.fromEntries(
                                //     entity.data().entries.toList()
                                //       ..sort((e1, e2) => e1.key.compareTo(e2.key)))
                                ;
                              }))
                          .toList())))
    ]);
  }
}
