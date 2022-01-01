import 'package:flutter/material.dart';
import 'package:flutter_dua/menu/items.dart';
import 'package:flutter_dua/menu/menu_item.dart';
import 'package:flutter_dua/provider/restaurant_provider.dart';
import 'package:flutter_dua/ui/setting/setting_page.dart';
import 'package:provider/provider.dart';

import '../favorite/favorite_page.dart';
import '../home/restaurant_item.dart';
import '../search/search.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text("Restaurant"),
          actions: <Widget>[
            PopupMenuButton<MenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) =>
                  [...Items.items.map(buildItem).toList()],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, SearchPage.route),
                      child: AbsorbPointer(
                        child: TextFormField(
                          maxLines: 1,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Search....",
                            labelText: "Search Restaurant",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Restaurants",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Recommendation restaurant for you!",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<HomeProvider>(
                        builder: (context, state, _) {
                          if (state.state == ResultState.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state.state == ResultState.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.result!.restaurants!.length,
                              itemBuilder: (context, index) {
                                return RestaurantItem(
                                  restaurant: state.result!.restaurants![index],
                                );
                              },
                            );
                          } else if (state.state == ResultState.noData) {
                            return Center(
                              child: Text(state.message.toString()),
                            );
                          } else {
                            return Center(
                              child: Container(
                                child: Wrap(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 550,
                                        width: 500,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/noInternet.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem(
        value: item,
        child: Row(
          children: <Widget>[
            Icon(
              item.icon,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(item.text),
          ],
        ),
      );

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case Items.itemSetting:
        Navigator.pushNamed(context, SettingPage.route);
        break;

      case Items.itemFavorite:
        Navigator.pushNamed(context, FavoritePage.route);
        break;
    }
  }
}
