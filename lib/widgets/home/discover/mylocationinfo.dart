import 'package:hasad/core/constants/color.dart';
import 'package:hasad/views/screens/home/location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationDropDownBtn extends StatefulWidget {
  const LocationDropDownBtn({
    super.key,
  });

  @override
  State<LocationDropDownBtn> createState() => _LocationDropDownBtnState();
}

class _LocationDropDownBtnState extends State<LocationDropDownBtn> {
  static const String _prefsKey = 'selected_location';

  String _location = kDefaultLocation;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && saved.isNotEmpty && mounted) {
      setState(() => _location = saved);
    }
  }

  Future<void> _openPicker() async {
    final picked = await Get.to<String>(() => const LocationPickerScreen());
    if (picked == null || picked.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, picked);
    if (mounted) setState(() => _location = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 23, right: Get.width * 0.15),
      child: InkWell(
        onTap: _openPicker,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.location_on,
                  size: 18, color: AppColor.backgroundColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: "sans-serif",
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down,
                  size: 22, color: AppColor.backgroundColor),
            ],
          ),
        ),
      ),
    );
  }
}

class MyLocationtext extends StatelessWidget {
  const MyLocationtext({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Text(
        "mylocationtext".tr,
        style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "sans-serif",
            fontSize: 12,
            color: AppColor.secondaryColor),
      ),
    );
  }
}
