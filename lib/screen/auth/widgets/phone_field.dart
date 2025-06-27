import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
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
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  String selectedCountryCode = '+20';
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
              const String phonePattern = r'^(?:[1-9])?[0-9]{11}$';
              final regExp = RegExp(phonePattern);
              if (value == null || value.isEmpty) {
                return "Enter your phone number";
              } else if (!regExp.hasMatch(value)) {
                return "Enter a correct number";
              }

              return null;
            },
            maxLength: 11,
            decoration: InputDecoration(
              prefixIcon: Container(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CountryCodePicker(
                      textStyle: TextStyle(color: Colors.black),
                      backgroundColor: Colors.white,
                      searchDecoration: InputDecoration(
                        hintText: "Search for a country",
                        hintStyle: AppWidget.LightTextFieldStyle(),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.black,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lightGrey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      dialogSize: const Size(500, 700),
                      closeIcon:
                          const Icon(Icons.close_sharp, color: Colors.red),
                      boxDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      initialSelection: 'EG',
                      favorite: const ['EG', 'SA', 'AE'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      onChanged: (CountryCode countryCode) {
                        setState(() {
                          selectedCountryCode = countryCode.dialCode!;
                        });
                      },
                    ),
                    Container(
                      color: Colors.black,
                      height: 25,
                      width: 1,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            keyboardType: widget.x,
          )
        ],
      ),
    );
  }
}
