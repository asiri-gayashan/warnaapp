import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Page 1")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("This is a test page")),
          ElevatedButton(
            onPressed: () { 


// --------------------------------------------------------------------path parameter data  passing example with push-------------------------------------------------

              String name = "Asiri Gayashan";
              GoRouter.of(context).push('/testwithdata/$name');
            },
            child: const Text("Go to Login"),
          ),
          ElevatedButton(
            onPressed: () {
              //--------------------------------------------------------extra data passing example-------------------------------------------------
              //GoRouter.of(context).go('/testwithdata/Ponnaya');
              //GoRouter.of(context).go('/testwithdata/', extra: {
              //   "name": "Ponnaya",
              //   "age": "30"
              // });

              // --------------------------------------------------------------------path parameter data  passing example-------------------------------------------------
              String name = "Asiri Gayashan";
              GoRouter.of(context).go('/testwithdata/$name');
            },
            child: const Text("Test With Data"),
          ),
        ],
      ),
    );
  }
}
