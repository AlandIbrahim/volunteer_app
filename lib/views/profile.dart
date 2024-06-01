import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/auth_controller.dart';
import 'package:volunteer_app/controllers/image_controller.dart';
import 'package:volunteer_app/services/api.dart';
import 'package:volunteer_app/services/network.dart';
import 'package:volunteer_app/views/widgets/navigtion_bar.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  NetworkService ns = NetworkService();
  final ImageController imageController = Get.put(ImageController());

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            ns.clearCookies();
            Get.offNamed('/login');
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      bottomNavigationBar: MyNavigationBar(),
      body: VolunteerProfile(
        authController: authController,
        imageController: imageController,
      ),
    );
  }
}

class VolunteerProfile extends StatelessWidget {
  const VolunteerProfile({
    super.key,
    required this.authController,
    required this.imageController,
  });

  final AuthController authController;
  final ImageController imageController;

  @override
  Widget build(BuildContext context) {
    bool isNetworkImageLoaded = true;
    return Obx(() {
      switch (authController.isLoading.value) {
        case true:
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        case false:
          var profile = authController.profile.value;
          return ListView(
            children: [
              Container(
                color: Colors.teal,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              Uri.https(apiUrl, 'user/pfp/${profile.uid}')
                                  .toString(),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                isNetworkImageLoaded = false;
                                return Image.asset(
                                  'assets/images/user.png',
                                  height: 200,
                                  width: 200,
                                );
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await imageController.pickImage();
                              if (imageController.image != null) {
                                if (isNetworkImageLoaded) {
                                  imageController.uploadImagePatch();
                                } else {
                                  imageController.uploadImagePost();
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                            ),
                            iconSize: 10,
                            style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                            ),
                          )
                        ],
                      ),
                      Text(
                        profile.fullName(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '@${profile.userName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      if(authController.isOrg.value)
                      Text(profile.isGov!? 'Governmental organization': 'Non-governmental organization', style: const TextStyle(color: Colors.white, fontSize: 15,),)
                      else Column(children: [
                      Text(
                        'Year of birth: ${profile.birthDate}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'gender: ${profile.gender! ? 'Female' : 'Male'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'City: ${profile.city!.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      ],),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(
                      width: 50,
                    ),
                    Text('Edit profile'),
                  ],
                ),
              ),
            ],
          );
      }
    });
  }
}
