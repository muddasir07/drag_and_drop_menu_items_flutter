import 'package:drag_and_drop/utils/chechout.dart';
import 'package:drag_and_drop/utils/menuitem.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MyAppState();
}

class _MyAppState extends State<MainApp> with TickerProviderStateMixin {
  double initialBottomSheetSize = 0.1;
  List<MenuItem>? listMenuItem;
  double draggableBottomSheetHeight = 65.0;
  late TabController tabController;
  PageController pageController = PageController(initialPage: 0);
  double cartTotal = 0.0;


  @override
  void initState() {
    super.initState();
    createData();
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        pageController.animateToPage(tabController.index,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('McDonald\'s Menu'),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                customTabBar(),
                tabBarPages()
              ],
            ),
            checkoutBottomSheet(),
          ],
        ),
      ),
    );
  }

  void createData() {
    listMenuItem = [];
    for (int i = 0; i < 8; i++) {
      var menuItem = MenuItem();
      menuItem.isSuccessful = false;
      menuItem.price = 31.00;
      listMenuItem!.add(menuItem);
    }
  }

  Widget customTabBar() {
    return TabBar(
      isScrollable: true,
      indicatorColor: Colors.red.shade700,
      indicatorWeight: 2,
      unselectedLabelColor: Colors.black54,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.red.shade700,
      tabs: const [
        Tab(text: "Burger"),
        Tab(text: "Chicken & Sandwiches"),
        Tab(text: "Combo Meals"),
      ],
      controller: tabController,
    );
  }

  Widget checkoutBottomSheet() {
    return DraggableScrollableSheet(
      builder: (context, ScrollController controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.grey)
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: ListView(
            controller: controller,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.black,
                    ),
                    width: 100,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Checkout Total",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Rs. $cartTotal",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: <Widget>[
                          DragTarget(
                            builder: (context, candidateData, rejectedData) {
                              return !listMenuItem![index].isSuccessful
                                  ? Container(
                                      height: 100,
                                      width: 100,
                                      margin: const EdgeInsets.all(8),
                                      color: Colors.grey.shade100,
                                    )
                                  : Container(
                                      height: 100,
                                      width: 100,
                                      margin: const EdgeInsets.all(8),
                                      child: const Image(
                                        image:
                                            AssetImage("images/burger2.jpeg"),
                                      ),
                                    );
                            },
                            onWillAccept: (data) {
                              return true;
                            },
                            onAccept: (String data) {
                              setState(() {
                                listMenuItem![int.parse(data)].isSuccessful =
                                    true;
                                updateCartTotal();
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Visibility(
                              visible: listMenuItem![index].isSuccessful,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    listMenuItem![index].isSuccessful = false;
                                    updateCartTotal();
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(right: 4, top: 4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: listMenuItem!.length,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                      cartItems: listMenuItem!
                                          .where((item) => item.isSuccessful)
                                          .toList(),
                                      totalPrice: cartTotal,
                                    )));
                      },
                      textColor: Colors.white,
                      color: Colors.red,
                      child: const Text("Checkout"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      initialChildSize: initialBottomSheetSize,
      minChildSize: initialBottomSheetSize,
      maxChildSize: 0.48,
    );
  }

  Widget tabBarPages() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (position) {
          tabController.index = position;
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          return Container(
            margin: EdgeInsets.only(bottom: draggableBottomSheetHeight),
            child: listOfTabData(),
          );
        },
        itemCount: 3,
      ),
    );
  }

  Widget listOfTabData() {
    return GridView.builder(
      itemCount: listMenuItem!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return Draggable(
          feedback: const SizedBox(
            height: 100,
            width: 100,
            child: Image(
              image: AssetImage("images/burger2.jpeg"),
            ),
          ),
          data: "$index",
          onDragStarted: () {
            setState(() {
              initialBottomSheetSize = .4;
            });
          },
          onDragEnd: (details) {
            setState(() {
              initialBottomSheetSize = .1;
            });
          },
          onDraggableCanceled: (v, offset) {
            setState(() {
              initialBottomSheetSize = .1;
            });
          },
          child: gridItem(index),
        );
      },
    );
  }

  Widget gridItem(int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Image(
            image: AssetImage("images/burger2.jpeg"),
            height: 70,
          ),
          const SizedBox(height: 6),
          const Text("Big Mac",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(height: 4),
          const Text(
            "540 Cal.",
            style: TextStyle(color: Colors.black38, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            "From",
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Rs. ${listMenuItem![index].price}",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void updateCartTotal() {
    double total = 0.0;
    for (var menuItem in listMenuItem!) {
      if (menuItem.isSuccessful) {
        total += menuItem.price;
      }
    }
    setState(() {
      cartTotal = total;
    });
  }
}
