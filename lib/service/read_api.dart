import 'dart:convert';

import 'package:flutter_connpass_app/export_path.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReadAPI {
  List<Events> _eventList = List<Events>();
  Future<List<Events>> getEventData(String keyword, int pageNum) async {
    //print(new DateFormat.yMMMd().format(new DateTime.now()));

    var f = new DateFormat('yyyyMMdd');

    String today =
        f.format(new DateTime.now().add(new Duration(days: pageNum)));
    final uri =
        'https://connpass.com/api/v1/event/?keyword=${keyword}&ymd=${today}&order=2';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = json.decode(response.body);
        ConnpassModel _model = ConnpassModel.fromJson(data);
        _eventList = _model.events;
      } catch (e) {
        print(e.toString());
        _eventList = null;
      }
    }
    return _eventList;
  }
}
