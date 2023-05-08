class User {
  int userId = 0;
  int points = 0;

  User({required this.points});
  User.fromMap(dynamic obj) {
    userId = obj['userId'];
    points = obj['points'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId + 1,
      'points': points,
    };

    return map;
  }
}
