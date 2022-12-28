import 'package:flutter/material.dart';


class FavoritesFragmentScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
              "Wish List")
      ),
      body: Center(
        child: Text(
            "Go back to shopping!!"
        ),
      ),
    );
  }
}
