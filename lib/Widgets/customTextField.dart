import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecure = true;
  bool? isEnabled = true;
  final TextInputType? textType;

  CustomTextField(
      {Key? key,
      this.controller,
      this.data,
      this.hintText,
      this.isObsecure,
      this.textType,
      this.isEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        keyboardType: textType,
        obscureText: isObsecure!,
        cursorColor: Theme.of(context).primaryColor,
        enabled: isEnabled!,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Theme.of(context).hintColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
