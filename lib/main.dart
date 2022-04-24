import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:machinetest/addview.dart';
import 'package:machinetest/links.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Links>(
        init: Links(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey,
                title: const Text('Links'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        controller.loadOnStart();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          fixedSize: Size(120, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          textStyle: const TextStyle(color: Colors.white)),
                      child: Text(controller.status),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AddView();
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          fixedSize: Size(80, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          textStyle: const TextStyle(color: Colors.white)),
                      child: const Icon(CupertinoIcons.add),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              body: Center(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: controller.status ==
                      'START', // Restricting drag and drop only on START
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      direction: controller.status ==
                              'START' //restricting swipe only on START
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      key: Key(controller.entries[index].url!),
                      onDismissed: (direction) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '${controller.entries[index].url} dismissed')));
                        controller.remove(index);
                      },
                      child: ListTile(
                        key: ValueKey(controller.entries[index].url!),
                        title: Text(controller
                            .getShortUrl(controller.entries[index].url!)),
                        subtitle: Text(controller.entries[index].url!),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              primary: controller.entries[index].status == null
                                  ? Colors.grey
                                  : controller.entries[index].status == 'DONE'
                                      ? Colors.green[500]
                                      : Colors.red,
                              minimumSize: Size.zero,
                              maximumSize: const Size(70, 100),
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              textStyle: const TextStyle(color: Colors.white)),
                          child: controller.entries[index].status == null
                              ? const Icon(Icons.menu)
                              : const Text('DONE'),
                        ),
                        leading: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              minimumSize: Size.zero,
                              maximumSize: const Size(100, 100),
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10)),
                              textStyle: const TextStyle(color: Colors.black)),
                          child: Image.network(
                            controller.entries[index].favicon ?? '',
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(CupertinoIcons.question),
                          ),
                        ),
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex = newIndex - 1;
                      }
                      final element = controller.entries.removeAt(oldIndex);
                      controller.entries.insert(newIndex, element);
                    });
                  },
                ),
              ));
        });
  }
}
