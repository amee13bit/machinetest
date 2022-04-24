import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machinetest/links.dart';

class AddView extends StatelessWidget {
  AddView({Key? key}) : super(key: key);
  final TextEditingController dialogController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new Url'),
      content: TextField(controller: dialogController),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.find<Links>().insert(dialogController.text.toString());
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.grey,
              minimumSize: Size.zero,
              maximumSize: const Size(100, 100),
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              textStyle: const TextStyle(color: Colors.white)),
          child: const Text('Add'),
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                minimumSize: Size.zero,
                maximumSize: const Size(100, 100),
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                textStyle: const TextStyle(color: Colors.white)),
            child: const Text('Cancel')),
      ],
    );
  }
}
