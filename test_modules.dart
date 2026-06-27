
import 'dart:convert';
import 'dart:io';

void main() async {
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse("https://test.urbangoodzdelivery.com/api/v1/module"));
  request.headers.add("zoneId", "[1]");
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  print(responseBody);
}

