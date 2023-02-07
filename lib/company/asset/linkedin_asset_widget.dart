// import 'dart:ffi';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../providers/firestore.dart';

class LinkedInAssetWidget extends ConsumerWidget {
  late String _linkedinData;
  final DocumentReference asset;

  LinkedInAssetWidget(this.asset);

  Future<String> _getLinkedinData(String id) async {
    final keyDoc = await FirebaseFirestore.instance.doc('api/rapidApi').get();
    final response = await http.post(
        Uri.parse(
            'https://linkedin-company-data.p.rapidapi.com/linkedInCompanyDataJsonV3Beta?liUrl=${getAssetUrl(AssetType.LinkedIn, id)}'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key': keyDoc.get('key'),
          'X-RapidAPI-Host': 'linkedin-company-data.p.rapidapi.com'
        }); //Example data (should use the company linkedin url in the uri.parse and the correct API key)
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      await asset.update({"followers": (body['results']['followerCount'] ?? 'Could not find follower count')});
      return _linkedinData = response.body;
    } else {
      throw Exception("No data found");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(asset.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (assetDoc) => ListTile(
                title: Text('${AssetType.LinkedIn.name} - ${data(assetDoc, 'id')}'),
                onTap: () => openAssestWebpage(AssetType.LinkedIn, data(assetDoc, 'id'), context),
                subtitle:
                    Text("followers: ${data(assetDoc, 'followers')}"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _getLinkedinData(data(assetDoc, 'id'));
                  },
                ),
              ));
}
