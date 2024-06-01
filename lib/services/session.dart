import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:volunteer_app/services/storage.dart';

class Session {
  static Map<String, String> headers = {"content-type": "text/json"};
  static Map<String, String> cookies = {};
  static final SharedPreferencesService _prefsService =
      SharedPreferencesService();

  static Future<http.Response> get(Uri url) async {
    http.Response response = await http.get(url, headers: headers);
    print(headers);
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return response;
      case 401:
        print('unAuthentication');
        throw UnauthorizedException();
      case 403:
        throw const HttpException('forbidden');
      default:
        throw Exception();
    }
  }

  static Future<http.Response> post(Uri url, dynamic data) async {
    http.Response response =
        await http.post(url, body: jsonEncode(data), headers: headers);
    print(response.headers);
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        break;
      case 401:
        throw UnauthorizedException();
      case 403:
        throw const HttpException('forbidden');
      default:
        throw Exception();
    }

    return response;
  }

  static void updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');
        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['Cookie'] = _generateCookieHeader();
      storeCookie(headers['Cookie']!);
    }
  }

  static void storeCookie(String cookie) async {
    await _prefsService.save('cookie', cookie);
    print('Cookie');
    // print(cookie);
  }

  static void _setCookie(String rawCookie) {
    if (rawCookie.isNotEmpty) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        cookies[key] = value;
      }
    }
  }

  static String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";
      cookie += "$key=${cookies[key]}";
    }

    return cookie;
  }

  static Future<void> loadCookie() async {
    String? savedCookie;
    if (cookies.length > 0) {
      headers['Cookie'] = _generateCookieHeader();
      return;
    }
    savedCookie = await _prefsService.read('cookie');
    print(savedCookie);
    if (savedCookie != null) {
      print('afarin');

      var setCookies = savedCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['Cookie'] = _generateCookieHeader();
    }
  }
}
