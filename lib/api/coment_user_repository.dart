import '../models/comments_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_consts.dart';

class FetchUserCommentsList {
  var data = [];
  List<CommentsModel> results = [];
  //String urlList = ;

  Future<List<CommentsModel>> getuserList({String? query}) async {
    const limit = 25;
    int page = 1;
    var url = Uri.parse(BASE_URL + 'comments' + '?_limit=$limit&_page=$page');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => CommentsModel.fromJson(e)).toList();

        if (query != null) {
          results = results
              .where((element) =>
                  element.email!.toLowerCase().contains((query.toLowerCase())))
              .toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}
