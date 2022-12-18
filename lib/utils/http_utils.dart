import 'package:http/http.dart' show Client;

class HttpUtils {
  final Client client = Client();
  HttpUtils._init();
  static final HttpUtils _instance = HttpUtils._init();

  static HttpUtils get instance => _instance;

  Future<HttpResponse> get(Uri uri, {Map<String, String>? headers}) async {
    var response = await client.get(uri, headers: headers);
    return HttpResponse(
      data: response.body,
      status: response.statusCode == 200 ? Status.success : Status.failure,
    );
  }
}

class HttpResponse {
  final Status status;
  final String data;

  HttpResponse({
    required this.data,
    required this.status,
  });
}

enum Status {
  success,
  failure,
}
