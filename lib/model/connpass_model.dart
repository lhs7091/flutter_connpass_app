import 'package:flutter_connpass_app/export_path.dart';

class ConnpassModel {
  int resultsStart;
  int resultsReturned;
  int resultsAvailable;
  List<Events> events;

  ConnpassModel(
      {this.resultsStart,
      this.resultsReturned,
      this.resultsAvailable,
      this.events});

  ConnpassModel.fromJson(Map<String, dynamic> json) {
    resultsStart = json['results_start'];
    resultsReturned = json['results_returned'];
    resultsAvailable = json['results_available'];
    if (json['events'] != null) {
      events = new List<Events>();
      json['events'].forEach((v) {
        events.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results_start'] = this.resultsStart;
    data['results_returned'] = this.resultsReturned;
    data['results_available'] = this.resultsAvailable;
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
