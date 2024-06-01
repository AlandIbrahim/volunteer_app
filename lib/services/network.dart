// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:volunteer_app/services/api.dart';


class NetworkService {
  Dio? _dio;
  CookieJar? _cookieJar;
  static const String _cookieKey = 'cookies';
  static bool? _isOrg;
  static bool get isOrg=>_isOrg??false;
  NetworkService() {
    _dio = Dio();
    _cookieJar = CookieJar();
    _dio?.interceptors.add(CookieManager(_cookieJar!));
  }
  static Future initOrg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('isOrg'))
        _isOrg = prefs.getBool('isOrg');
      else{
        _isOrg=(await NetworkService().getRequest(Uri.https(apiUrl, 'user/role'))).data=='o';
        await prefs.setBool('isOrg', _isOrg!);
      }
  }
  static Future setOrg(bool isOrg) async {
    _isOrg = isOrg;
    await (await SharedPreferences.getInstance()).setBool('isOrg', isOrg);
  }
  // Save cookies to SharedPreferences
  Future<void> saveCookies(Uri uri) async {
    final cookies = await _cookieJar?.loadForRequest(uri);
    final List<String> cookieList =
        cookies!.map((cookie) => cookie.toString()).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_cookieKey, cookieList);
  }

  // Load cookies from SharedPreferences
  Future<void> loadCookies(Uri uri) async {
    final prefs = await SharedPreferences.getInstance();
    final cookieList = prefs.getStringList(_cookieKey) ?? [];
    final cookies = cookieList
        .map((cookieString) => Cookie.fromSetCookieValue(cookieString))
        .toList();
    _cookieJar?.saveFromResponse(uri, cookies);
  }

  // Clear all cookies
  Future<void> clearCookies() async {
    _cookieJar?.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cookieKey);
    print('cleared all cookies');
  }

  // Check if cookies are stored
  Future<bool> areCookiesStored() async {
    return await (SharedPreferences.getInstance()
        .then((value) => value.containsKey(_cookieKey)));
  }

  // GET request
  Future<Response> getRequest(Uri uri) async {
    String url = uri.toString();
    // print stack trace for debugging
    await loadCookies(uri);
    final response = await _dio?.get(url);
    print(response!.statusCode);
    await saveCookies(uri);
    return response;
  }

  // POST request
  Future<Response> postRequest(Uri uri, Map<String, dynamic> data) async {
    String url = uri.toString();
    await loadCookies(uri);
    final response = await _dio?.post(url, data: data);
    print(response!.statusCode);
    await saveCookies(uri);
    return response;
  }
  Future<Response> patchRequest(Uri uri, Map<String, dynamic> data) async {
    String url = uri.toString();
    await loadCookies(uri);
    final response = await _dio?.patch(url, data: data);
    print(response!.statusCode);
    await saveCookies(uri);
    return response;
  }
  Future<Response> deleteRequest(Uri uri) async {
    String url = uri.toString();
    await loadCookies(uri);
    final response = await _dio?.delete(url);
    print(response!.statusCode);
    await saveCookies(uri);
    return response;
  }

  // PATCH request for image upload
  Future<Response> patchImageRequest(Uri uri, File imageFile) async {
    String url = uri.toString();
    await loadCookies(uri);

    FormData formData = FormData.fromMap({
      'img':
          await MultipartFile.fromFile(imageFile.path, filename: 'upload.jpg'),
    });

    final response = await _dio?.patch(url, data: formData);
    await saveCookies(uri);
    return response!;
  }

  // POST request for image upload
  Future<Response> postImageRequest(Uri uri, File imageFile) async {
    String url = uri.toString();
    await loadCookies(uri);

    FormData formData = FormData.fromMap({
      'img':
          await MultipartFile.fromFile(imageFile.path, filename: 'upload.jpg'),
    });

    final response = await _dio?.post(url, data: formData);
    await saveCookies(uri);
    return response!;
  }
}
