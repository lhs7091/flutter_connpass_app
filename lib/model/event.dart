import 'package:flutter_connpass_app/export_path.dart';

class Events {
  int eventId;
  String title;
  String catCh;
  String description;
  String eventUrl;
  String startedAt;
  String endedAt;
  int limit;
  String hashTag;
  String eventType;
  int accepted;
  int waiting;
  String updatedAt;
  int ownerId;
  String ownerNickname;
  String ownerDisplayName;
  String place;
  String address;
  Null lat;
  Null lon;
  Series series;

  Events(
      {this.eventId,
      this.title,
      this.catCh,
      this.description,
      this.eventUrl,
      this.startedAt,
      this.endedAt,
      this.limit,
      this.hashTag,
      this.eventType,
      this.accepted,
      this.waiting,
      this.updatedAt,
      this.ownerId,
      this.ownerNickname,
      this.ownerDisplayName,
      this.place,
      this.address,
      this.lat,
      this.lon,
      this.series});

  Events.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    title = json['title'];
    catCh = json['catch'];
    description = json['description'];
    eventUrl = json['event_url'];
    startedAt = json['started_at'];
    endedAt = json['ended_at'];
    limit = json['limit'];
    hashTag = json['hash_tag'];
    eventType = json['event_type'];
    accepted = json['accepted'];
    waiting = json['waiting'];
    updatedAt = json['updated_at'];
    ownerId = json['owner_id'];
    ownerNickname = json['owner_nickname'];
    ownerDisplayName = json['owner_display_name'];
    place = json['place'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    series =
        json['series'] != null ? new Series.fromJson(json['series']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['title'] = this.title;
    data['catch'] = this.catCh;
    data['description'] = this.description;
    data['event_url'] = this.eventUrl;
    data['started_at'] = this.startedAt;
    data['ended_at'] = this.endedAt;
    data['limit'] = this.limit;
    data['hash_tag'] = this.hashTag;
    data['event_type'] = this.eventType;
    data['accepted'] = this.accepted;
    data['waiting'] = this.waiting;
    data['updated_at'] = this.updatedAt;
    data['owner_id'] = this.ownerId;
    data['owner_nickname'] = this.ownerNickname;
    data['owner_display_name'] = this.ownerDisplayName;
    data['place'] = this.place;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    if (this.series != null) {
      data['series'] = this.series.toJson();
    }
    return data;
  }
}
