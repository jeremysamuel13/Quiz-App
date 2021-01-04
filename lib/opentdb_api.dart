import 'dart:convert';
import 'question.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class OpenTDBAPI {
  OpenTDBAPI();

  Future getQuestions() async {
    if (await waitForConnection()) {
      return _fetchData();
    }
  }

  Future _fetchData() async {
    var link = "https://opentdb.com/api.php?amount=10&type=boolean";

    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "applications/json"});

    var data = jsonDecode(res.body);

    var rest = data["results"] as List;

    var list = rest.map<Question>((json) => Question.fromJson(json)).toList();

    return list;
  }

  Future<bool> waitForConnection() async {
    bool _connected = false;
    while (!_connected) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          _connected = true;
        }
      } on SocketException catch (_) {}
    }
    return _connected;
  }
}
