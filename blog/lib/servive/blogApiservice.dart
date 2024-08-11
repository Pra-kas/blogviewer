import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> fetchBlogs() async {
  const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  const String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"status": true, "data": data['blogs']};
    } else {
      return {"status": false, "data": []};
    }
  } catch (e) {
    return {"status": false, "data": [], "error": e.toString()};
  }
}
