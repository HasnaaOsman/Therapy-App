import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';

class UserField extends StatefulWidget {
  const UserField({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.text,
    required this.icon,
    required this.x,
  });
  final String hinttext;
  final TextEditingController mycontroller;
  final String text;
  final Icon icon;
  final TextInputType x;

  @override
  State<UserField> createState() => _UserFieldState();
}

class _UserFieldState extends State<UserField> {
  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: formstate,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.text, style: AppWidget.TextFieldStyle()),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: widget.mycontroller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Empty field';
              }
              if (value.length > 14) {
                return " Not valid , no more than 14 char";
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: widget.icon,
              hintText: widget.hinttext,
              hintStyle: AppWidget.LightTextFieldStyle(),
              fillColor: AppColor.white,
              filled: true,
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.black,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.lightGrey),
                  borderRadius: BorderRadius.circular(20)),
            ),
            keyboardType: widget.x,
          )
        ],
      ),
    );
  }
}
