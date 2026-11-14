import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/views/screens/add/addCatItems.dart';
import 'package:hasad/views/screens/add/addCategoriesView.dart';
import 'package:hasad/views/screens/add/addequipment.dart';
import 'package:hasad/views/screens/add/addsuccess.dart';
import 'package:hasad/views/screens/auth/login_screen.dart';
import 'package:hasad/views/screens/auth/signup.dart';
import 'package:hasad/views/screens/auth/verifyotp.dart';
import 'package:hasad/views/screens/home/command.dart';
import 'package:hasad/views/screens/home/demande/demande.dart';
import 'package:hasad/views/screens/home/demande/searching.dart';
import 'package:hasad/views/screens/home/demander_client/demanderhome.dart';
import 'package:hasad/views/screens/home/demander_client/demanderhome2.dart';
import 'package:hasad/views/screens/home/discover.dart';
import 'package:hasad/views/screens/home/homepage.dart';
import 'package:hasad/views/screens/home/items.dart';
import 'package:hasad/views/screens/home/provider/providerhome.dart';
import 'package:hasad/views/screens/home/provider/providerhome2.dart';
// import 'package:hasad/views/screens/notifications/notificationscreenprovider.dart';
import 'package:hasad/views/screens/notifications/notificationsdemander.dart';
import 'package:hasad/views/screens/notifications/realNotificationdemander.dart';
import 'package:hasad/views/screens/onboarding/onboarding.dart';
import 'package:hasad/views/screens/settings/editprofile.dart';
import 'package:hasad/views/screens/splashscreen/splashscreen.dart';
import 'package:hasad/views/screens/notifications/notificationscreenprovider.dart';

//import 'package:hasad/views/screens/onboarding/onboarding.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> routes = [
  //Initial route : we goona use a middleware to go to the onboarding page or home page on auth page based
  // on the first visit and if the user is logged in or not
  //auth pages
  GetPage(name: "/", page: () => const Splashscreen()),
  GetPage(
    name: AppRoutesNames.onBoarding,
    page: () => const OnboardingPage(),
  ),
  GetPage(name: AppRoutesNames.login, page: () => const Login()),
  GetPage(name: AppRoutesNames.signup, page: () => const Signup()),
  GetPage(name: AppRoutesNames.verifyOtp, page: () => const Verifyotp()),
  //pages
  GetPage(name: AppRoutesNames.homepage, page: () => const Homepage()),
  GetPage(name: AppRoutesNames.discover, page: () => const Discover()),
  GetPage(name: AppRoutesNames.categorieItems, page: () => const CatItems()),
  GetPage(name: AppRoutesNames.addCategorieItems, page: () => AddCatItems()),
  GetPage(
      name: AppRoutesNames.addCategorieView,
      page: () => const AddCategoriesView()),
  GetPage(name: AppRoutesNames.addequipment, page: () => Addequipment()),
  GetPage(name: AppRoutesNames.addSuccess, page: () => const AddSuccess()),

  GetPage(
      name: AppRoutesNames.commandDetails, page: () => const CommandDetails()),
  //demand
  GetPage(name: AppRoutesNames.demande, page: () => DemandeItem()),
  GetPage(name: AppRoutesNames.demanderhome, page: () => const Demanderhome()),
  GetPage(
      name: AppRoutesNames.demanderhome2, page: () => const Demanderhome2()),
  //provider
  GetPage(
      name: AppRoutesNames.providerhome2, page: () => const Providerhome2()),
  GetPage(name: AppRoutesNames.providerhome, page: () => const Providerhome()),
  GetPage(
      name: AppRoutesNames.demandeSearching,
      page: () => const SearchingDemande()),

  GetPage(name: AppRoutesNames.editprofile, page: () => const Editprofile()),

  GetPage(
    name: AppRoutesNames.notificationsScreenProvider,
    page: () => const NotificaitonScreenProvider(),
  ),

  GetPage(
    name: AppRoutesNames.notificationsScreenDemander,
    page: () => const NotificaitonScreenDemander(),
  ),
  GetPage(
    name: AppRoutesNames.realNotificaitonScreenDemander,
    page: () => const RealNotificaitonScreenDemander(),
  ),
];
