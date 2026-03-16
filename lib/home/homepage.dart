import 'dart:async';
import 'package:flutter/material.dart';
import '../drawer/app_drawer.dart';
import '../product/cartitemmodel.dart';
import '../product/cartpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<CartItem> cartItems = [];
  Map<String, int> quantities = {};

  List<Map<String, String>> banners = [
    {
      "image": "assets/images/banner1.jpg",
      "title":
          "Fresh Killed Poultry\nChickens Specialty\nGame Meats Eggs And\nMore!!!",
    },
    {
      "image": "assets/images/banner2.jpg",
      "title": "Healthy Farm Raised\nOrganic Chickens\nFresh Meat Every Day",
    },
    {
      "image": "assets/images/banner3.jpg",
      "title": "Farm Fresh Eggs\nPremium Quality\nBest Poultry Products",
    },
  ];

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  void startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        currentIndex++;

        if (currentIndex == banners.length) {
          currentIndex = 0;
        }

        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );

        setState(() {});
      }

      startAutoScroll();
    });
  }

  void addToCart(String image, String title, double price, int qty) {
    final index = cartItems.indexWhere((item) => item.title == title);

    if (index >= 0) {
      cartItems[index].quantity += qty;
    } else {
      cartItems.add(
        CartItem(image: image, title: title, price: price, quantity: qty),
      );
    }

    setState(() {});
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: const AppDrawer(),
      floatingActionButton: Container(
        height: h * 0.0503,
        width: w * 0.110,
        child: FloatingActionButton(
          backgroundColor: const Color(0xffF48C45),
          onPressed: scrollToTop,
          child: const Icon(Icons.arrow_upward, color: Colors.white),
        ),
      ),

      appBar: AppBar(
        toolbarHeight: h * 0.070,
        elevation: 1,
        backgroundColor: Colors.orange.shade200,
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset(
              "assets/images/poultrylogo.png",
              height: h * 0.045,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(cartItems: cartItems),
                    ),
                  );
                },
              ),

              if (cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: RefreshIndicator(
        color: const Color(0xffF48C45),
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: 3),
              Stack(
                children: [
                  SizedBox(
                    height: h * 0.34,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          banners[index]["image"]!,
                          fit: BoxFit.cover,
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: h * 0.34,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(0, -0.5),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                            key: ValueKey(currentIndex),
                            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                            child: Text(
                              banners[currentIndex]["title"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w > 800 ? 36 : 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "DISCOVER NOW",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: h * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            banners.length,
                            (index) => AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: currentIndex == index ? 14 : 8,
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.orange
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.06,
                  vertical: h * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/murgabhai.png",
                        height: h * 0.34,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: h * 0.025),
                    Text(
                      "Welcome to Our Poultry And\nEgg Farm.",
                      style: TextStyle(
                        fontSize: w > 800 ? 34 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: h * 0.02),
                    Text(
                      "Continually productize compelling quality for packed with elated productize compelling quality for packed with all elated them setting up to website and creating pages.",
                      style: TextStyle(
                        fontSize: w > 800 ? 18 : 15,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: h * 0.025),
                    buildPoint("We are providing different services"),
                    buildPoint("We are one of leading company"),
                    buildPoint(
                      "Profitability is the primary goal of all business",
                    ),
                    buildPoint("Learn how to grow your Business"),
                    buildPoint("Professional solutions for your business"),

                    SizedBox(height: h * 0.03),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF48C45),
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.10,
                          vertical: h * 0.013,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "READ MORE",
                        style: TextStyle(
                          fontSize: w > 800 ? 18 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
              buildProductsSection(w, h),
              buildServicesSection(w, h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_box, color: Color(0xffF48C45), size: 22),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductsSection(double w, double h) {

    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    int crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    List<Map<String, String>> products = [
      {
        "image": "assets/images/pro1.png",
        "title": "Light Brown Eggs",
        "price": "\$29.99",
        "oldPrice": "\$49.99"
      },
      {
        "image": "assets/images/pro2.png",
        "title": "Little Chicken Broiler",
        "price": "\$29.99",
        "oldPrice": "\$49.99"
      },
      {
        "image": "assets/images/pro3.png",
        "title": "White Brown Eggs",
        "price": "\$29.99",
        "oldPrice": "\$49.99"
      },
      {
        "image": "assets/images/pro4.png",
        "title": "Chicken Broiler",
        "price": "\$29.99",
        "oldPrice": "\$49.99"
      },
      {
        "image": "assets/images/pro5.png",
        "title": "Fresh Chicken",
        "price": "\$29.99",
        "oldPrice": "\$49.99"
      },
      {
        "image": "assets/images/pro6.png",
        "title": "Raw Chicken Broiler",
        "price": "\$29.99",
        "oldPrice": "\$49.99"
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.04),
      color: Colors.orange.shade100.withAlpha(110),

      child: Column(
        children: [

          /// TITLE
          Text(
            "Poultry Farm\nProducts",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 42 : 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: h * 0.02),

          Text(
            "Conveniently customize proactive web services for leveraged interfaces without Globally",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 14,
              color: Colors.grey.shade700,
            ),
          ),

          SizedBox(height: h * 0.04),

          /// PRODUCT GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: products.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isDesktop ? 0.95 : 0.8,
            ),

            itemBuilder: (context, index) {

              final product = products[index];

              return buildProductCard(
                image: product["image"]!,
                title: product["title"]!,
                price: product["price"]!,
                oldPrice: product["oldPrice"]!,
                h: h,
              );
            },
          ),

          SizedBox(height: h * 0.04),

          /// SHOP BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF48C45),
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.15,
                vertical: h * 0.018,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "SHOP NOW",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard({
    required String image,
    required String title,
    required String price,
    required String oldPrice,
    required double h,
  }) {
    int quantity = quantities[title] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(image, height: h * 0.20, fit: BoxFit.contain),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => const Icon(
                Icons.star_border,
                color: Color(0xffF48C45),
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xffF48C45),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                oldPrice,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// QUANTITY SELECTOR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: () {
                    if (quantity > 0) {
                      setState(() {
                        quantities[title] = quantity - 1;
                      });
                    }
                  },
                ),

                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () {
                    setState(() {
                      quantities[title] = quantity + 1;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF48C45),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (quantity > 0) {
                  addToCart(
                    image,
                    title,
                    double.parse(price.replaceAll("\$", "")),
                    quantity,
                  );

                  setState(() {
                    quantities[title] = 0;
                  });
                }
              },
              child: const Text(
                "Add to Cart",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildServicesSection(double w, double h) {

    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    int crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    List<Map<String, String>> services = [
      {
        "image": "assets/images/ser1.png",
        "title": "Alternative egg",
        "desc": "Continually aggregate frictionless enthusiasm generate user friendly portals empowered without globally results."
      },
      {
        "image": "assets/images/ser2.png",
        "title": "Poultry Cages",
        "desc": "Efficient poultry cages designed for better productivity, ventilation and improved poultry farm management."
      },
      {
        "image": "assets/images/ser3.png",
        "title": "Breeder Management",
        "desc": "Professional breeder management solutions ensuring healthy breeding and higher poultry production."
      },
      {
        "image": "assets/images/ser4.png",
        "title": "Poultry Climate",
        "desc": "Smart climate control systems for maintaining ideal temperature and humidity inside poultry farms."
      },
      {
        "image": "assets/images/ser5.png",
        "title": "Residue Treatment",
        "desc": "Advanced residue treatment methods helping farms maintain hygiene and environmental sustainability."
      },
      {
        "image": "assets/images/ser6.png",
        "title": "Exhaust Air Treatment",
        "desc": "Modern exhaust air treatment technology ensuring clean airflow and healthier poultry farm environment."
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.06,
        vertical: h * 0.05,
      ),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Text(
            "Poultry Farm Services",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 40 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h * 0.015),
          Text(
            "Conveniently customize proactive web services for leveraged interfaces without Globally",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 14,
              color: Colors.grey.shade700,
            ),
          ),

          SizedBox(height: h * 0.05),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 140,
            ),

            itemBuilder: (context, index) {

              final service = services[index];

              return Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 59,
                      width: 60,
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        service["image"]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service["title"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            service["desc"]!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
