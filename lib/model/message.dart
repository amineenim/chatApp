import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? from;
  String? to;
  String? content;
  Timestamp? timestamp;

  Message({this.id, this.from, this.to, this.content, this.timestamp});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
    content = json['content'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from'] = from;
    data['to'] = to;
    data['content'] = content;
    data['timestamp'] = timestamp;
    return data;
  }
}

