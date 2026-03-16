import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool homeOpen = false;
  bool pagesOpen = false;
  bool blogOpen = false;
  bool shopOpen = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Image.asset("assets/images/poultrylogo.png", height: 40),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 26,
                      color: Color(0xffF48C45),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            Expanded(
              child: ListView(
                children: [
                  drawerItem(
                    title: "Home",
                    expanded: homeOpen,
                    onTap: () {
                      setState(() {
                        homeOpen = !homeOpen;
                      });
                    },
                  ),

                  if (homeOpen) subItem("Home Page One"),
                  if (homeOpen) subItem("Home Page Two"),

                  const Divider(),

                  /// ABOUT
                  simpleItem("About"),

                  const Divider(),

                  /// PAGES
                  drawerItem(
                    title: "Pages",
                    expanded: pagesOpen,
                    onTap: () {
                      setState(() {
                        pagesOpen = !pagesOpen;
                      });
                    },
                  ),

                  if (pagesOpen) subItem("Team Member"),
                  if (pagesOpen) subItem("FAQ Page"),
                  if (pagesOpen) subItem("404 Page"),

                  const Divider(),

                  /// BLOG
                  drawerItem(
                    title: "Blog",
                    expanded: blogOpen,
                    onTap: () {
                      setState(() {
                        blogOpen = !blogOpen;
                      });
                    },
                  ),
                  if (blogOpen) subItem("Blog Right Sidebar"),
                  if (blogOpen) subItem("Blog Left Sidebar"),
                  if (blogOpen) subItem("Blog Details"),
                  const Divider(),
                  drawerItem(
                    title: "Shop",
                    expanded: shopOpen,
                    onTap: () {
                      setState(() {
                        shopOpen = !shopOpen;
                      });
                    },
                  ),
                  if (shopOpen) subItem("Products Page"),
                  if (shopOpen) subItem("Products Details"),
                  if (shopOpen) subItem("Cart Page"),
                  Divider(),
                  simpleItem("Contact"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget simpleItem(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
      onTap: () {},
    );
  }

  Widget drawerItem({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),

      trailing: Icon(
        expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      ),

      onTap: onTap,
    );
  }

  Widget subItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
