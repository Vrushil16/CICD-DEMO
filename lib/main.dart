import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const FullScreenImageScroll(),
    );
  }
}

class FullScreenImageScroll extends StatefulWidget {
  const FullScreenImageScroll({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FullScreenImageScrollState createState() => _FullScreenImageScrollState();
}

class _FullScreenImageScrollState extends State<FullScreenImageScroll> with SingleTickerProviderStateMixin {
  final List<String> imageUrls = [
    'https://i.pinimg.com/736x/d5/5d/a2/d55da27abff1d4fc26fc4e5303f0c90a.jpg',
    'https://i.pinimg.com/474x/44/bb/7b/44bb7bfd7fde4df794561b82ab1920cf.jpg',
    'https://i.pinimg.com/474x/03/d4/3d/03d43daddaabc2503427a9e9d35e04ae.jpg',
    'https://e0.pxfuel.com/wallpapers/407/757/desktop-wallpaper-nature-trees-road-markup-journey.jpg',
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  final ValueNotifier<bool> _isBottomSheetOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _isBottomSheetOpen.dispose();
    super.dispose();
  }

  void _showLoginBottomSheet(BuildContext context) {
    if (_isBottomSheetOpen.value) return;

    _isBottomSheetOpen.value = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      // Handle login logic
                      Navigator.of(context).pop();
                    },
                    child: const Center(child: Text('Login')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isBottomSheetOpen.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          const Center(
            child: Text(
              'Vrushil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: _isBottomSheetOpen,
                builder: (context, isBottomSheetOpen, child) {
                  return ScaleTransition(
                    scale: _animation,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBottomSheetOpen ? Colors.grey : Colors.transparent,
                        shadowColor: Colors.transparent,
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: isBottomSheetOpen ? null : () => _showLoginBottomSheet(context),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
