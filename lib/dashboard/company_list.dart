import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/providers/firestore.dart';

class CompanyList extends ConsumerWidget {
  final String searchId;

  CompanyList(this.searchId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
      children: ref.watch(colSP('search/$searchId/res')).when(
          loading: () => [],
          error: (e, s) => [ErrorWidget(e)],
          data: (results) => results.docs
              .map((res) => ListTile(title: Text(res.data()['#'])))
              .toList()));
}
