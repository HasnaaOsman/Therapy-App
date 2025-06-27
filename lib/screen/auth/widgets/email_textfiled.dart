import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';

class Textformfeild extends StatefulWidget {
  const Textformfeild({
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
  State<Textformfeild> createState() => _TextformfeildState();
}

class _TextformfeildState extends State<Textformfeild> {
  String? email;
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
            onSaved: (val) {
              email = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Empty Field';
              } else if (!(value.contains('@'))) {
                return 'Enter valid Email , which contains @';
              }
              final regex = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
              if (!regex.hasMatch(value)) {
                return 'Enter a valid email address';
              } else {
                return null;
              }
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
