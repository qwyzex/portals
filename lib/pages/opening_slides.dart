import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/home_screen.dart';
import 'package:portals/pages/login_screen.dart';
import '../components/custom_button.dart';

class SlidesPage extends StatefulWidget {
  const SlidesPage({super.key});

  @override
  _SlidesPageState createState() => _SlidesPageState();
}

class _SlidesPageState extends State<SlidesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      // If user is already signed in, redirect to Home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
  }

  // List of slide data
  final List<Map<String, String>> _slides = [
    {
      "title": "Penyaluran Informasi",
      "description":
          "Melalui portalsmansa, pihak OSIS dan Sekolah dapat bekerjasama untuk menyampaikan segala informasi yang relevan dengan praktis dan efisien",
      "image": 'assets/images/slides_1.png',
    },
    {
      "title": "Sarana Bersuara",
      "description":
          "Wadah bagi siswa untuk bersuara dan menyampaikan pendapatnya",
      "image": 'assets/images/slides_2.png',
    },
    {
      "title": "Dari siswa, oleh siswa, untuk siswa",
      "description":
          "Sentral informasi dan sosial siswa-siswi SMA Negeri 1 Metro, dibuat dan dikelola oleh siswa",
      "image": 'assets/images/slides_3.png',
    },
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ); // Handle finishing the slides
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.buttonBackground,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.2), // Semi-transparent background
                      borderRadius: BorderRadius.circular(
                          50.0), // Optional: rounded corners
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_arrow_left_rounded,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    return _buildSlide(
                      _slides[index]["title"]!,
                      _slides[index]["description"]!,
                      _slides[index]["image"]!,
                    );
                  },
                ),
              ),
              _buildIndicator(),
              Padding(
                padding: const EdgeInsets.fromLTRB(45, 16, 45, 50),
                child: CustomButton(
                  text: _currentPage < _slides.length - 1 ? 'Next' : 'Login',
                  onPressed: _nextPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(String title, String description, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          FadeInImage(
            placeholder: const AssetImage(
                'assets/images/nothing.png'), // Use a placeholder image
            image: AssetImage(imagePath),
            height: 200,
            width: 200,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 100),
            fadeOutDuration: const Duration(milliseconds: 100),
          ),
          const SizedBox(height: 40),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 12.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }
}
