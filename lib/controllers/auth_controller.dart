import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:volunteer_app/models/volunteer.dart';
import 'package:volunteer_app/services/api.dart';
import 'package:dio/dio.dart' as dio;
import 'package:volunteer_app/services/city.dart';
import 'package:volunteer_app/services/network.dart';

class AuthController extends GetxController {
  bool loggedIn = false;
  dio.Dio dioInstance = dio.Dio();
  NetworkService ns = NetworkService();
  var isLoading = false.obs;
  var isOrg = false.obs;
  var profile = Profile(
    userName: '',
    firstName: '',
    lastName: '',
    birthDate: '',
    gender: false,
    city: City.sulaymaniyah,
    uid: '',
  ).obs;
  // var profilePicture = FileImage(File.fromUri(Uri.https(apiUrl, 'user/pfp')));

  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit

    getUser();
  }

  void getUser() async {
    isLoading.value = true;
    bool cookieExist = await ns.areCookiesStored();
    if (cookieExist) {
      try {
        var response = await ns.getRequest(Uri.https(apiUrl, user));
        var jsonData = response.data;
        isOrg.value = jsonData['type']=='o';
        profile.value = Profile.fromJson(jsonData);
        isLoading.value = false;
      } on UnauthorizedException {
        isLoading.value = false;
        Get.offNamed('/login');
      } on dio.DioException catch (e) {
        if (e.message!.contains('401')) {
          isLoading.value = false;
          Get.offNamed('/login');
        }
      }
    } else {
      print('naxer nya');
      isLoading.value = false;
      if (Get.currentRoute != '/register') {
        Get.offNamed('/login');
      }
    }
  }

  void logIn() {
    loggedIn = true;
    Get.offNamed('/home');
  }

  void signUp() {
    loggedIn = true;
    Get.offNamed('/home');
  }
}
