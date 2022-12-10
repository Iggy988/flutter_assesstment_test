class CommentsModel {
  int? id;
  //String? name;
  String? body;
  String? email;

  CommentsModel({
    this.id,
    this.body,
    this.email,
  });

  CommentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    //name = json['name'];
    body = json['body'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['body'] = this.body;
    data['email'] = this.email;

    return data;
  }
}
