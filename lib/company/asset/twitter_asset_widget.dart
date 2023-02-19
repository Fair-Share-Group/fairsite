import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

Future<dynamic> _getTwitterData(String username) async {
  String apiUrl =
      "https://twitter154.p.rapidapi.com/user/details?username=${username.toLowerCase()}";

  final http.Response res = await http.get(
    Uri.parse("$apiUrl"),
    headers: {
      'X-RapidAPI-Key': 'e082e1c185mshc384dc4309007bcp1f62e0jsnf396270175ec',
      'X-RapidAPI-Host': 'twitter154.p.rapidapi.com'
    },
  );

  if (res.statusCode == 404) {
    return "User could not be found";
  }

  if (res.statusCode == 401 || res.statusCode == 403) {
    return "Application is not authenticated";
  }

  var body = jsonDecode(res.body);

  return body;
}

class TwitterAssetWidget extends ConsumerWidget {
  final DocumentReference asset;
  static const AssetType _type = AssetType.Twitter;

  TwitterAssetWidget(this.asset);

 @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(docSP(asset.path)).when(
    loading: () => Container(), 
    error: (e, s) => ErrorWidget(e), 
    data: (assetDoc) => Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Padding(padding: const EdgeInsets.only(left: 15), child: 
            SvgPicture.asset('svg/twitter.svg', width: 36, height: 36,),
          ),
          Expanded(child: ListTile(
            title: Text(_type.name),
            subtitle: Text(data(assetDoc, 'id')),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _getTwitterData("google").then((value) => print(value));
              },
              ),)
          )
      ]),
      Padding(padding: const EdgeInsets.only(left: 15, bottom: 15), child: ActionChip(
            avatar: const Icon(Icons.open_in_new_rounded, color: Colors.black26, size: 18,),
            label: Text("${getAssetUrl(_type, data(assetDoc, 'id'))}"),
            onPressed: () => openAssestWebpage(_type, data(assetDoc, 'id'), context),
            ),
      ),
      ]),
    ) 
    );
}
