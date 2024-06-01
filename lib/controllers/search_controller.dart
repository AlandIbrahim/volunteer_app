import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/models/event.dart';
import 'package:volunteer_app/services/api.dart';
import 'package:volunteer_app/services/network.dart';

class SearchPageController extends GetxController {
  NetworkService ns = NetworkService();
  var searchController = TextEditingController().obs;
  var events = <AllEventDTO>[].obs;

  // to change the text of the controller
  void changeText(String newText, Rx<TextEditingController> controller) {
    final selection = controller.value.selection;

    // Set the new text
    controller.value.text = newText;

    // Restore the selection
    controller.value.selection = selection;
  }

  var isLoading = false.obs;
  var isLoadingMore = false.obs; // Track if loading more data
  var serverAvailable = true.obs;
  var currentPage = 1.obs;

  void clearEvents() {
    events.value.clear();
  }

  void fetchData({int page = 1}) async {
    if (page == 1) {
      isLoading.value = true;
    } else {
      if (isLoadingMore.value) return; // Prevent multiple triggers
      isLoadingMore.value = true;
    }

    try {
      Uri uri = Uri.https(apiUrl, 'event/search',
          {'search': searchController.value.text, 'page': '$page'});
      var response = await ns.getRequest(uri);
      if (response.statusCode == 200) {
        var jsonDataList = response.data;
        List<AllEventDTO> eventData = jsonDataList['events']
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
