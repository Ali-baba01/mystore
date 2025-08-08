import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 360,
        height: 800,
        child: Stack(
          children: [
            // Title "Mitt konto" - exact positioning
            Positioned(
              top: 31,
              left: 123,
              child: Container(
                width: 114,
                height: 32,
                child: Center(
                  child: Text(
                    'Mitt konto',
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.0,
                      letterSpacing: 0,
                      color: const Color(0xFF0C0C0C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            
            // Profile Info Container - exact positioning
            Positioned(
              top: 97,
              left: 21,
              child: Container(
                width: 318,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFF0C0C0C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Profile Picture (Circle Avatar)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: const Color(0xFF0C0C0C),
                        ),
                      ),
                    ),
                    
                    // Name "Ali" - exact positioning
                    Positioned(
                      top: 17, // 114 - 97 = 17
                      left: 94, // 115 - 21 = 94
                      child: Container(
                        width: 68,
                        height: 21,
                        child: Text(
                          'Ali',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    // Email - exact positioning
                    Positioned(
                      top: 38, // 135 - 97 = 38
                      left: 94, // 115 - 21 = 94
                      child: Container(
                        width: 110,
                        height: 15,
                        child: Text(
                          'Adam7ali000@gmail.com',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Colors.white.withOpacity(0.8),
                          ),

                        ),
                      ),
                    ),



// Phone Number - exact positioning (email ke neeche)
                    Positioned(
                      top: 56, // Email ke neeche 18px gap
                      left: 94,
                      child: Container(
                        width: 160,
                        height: 15,
                        child: Text(
                          '+92 3344344334',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            
            // Menu Items with Icons - exact positioning
            
            // Kontoinstallningar with Settings Icon
            Positioned(
              top: 248,
              left: 42,
              child: Container(
                width: 19,
                height: 19,
                child: const Icon(
                  Icons.settings,
                  size: 16,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Positioned(
              top: 248,
              left: 80,
              child: Container(
                width: 128,
                height: 21,
                child: Text(
                  'Kontoinstallningar',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
            
            // Mina betalmetoder with Payment Icon
            Positioned(
              top: 295,
              left: 42,
              child: Container(
                width: 19,
                height: 19,
                child: const Icon(
                  Icons.payment,
                  size: 16,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Positioned(
              top: 295,
              left: 80,
              child: Container(
                width: 135,
                height: 21,
                child: Text(
                  'Mina betalmetoder',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
            
            // Support with Help Icon
            Positioned(
              top: 342,
              left: 42,
              child: Container(
                width: 19,
                height: 19,
                child: const Icon(
                  Icons.help_outline,
                  size: 16,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Positioned(
              top: 342,
              left: 80,
              child: Container(
                width: 56,
                height: 21,
                child: Text(
                  'Support',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

} 