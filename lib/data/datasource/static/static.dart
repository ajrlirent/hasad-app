import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/core/constants/imageassets.dart';

import 'package:hasad/data/models/addentry.dart';
import 'package:hasad/data/models/attachmentmodel.dart';
import 'package:hasad/data/models/equipmenttypemodel.dart';
import 'package:hasad/data/models/onboardingmodel.dart';
import 'package:hasad/views/screens/home/demander_client/demanderhome.dart';
import 'package:hasad/views/screens/home/discover.dart';
import 'package:hasad/views/screens/home/provider/providerhome.dart';
import 'package:hasad/views/screens/notifications/notificationscreenprovider.dart';
import 'package:hasad/views/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

MyServices myServices = Get.find();
List<Onboardingmodel> onboardingList = [
  Onboardingmodel(
      title: 'onboardingtitle1',
      body: {0: "onboardingbody1", 1: "onboardingbody2", 2: "onboardingbody3"},
      image: AppImageAsset.onboardingOne),
  Onboardingmodel(
      title: 'onboardingtitle2',
      body: {0: "onboardingbody1", 1: "onboardingbody2", 2: "onboardingbody3"},
      image: AppImageAsset.onboardingTwo),
];
List<Widget> get pages {
  // Access sharedprefs after initialization
  final role = Get.find<MyServices>().sharedprefs.getString('role');

  // Define pages based on the user role
  return [
    (role == "provider_individual" || role == "provider_society")
        ? const Providerhome()
        : const Demanderhome(),
    (role == "provider_individual" || role == "provider_society")
        ? const NotificaitonScreenProvider()
        : const Discover(),
    const Settings(),
  ];
}

// List of pages
// List<Widget> pages = [
//   myServices.sharedprefs.getString("role") == "provider_individual" ||
//           myServices.sharedprefs.getString('role') == "provider_society"
//       ? const Providerhome()
//       : const Demanderhome(),
//   myServices.sharedprefs.getString("role") == "provider_individual" ||
//           myServices.sharedprefs.getString('role') == "provider_society"
//       ? const NotificaitonScreenProvider()
//       : const Discover(),
//   const Settings()
// ];

List<EquipmentTypeModel> typelist = [
  EquipmentTypeModel(
      id: 1,
      name: "equipmentCatname1",
      image: "assets/images/categories/cat1image.png"),
  EquipmentTypeModel(
      id: 2,
      name: "equipmentCatname2",
      image: "assets/images/categories/cat2image.png"),
];
// List<CategoriesModel> catlist = [
//   CategoriesModel(
//     id: 1,
//     typeId: 1,
//     name: "Machine de terrassement",
//     icon: AppImageAsset.cat1,
//   ),
//   CategoriesModel(
//     id: 2,
//     typeId: 1,
//     name: "Trancheuse et foreurs",
//     icon: AppImageAsset.cat2,
//   ),
//   CategoriesModel(
//     id: 3,
//     typeId: 1,
//     name: "Grue et sur camion",
//     icon: AppImageAsset.cat3,
//   ),
//   CategoriesModel(
//     id: 4,
//     name: "Camion à benne et citerne",
//     icon: AppImageAsset.cat4,
//   ),
//   CategoriesModel(
//     id: 5,
//     typeId: 1,
//     name: "Machine à béton",
//     icon: AppImageAsset.cat5,
//   ),
//   CategoriesModel(
//     id: 1,
//     typeId: 2,
//     name: " Coffrage en bois et métallique",
//     icon: AppImageAsset.cat5,
//   ),
//   CategoriesModel(
//     id: 2,
//     typeId: 2,
//     name: "Equipment de concrete",
//     icon: AppImageAsset.cat5,
//   ),
//   CategoriesModel(
//     id: 3,
//     typeId: 2,
//     name: "Générateurs et éclairage",
//     icon: AppImageAsset.cat5,
//   ),
//   CategoriesModel(
//     id: 4,
//     typeId: 2,
//     name: "Compactage et démolitions ",
//     icon: AppImageAsset.cat5,
//   ),
// ];

// List<ItemsModel> items = [
//   ItemsModel(
//       itemId: 1,
//       catId: 1,
//       name: "Micro pelle",
//       image: "assets/images/items/micropelle.png",
//       price: 22.00,
//       haveattachments: true),
//   ItemsModel(
//       itemId: 2,
//       catId: 1,
//       name: "Mini pelle sur chenilles",
//       image: "assets/images/items/mini.png",
//       price: 22.00,
//       haveattachments: true),
//   ItemsModel(
//       itemId: 3,
//       catId: 1,
//       name: "Pleteuse",
//       image: "assets/images/items/pleteuse.png",
//       price: 22.00,
//       haveattachments: false),
//   ItemsModel(
//       itemId: 1,
//       catId: 2,
//       name: "Decoupeuse",
//       image: "assets/images/items/decoupouse.png",
//       price: 22.00,
//       haveattachments: false),
//   ItemsModel(
//       itemId: 2,
//       catId: 2,
//       name: "Petit Trancheuse à conducteur marchant",
//       image: "assets/images/items/trancheuse.png",
//       price: 22.00),
//   ItemsModel(
//       itemId: 3,
//       catId: 2,
//       name: "Mini Trancheuse",
//       image: "assets/images/items/mini.png",
//       price: 22.00),
//   ItemsModel(
//       itemId: 1,
//       catId: 3,
//       name: "Grue sur camion de chargement",
//       image: "assets/images/items/gruecamion.png",
//       price: 22.00),
//   ItemsModel(
//       itemId: 2,
//       catId: 3,
//       name: "Grue sur châssis de chargement",
//       image: "assets/images/items/gruechassis.png",
//       price: 22.00),
//   ItemsModel(
//       itemId: 3,
//       catId: 3,
//       name: "Grue sur lourd de chargement",
//       image: "assets/images/items/gruelourd.png",
//       price: 22.00),
//   ItemsModel(
//       itemId: 1,
//       catId: 4,
//       name: "Mini Tombereau",
//       image: "assets/images/items/tombereau.png",
//       price: 22.00),
//   ItemsModel(
//       itemId: 2,
//       catId: 4,
//       name: "Camion à benne",
//       image: "assets/images/items/benne.png",
//       price: 22.00),
//   ItemsModel(
//       itemId: 3,
//       catId: 4,
//       name: "Camion à citerne",
//       image: "assets/images/items/citerne.png",
//       price: 22.00),
// ];

List<AddEntry> addEntry = [
  AddEntry(
      "addequipmentcat1",
      [
        AddEntry("addequipmentsubcat1"),
        AddEntry("addequipmentsubcat2"),
        AddEntry("addequipmentsubcat3"),
        AddEntry("addequipmentsubcat4"),
        AddEntry("addequipmentsubcat5"),
      ],
      AppImageAsset.constructionIcon),
  AddEntry(
      "addequipmentcat2",
      [
        AddEntry("addequipmentsubcat6"),
        AddEntry("addequipmentsubcat6"),
      ],
      AppImageAsset.vehiculesIcon),
  AddEntry(
      "addequipmentcat3",
      [
        AddEntry("addequipmentsubcat6"),
        AddEntry("addequipmentsubcat6"),
      ],
      AppImageAsset.vehiculesIcon),
];

List<AttachmentModel> attachments = [
  AttachmentModel(
      attachmentname: "Charrue",
      attachmentimage: "assets/images/attachments/trenchuse.png"),
  AttachmentModel(
      attachmentname: "Herse rotative",
      attachmentimage: "assets/images/attachments/Marteaux.png"),
  AttachmentModel(
      attachmentname: "Tarière",
      attachmentimage: "assets/images/attachments/Tarière.png"),
  AttachmentModel(
      attachmentname: "Godet agricole",
      attachmentimage: "assets/images/attachments/Godet2dents.png"),
  AttachmentModel(
      attachmentname: "Fourche à balles",
      attachmentimage: "assets/images/attachments/5dents.png"),
];

List<AttachmentModel> attachmentsBottomsheet = [
  AttachmentModel(
      attachmentname: "Charrue",
      attachmentimage: "assets/images/attachments/trenchuse.png"),
  AttachmentModel(
      attachmentname: "Herse rotative",
      attachmentimage: "assets/images/attachments/Marteaux.png"),
  AttachmentModel(
      attachmentname: "Tarière",
      attachmentimage: "assets/images/attachments/Tarière.png"),
  AttachmentModel(
      attachmentname: "Godet agricole",
      attachmentimage: "assets/images/attachments/Godet2dents.png"),
  AttachmentModel(
      attachmentname: "Fourche à balles",
      attachmentimage: "assets/images/attachments/5dents.png"),
  AttachmentModel(
      attachmentname: "Gyrobroyeur",
      attachmentimage: "assets/images/attachments/Marteaux.png"),
];
