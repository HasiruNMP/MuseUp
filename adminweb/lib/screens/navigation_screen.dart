import 'package:adminweb/screens/feedbacks_screen.dart';
import 'package:adminweb/screens/reports_screen.dart';
import 'package:adminweb/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'MuseUp Admin Dashboard',
          style: GoogleFonts.lato(
            //fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            controller.jumpToPage(0);
                            setState(() {
                              _selectedPage = 0;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: _selectedPage==0? Colors.indigo.shade200 : Colors.indigo.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.feedback_rounded),
                                  Text(
                                    'FEEDBACKS',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            controller.jumpToPage(1);
                            setState(() {
                              _selectedPage = 1;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: _selectedPage==1? Colors.indigo.shade200 : Colors.indigo.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.report_rounded),
                                  Text(
                                    'REPORTS',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    AspectRatio(
                      aspectRatio: 3/2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            AuthService().signOut();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: _selectedPage==1? Colors.indigo.shade200 : Colors.indigo.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.report_rounded),
                                  Text(
                                    'LOGOUT',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            controller.jumpToPage(2);
                            setState(() {
                              _selectedPage = 2;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: _selectedPage==2? Colors.indigo.shade200 : Colors.indigo.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.label),
                                  Text(
                                    'PROFILES',
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: PageView(
              controller: controller,
              children: const <Widget>[
                FeedbacksScreen(),
                ReportsScreen(),
                Center(
                  child: Text('Profile Screen'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
