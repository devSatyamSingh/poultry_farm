import 'package:flutter/material.dart';
import 'cartitemmodel.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get total {
    double sum = 0;
    for (var item in widget.cartItems) {
      sum += item.price * item.quantity;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    bool isDesktop = w > 900;
    bool isTablet = w > 600 && w < 900;

    double horizontalMargin = isDesktop
        ? w * 0.25
        : isTablet
        ? w * 0.12
        : 16;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.orange.shade200,
        title: const Text("Your Cart"),
        centerTitle: true,
      ),

      body: widget.cartItems.isEmpty
          ? buildEmptyCart(isDesktop, w)
          : buildCartList(isDesktop, isTablet, horizontalMargin, w, h),
    );
  }

  /// EMPTY CART UI
  Widget buildEmptyCart(bool isDesktop, double w) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: isDesktop ? w * 0.12 : w * 0.22,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 20),

          Text(
            "Your Cart is Empty",
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Looks like you haven't added\nanything to your cart yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 15,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF48C45),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 40,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            onPressed: () {
              Navigator.pop(context);
            },

            child: Text(
              "Start Shopping",
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CART LIST
  Widget buildCartList(
    bool isDesktop,
    bool isTablet,
    double margin,
    double w,
    double h,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.cartItems.length,

            itemBuilder: (context, index) {
              final item = widget.cartItems[index];

              return Container(
                margin: EdgeInsets.symmetric(horizontal: margin, vertical: 8),

                padding: EdgeInsets.all(isDesktop ? 18 : 12),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    /// PRODUCT IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item.image,
                        height: isDesktop
                            ? h * 0.12
                            : isTablet
                            ? h * 0.10
                            : h * 0.09,
                        width: isDesktop
                            ? h * 0.12
                            : isTablet
                            ? h * 0.10
                            : h * 0.09,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// TITLE + PRICE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isDesktop ? 20 : 16,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "\$${item.price} each",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: const Color(0xffF48C45),
                              fontWeight: FontWeight.bold,
                              fontSize: isDesktop ? 18 : 14,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// QUANTITY SELECTOR
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      } else {
                                        widget.cartItems.removeAt(index);
                                      }
                                    });
                                  },
                                ),

                                Text(
                                  item.quantity.toString(),
                                  style: TextStyle(
                                    fontSize: isDesktop ? 16 : 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),

                                  onPressed: () {
                                    setState(() {
                                      item.quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// DELETE BUTTON
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: isDesktop ? 28 : 22,
                      ),

                      onPressed: () {
                        setState(() {
                          widget.cartItems.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        /// TOTAL SECTION
        Container(
          margin: EdgeInsets.symmetric(horizontal: margin, vertical: 16),

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
            ],
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffF48C45),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF48C45),
                    padding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 18 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: () {},

                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 18 : 16,
                      color: Colors.white,
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
}
