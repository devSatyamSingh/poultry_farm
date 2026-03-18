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
  late PageController _logoPageController;
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<CartItem> cartItems = [];
  Map<String, int> quantities = {};
  // final PageController _logoPageController = PageController();
  int logoIndex = 0;

  List<String> ads = [
    "assets/images/ad1.png",
    "assets/images/ad2.png",
    "assets/images/ad3.png",
    "assets/images/ad4.png",
    "assets/images/ad5.png",
  ];
  late List<String> loopAds;

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
    logoIndex = ads.length; // 👈 middle se start
    _logoPageController = PageController(
      viewportFraction: 0.25, // default (desktop)
      initialPage: logoIndex,
    );
    startLogoAutoScroll();
    loopAds = [...ads, ...ads, ...ads, ...ads, ...ads];
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

  void startLogoAutoScroll() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_logoPageController.hasClients) {
        logoIndex++;

        _logoPageController.animateToPage(
          logoIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );

        /// 🔥 reset silently (no lag)
        if (logoIndex >= ads.length * 2) {
          logoIndex = ads.length;

          _logoPageController.jumpToPage(logoIndex);
        }
      }
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
      floatingActionButton: SizedBox(
        height: w > 1000
            ? 60
            : w > 650
            ? 55
            : 50,
        width: w > 1000
            ? 60
            : w > 650
            ? 55
            : 50,

        child: FloatingActionButton(
          backgroundColor: const Color(0xffF48C45),
          onPressed: scrollToTop,
          child: Icon(
            Icons.arrow_upward,
            color: Colors.white,
            size: w > 1000 ? 28 : 24,
          ),
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
              buildHeroSection(w, h),
              buildAboutSection(w, h),
              buildProductsSection(w, h),
              buildServicesSection(w, h),
              buildGallery(w, h),
              buildTeamSection(w, h),
              buildTestimonialSection(w, h),
              buildNewsSection(w, h),
              buildAdsSection(w, h),
              buildFeaturesSection(w, h),
              buildFooter(w, h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeroSection(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    double heroHeight = isDesktop
        ? 520
        : isTablet
        ? 420
        : 320;

    return Stack(
      children: [
        SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return Image.asset(banners[index]["image"]!, fit: BoxFit.cover);
            },
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        Container(
          height: heroHeight,
          width: double.infinity,
          color: Colors.black.withOpacity(0.45),
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
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Padding(
                  key: ValueKey(currentIndex),
                  padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                  child: Text(
                    banners[currentIndex]["title"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop
                          ? 48
                          : isTablet
                          ? 36
                          : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: heroHeight * 0.05),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 25,
                    vertical: isDesktop ? 18 : 12,
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
              SizedBox(height: heroHeight * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: currentIndex == index ? 16 : 8,
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
    );
  }

  Widget buildAboutSection(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.06),
      color: Colors.grey.shade100,
      child: isDesktop || isTablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/murgabhai.png",
                    height: h * 0.45,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: w * 0.05),
                Expanded(flex: 1, child: buildAboutText(w, h)),
              ],
            )
          : Column(
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
                buildAboutText(w, h),
              ],
            ),
    );
  }

  Widget buildAboutText(double w, double h) {
    bool isDesktop = w > 1000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Our Poultry And\nEgg Farm.",
          style: TextStyle(
            fontSize: isDesktop ? 36 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: h * 0.02),
        Text(
          "Continually productize compelling quality for packed with elated productize compelling quality for packed with all elated them setting up to website and creating pages.",
          style: TextStyle(
            fontSize: isDesktop ? 18 : 15,
            color: Colors.grey.shade700,
            height: 1.6,
          ),
        ),

        SizedBox(height: h * 0.025),
        buildPoint("We are providing different services"),
        buildPoint("We are one of leading company"),
        buildPoint("Profitability is the primary goal of all business"),
        buildPoint("Learn how to grow your Business"),
        buildPoint("Professional solutions for your business"),

        SizedBox(height: h * 0.03),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffF48C45),
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.08,
              vertical: h * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {},
          child: Text(
            "READ MORE",
            style: TextStyle(
              fontSize: isDesktop ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
        "oldPrice": "\$49.99",
      },
      {
        "image": "assets/images/pro2.png",
        "title": "Little Chicken Broiler",
        "price": "\$29.99",
        "oldPrice": "\$49.99",
      },
      {
        "image": "assets/images/pro3.png",
        "title": "White Brown Eggs",
        "price": "\$29.99",
        "oldPrice": "\$49.99",
      },
      {
        "image": "assets/images/pro4.png",
        "title": "Chicken Broiler",
        "price": "\$29.99",
        "oldPrice": "\$49.99",
      },
      {
        "image": "assets/images/pro5.png",
        "title": "Fresh Chicken",
        "price": "\$29.99",
        "oldPrice": "\$49.99",
      },
      {
        "image": "assets/images/pro6.png",
        "title": "Raw Chicken Broiler",
        "price": "\$29.99",
        "oldPrice": "\$49.99",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.04),
      color: Colors.orange.shade100.withAlpha(110),

      child: Column(
        children: [
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
          SizedBox(height: 14),
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
        "desc":
            "Continually aggregate frictionless enthusiasm generate user friendly portals empowered without globally results.",
      },
      {
        "image": "assets/images/ser2.png",
        "title": "Poultry Cages",
        "desc":
            "Efficient poultry cages designed for better productivity, ventilation and improved poultry farm management.",
      },
      {
        "image": "assets/images/ser3.png",
        "title": "Breeder Management",
        "desc":
            "Professional breeder management solutions ensuring healthy breeding and higher poultry production.",
      },
      {
        "image": "assets/images/ser4.png",
        "title": "Poultry Climate",
        "desc":
            "Smart climate control systems for maintaining ideal temperature and humidity inside poultry farms.",
      },
      {
        "image": "assets/images/ser5.png",
        "title": "Residue Treatment",
        "desc":
            "Advanced residue treatment methods helping farms maintain hygiene and environmental sustainability.",
      },
      {
        "image": "assets/images/ser6.png",
        "title": "Exhaust Air Treatment",
        "desc":
            "Modern exhaust air treatment technology ensuring clean airflow and healthier poultry farm environment.",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.05),
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
                    ),
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

  Widget buildGallery(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    /// Responsive columns
    int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

    List<Map<String, String>> gallery = [
      {"image": "assets/images/gal1.jpg"},
      {"image": "assets/images/gal2.jpg"},
      {"image": "assets/images/gal3.jpg"},
      {"image": "assets/images/gal4.jpg"},
      {"image": "assets/images/gal5.jpg"},
      {"image": "assets/images/gal6.jpg"},
      {"image": "assets/images/gal7.jpg"},
      {"image": "assets/images/gal8.jpg"},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.05),
      color: Colors.orange.shade100.withAlpha(110),

      child: Column(
        children: [
          /// TITLE
          Text(
            "Poultry Farm Gallery",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 40 : 28,
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

          SizedBox(height: h * 0.05),

          /// GALLERY GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: gallery.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1,
            ),

            itemBuilder: (context, index) {
              final galleryItem = gallery[index];

              return buildGalleryCard(image: galleryItem["image"]!);
            },
          ),

          SizedBox(height: h * 0.04),

          /// BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF48C45),
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.12,
                vertical: h * 0.018,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "LOAD GALLERY",
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

  Widget buildGalleryCard({required String image}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),

        child: Image.asset(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget buildTeamSection(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

    List<Map<String, String>> team = [
      {
        "image": "assets/images/team1.jpg",
        "name": "Jason Roy",
        "role": "Manager",
      },

      {
        "image": "assets/images/team2.jpg",
        "name": "Sahjahan Sagor",
        "role": "Founder & CEO",
      },

      {
        "image": "assets/images/team3.jpg",
        "name": "Alisha Kabir",
        "role": "Marketer",
      },

      {
        "image": "assets/images/team4.jpg",
        "name": "Jeson Smith",
        "role": "Farmer",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Text(
            "Our Team Member",
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
            itemCount: team.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),

            itemBuilder: (context, index) {
              final member = team[index];

              return buildTeamCard(
                image: member["image"]!,
                name: member["name"]!,
                role: member["role"]!,
                h: h,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTeamCard({
    required String image,
    required String name,
    required String role,
    required double h,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: h * 0.40,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(role, style: TextStyle(color: Colors.grey.shade600)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.facebook, size: 22, color: Colors.blue),
              SizedBox(width: 14),

              Icon(Icons.camera_alt, size: 22, color: Colors.red),
              SizedBox(width: 14),

              Icon(Icons.play_circle_fill, size: 22, color: Colors.purple),
              SizedBox(width: 14),

              Icon(Icons.business, size: 22, color: Colors.blue),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildTestimonialSection(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    int crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    List<Map<String, String>> testimonials = [
      {
        "image": "assets/images/team1.jpg",
        "name": "Jeson Smith",
        "role": "Founder & CEO",
        "desc":
            "Continually conceptualize technically innovative solutions professionally monetize testing. Professionally enable functionalized e-commerce initiatives.",
      },

      {
        "image": "assets/images/team2.jpg",
        "name": "Sahjahan Sagor",
        "role": "Founder & CEO",
        "desc":
            "Continually conceptualize technically innovative solutions professionally monetize testing. Professionally enable functionalized e-commerce initiatives.",
      },

      {
        "image": "assets/images/team3.jpg",
        "name": "Alisha Kabir",
        "role": "Founder & CEO",
        "desc":
            "Continually conceptualize technically innovative solutions professionally monetize testing. Professionally enable functionalized e-commerce initiatives.",
      },
    ];

    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),

      color: const Color(0xffF3E6D9),

      child: Column(
        children: [
          /// TITLE
          Text(
            "What Client Say Our Poultry Farm",
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

          /// GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: testimonials.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              childAspectRatio: isDesktop ? 1.5 : 1.25,
            ),

            itemBuilder: (context, index) {
              final item = testimonials[index];

              return buildTestimonialCard(
                image: item["image"]!,
                name: item["name"]!,
                role: item["role"]!,
                desc: item["desc"]!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTestimonialCard({
    required String image,
    required String name,
    required String role,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// USER INFO
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),

                child: Image.asset(
                  image,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(role, style: TextStyle(color: Colors.grey.shade600)),

                  const SizedBox(height: 4),

                  /// STARS
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star_border,
                        color: Colors.orange,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// QUOTE ICON
          Icon(Icons.format_quote, color: Colors.grey.shade300, size: 40),

          const SizedBox(height: 10),

          /// DESCRIPTION
          Text(
            desc,
            style: TextStyle(color: Colors.grey.shade700, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget buildNewsSection(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    int crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    List<Map<String, String>> news = [
      {
        "image": "assets/images/team1.jpg",
        "title": "Chicken ducklings to help solve Obesity...",
        "desc":
            "Conveniently customize proactive web services without Globally. oe-enable functionalized e-commerce conceptualize technically initiatives.",
      },

      {
        "image": "assets/images/team2.jpg",
        "title": "Will eggs be a news source of cancer drugs...",
        "desc":
            "Conveniently customize proactive web services without Globally. oe-enable functionalized e-commerce conceptualize technically initiatives.",
      },

      {
        "image": "assets/images/team3.jpg",
        "title": "Omega-3 chicken,egg may lower heart attack...",
        "desc":
            "Conveniently customize proactive web services without Globally. oe-enable functionalized e-commerce conceptualize technically initiatives.",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Text(
            "Our Recent News",
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
            itemCount: news.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              mainAxisExtent: 470,
            ),
            itemBuilder: (context, index) {
              final item = news[index];
              return buildNewsCard(
                image: item["image"]!,
                title: item["title"]!,
                desc: item["desc"]!,
                w: w,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildNewsCard({
    required String image,
    required String title,
    required String desc,
    required double w,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              image,
              height: w > 1000
                  ? 270
                  : w > 650
                  ? 230
                  : 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Read More",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAdsSection(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    double viewport = isDesktop
        ? 0.25
        : isTablet
        ? 0.5
        : 1.0;

    return Container(
      width: double.infinity,
      color: const Color(0xffDED6CF),
      padding: EdgeInsets.symmetric(vertical: h * 0.04),
      child: SizedBox(
        height: isDesktop ? 150 : 130,
        child: PageView.builder(
          controller: _logoPageController,
          itemCount: loopAds.length,
          onPageChanged: (i) {
            logoIndex = i;
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(loopAds[index], fit: BoxFit.contain),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildFeaturesSection(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;

    int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

    List<Map<String, String>> features = [
      {
        "image": "assets/images/f1.png",
        "title": "Products Range",
        "desc":
            "Conveniently customize recaptiualize focused inter without globally",
      },
      {
        "image": "assets/images/f2.png",
        "title": "Quality Matters",
        "desc":
            "Conveniently customize recaptiualize focused inter without globally",
      },
      {
        "image": "assets/images/f3.png",
        "title": "Free Shipping",
        "desc":
            "Conveniently customize recaptiualize focused inter without globally",
      },
      {
        "image": "assets/images/f4.png",
        "title": "Customer Satisfaction",
        "desc":
            "Conveniently customize recaptiualize focused inter without globally",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          childAspectRatio: isDesktop ? 1.2 : 1.1,
        ),
        itemBuilder: (context, index) {
          final item = features[index];

          return Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(item["image"]!, height: 55, fit: BoxFit.contain),
                SizedBox(height: 16),
                Text(
                  item["title"]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text(
                  item["desc"]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildFooter(double w, double h) {
    bool isDesktop = w > 1000;
    bool isTablet = w > 650 && w <= 1000;
    int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);
    return Container(
      width: double.infinity,
      color: const Color(0xffDED6CF),
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isDesktop
                ? 1.8
                : isTablet
                ? 1.4
                : 1.2, // 👈 mobile fix
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/poultrylogo.png", height: 40),
                  SizedBox(height: w > 650 ? 15 : 8),
                  Text(
                    "Conveniently customize web services aggregate frictionle internet without globaly.",
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Enthusiastically scale synergistic technologies for leveraged with technology quickly.",
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 👈 FIX
                children: [
                  Text(
                    "Keep In Touch",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: w > 650 ? 15 : 8),

                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.orange, size: 18),
                      SizedBox(width: 10),
                      Expanded(child: Text("+9161440593\n+1234567890")),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Mon - Sat 10:00am - 7:00pm\n(except public holidays)",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.orange, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Gour City Mall Office Space 14 flore, 14119 room noida, UP",
                          softWrap: true, // 👈 FIX
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// 🔶 PRODUCTS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 👈 FIX
                children: [
                  Text(
                    "Poultry Farm Product",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: w > 650 ? 15 : 5),

                  buildFooterProduct(
                    "assets/images/pro1.png",
                    "Light Brown Eggs",
                  ),

                  SizedBox(height: 8),

                  buildFooterProduct(
                    "assets/images/pro2.png",
                    "Little Chicken Broiler",
                  ),
                ],
              ),

              /// 🔶 INSTAGRAM
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Instagram Feed",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: w > 645 ? 11.7 : 5),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(6, (index) {
                      List images = [
                        "assets/images/gal1.jpg",
                        "assets/images/gal2.jpg",
                        "assets/images/gal3.jpg",
                        "assets/images/gal4.jpg",
                        "assets/images/gal5.jpg",
                        "assets/images/gal6.jpg",
                      ];

                      return SizedBox(
                        width: (w > 1000)
                            ? 68   // desktop
                            : (w > 650)
                            ? 80 // tablet
                            : (w * 0.25), // mobile responsive
                        height: (w > 1000)
                            ? 68
                            : (w > 650)
                            ? 80
                            : (w * 0.25),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              )
            ],
          ),

          SizedBox(height: 20),

          /// 🔻 COPYRIGHT
          Text(
            "© 2026 Poultry Farm .All Rights Reserved By FC",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget buildFooterProduct(String image, String title) {
    return Row(
      children: [
        Image.asset(image, height: 50),
        SizedBox(width: 10),
        Expanded(
          // 👈 IMPORTANT FIX
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text("\$25.99"),
            ],
          ),
        ),
      ],
    );
  }
}
