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
  static int? _uid;
  static bool get isOrg=>_isOrg??false;
  static int get uid=>_uid??0;
  NetworkService() {
    _dio = Dio();
    _cookieJar = CookieJar();
    _dio?.interceptors.add(CookieManager(_cookieJar!));
  }
  static Future initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('isOrg')&&prefs.containsKey('uid')){
        _isOrg = prefs.getBool('isOrg');
        _uid = prefs.getInt('uid');
      }
      else{
        var response=(await NetworkService().getRequest(Uri.https(apiUrl, 'user/role'))).data;
        _isOrg=response[0]=='o';
        _uid=int.parse(response.substring(1));
        prefs.setBool('isOrg', _isOrg!);
        prefs.setInt('uid', _uid!);
      }
  }
  static Future setUser(int uid,bool isOrg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isOrg = isOrg;
    _uid = uid;
    prefs.setBool('isOrg', isOrg);
    prefs.setInt('uid', uid);
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
