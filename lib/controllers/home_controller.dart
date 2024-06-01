import 'package:dio/dio.dart';
import 'package:volunteer_app/services/network.dart';
import '../services/api.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/models/event.dart';

class HomeController extends GetxController {
  NetworkService ns = NetworkService();
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  var events = <AllEventDTO>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs; // Track if loading more data
  var serverAvailable = true.obs;
  var currentPage = 1.obs;

  void fetchData({int page = 1}) async {
    if (page == 1) {
      isLoading.value = true;
    } else {
      if (isLoadingMore.value) return; // Prevent multiple triggers
      isLoadingMore.value = true;
    }

    try {
      final Uri uri = Uri.https(apiUrl, allEvents, {'page': '$page'});
      final response = await ns.getRequest(uri);
      if (response.statusCode == 200) {
        final List<dynamic> jsonDataList = response.data;
        final List<AllEventDTO> eventData = jsonDataList
            .map<AllEventDTO>((json) => AllEventDTO.fromJson(json))
            .toList();
        if (page == 1) {
          events.assignAll(eventData);
        } else {
          events.addAll(eventData);
        }
        serverAvailable.value = true;
      } else if (response.statusCode == 404) {
        serverAvailable.value = false;
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } on DioException catch (e) {
      serverAvailable.value = false;
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      currentPage.value = page;
    }
  }
}