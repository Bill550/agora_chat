import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRequestManager {
  static String host = "<#Developer Token Server#>";
  static String registerUrl = "/app/chat/user/register";
  static String loginUrl = "/app/chat/user/login";
  static Future<bool> registerToAppServer({
    required String userId,
    required String password,
  }) async {
    bool ret = false;
    Map<String, String> params = {};
    params["userAccount"] = userId;
    params["userPassword"] = password;
    var uri = Uri.https(host, registerUrl);
    var client = http.Client();
    var response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(params),
    );
    do {
      if (response.statusCode != 200) {
        break;
      }
      Map<String, dynamic>? map = convert.jsonDecode(response.body);
      if (map != null) {
        if (map["code"] == "RES_OK") {
          ret = true;
        }
      }
    } while (false);
    return ret;
  }

  static Future<String?> loginToAppServer({
    required String userId,
    required String password,
  }) async {
    Map<String, String> params = {};
    params["userAccount"] = userId;
    params["userPassword"] = password;
    var uri = Uri.https(host, loginUrl);
    var client = http.Client();
    var response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(params),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic>? map = convert.jsonDecode(response.body);
      if (map != null) {
        if (map["code"] == "RES_OK") {
          return map["accessToken"];
        }
      }
    }
    return null;
  }
}
