import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputField(
      {required this.controller, required this.onSend, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: onSend,
                icon: Icon(
                  Icons.send,
                  color: AppColor.blue,
                ),
              ),
              hintText: "Type a message...",
              hintStyle: AppWidget.LightTextFieldStyle(),
              fillColor: AppColor.white,
              filled: true,
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
            maxLines: null,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(color: AppColor.black),
          )),

          // IconButton(
          //   icon: Icon(Icons.send),
          //   onPressed: onSend,
          // ),
        ],
      ),
    );
  }
}
