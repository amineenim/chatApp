class User {
  String? id;
  String? displayName;
  String? bio;

  User({this.id, this.displayName, this.bio});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['bio'] = bio;
    return data;
  }
}