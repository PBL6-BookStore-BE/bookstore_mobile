import 'package:flutter/material.dart';

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height:16,),

          //search bar widget
          showSearchBarWidget(),

          //popular trending items
          const SizedBox(height:26,),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text("Trending",
            style: TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize:24,
            ),),
          ),

          const SizedBox(height:24,),
          //new items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text("New Books",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize:24,
              ),),
          )
        ],
      )

    );
  }
  Widget showSearchBarWidget()
  {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal:18),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: ()
                  {

                  },
                icon: const Icon(
                    Icons.search,
                  color: Colors.purpleAccent
                )

              ),
              hintText: "Search best books here ...",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              suffixIcon: IconButton(
                onPressed: (){},
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.purpleAccent,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.purple,
                  )

              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.purpleAccent,
                  )

              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal:16,
                vertical: 8,
              ),
            )
          )
    )
    ;
  }
}
