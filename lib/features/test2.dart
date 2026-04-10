import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:warna_app/router/router_names.dart';

class TestWithData extends StatefulWidget {

final String userName;
 
  const TestWithData({super.key, required this.userName });

  @override
  State<TestWithData> createState() => _TestWithDataState();
}

class _TestWithDataState extends State<TestWithData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test With Data")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("This is a test page with data")),
          Center(child: Text("User Name: ${widget.userName}")),
          ElevatedButton(onPressed: (){
            GoRouter.of(context).goNamed(RouterNames.testPage);
          }, child: const Text("Test Page One")),         
        ],
      ),
    );
  }
}