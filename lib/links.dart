import 'package:dio/dio.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart' as cicon;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:machinetest/url.dart';
import 'package:queue/queue.dart';

class Links extends GetxController {
  List<UrlModel> entries = [
    UrlModel(url: 'https://www.apple.com'),
    UrlModel(url: 'https://www.google.com'),
    UrlModel(url: 'https://www.hotels.com'),
    UrlModel(url: 'https://www.micrososft.com'),
    UrlModel(url: 'https://www.tesla.com')
  ];
  final queue = Queue();
  var status = 'START';

//on START button
  loadOnStart() async {
    if (status == 'RESET') {
      entries = [
        UrlModel(url: 'https://www.apple.com'),
        UrlModel(url: 'https://www.google.com'),
        UrlModel(url: 'https://www.hotels.com'),
        UrlModel(url: 'https://www.micrososft.com'),
        UrlModel(url: 'https://www.tesla.com')
      ];
      status = 'START';
      update();
    } else {
      status = 'PROCESSING';
      update();

      for (var i = 0; i < entries.length; i++) {
        try {
          queue.add(() async {
            var response = await Dio().get(entries[i].url!).catchError((e) {
              entries[i].status = 'FAILED';
              update();
            });
            var iconUrl = await Favicon.getBest(entries[i].url!);
            if (iconUrl != null) {
              entries[i].favicon = iconUrl.url;
              entries[i].status = 'DONE';
              update();
            } else {
              entries[i].status = 'FAILED';
              update();
            }

            //return;
          });
        } catch (e) {
          entries[i].status = 'FAILED';
          update();
        }
        await queue.onComplete;
        status = 'RESET';
        update();
      }
    }
  }

  //Insertion into the list
  insert(String url) async {
    entries.add(UrlModel(url: url));
    queue.add(() async {
      var response = await Dio().get(url);
      var iconUrl = await Favicon.getBest(url);
      if (iconUrl != null) {
        entries.singleWhere((element) => element.url == url).favicon =
            iconUrl.url;
        update();
      }
    });
    update();
  }

  //removing unProcessed items
  remove(int index) {
    print(index);
    entries.removeAt(index);
    update();
  }

  //for setting up short urls
  getShortUrl(String val) {
    return val.substring(val.indexOf('.') + 1);
  }
}
