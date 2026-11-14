import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/controller/add/addequipment_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomTextfield extends StatefulWidget {
  final Color bordercolor;
  final double radius;
  final String hinttext, icon;
  final String? Function(String?)? isvalid;
  final TextEditingController mycontroller;
  final void Function()? oneditcomplete;
  final bool isPassword;

  const CustomTextfield(
    this.oneditcomplete, {
    super.key,
    this.bordercolor = AppColor.backgroundColor,
    this.radius = 14,
    required this.icon,
    required this.hinttext,
    required this.isvalid,
    required this.mycontroller,
    this.isPassword = false,
  });

  @override
  _CustomTextfieldState createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: widget.oneditcomplete,
      controller: widget.mycontroller,
      validator: widget.isvalid,
      obscureText: widget.isPassword ? _isObscured : false,
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints.tight(const Size(52, 30)),
        prefixIcon: widget.icon == ""
            ? const SizedBox()
            : SvgPicture.asset(widget.icon),
        hintStyle: const TextStyle(color: AppColor.secondaryColor),
        hintText: widget.hinttext,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: const BorderSide(color: AppColor.backgroundColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.bordercolor),
          gapPadding: 20,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.backgroundColor,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    super.key,
    required this.controller,
  });

  final AddequipmentControllerImp controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 400,
      child: Column(
        children: [
          CustomTextfield(
            () {},
            icon: "",
            hinttext: "Marque",
            isvalid: (va) {
              return null;
            },
            mycontroller: controller.marque,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomTextfield(
                  () {},
                  icon: "",
                  hinttext: "Model",
                  isvalid: (va) {
                    return null;
                  },
                  mycontroller: controller.model,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: CustomTextfield(
                  () {},
                  icon: "",
                  hinttext: "Annee",
                  isvalid: (va) {
                    return null;
                  },
                  mycontroller: controller.annee,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
