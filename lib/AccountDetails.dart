import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projects/theme.dart';
import 'package:provider/provider.dart';
class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key,required this.userEmail,required this.userName});
  final String? userEmail;
  final String? userName;
  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${widget.userName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.userEmail}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      width: 170,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromRGBO(22, 153, 81, 1),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Preferences',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              //color: Colors.white,
              width: double.infinity,
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 30,
                      ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                    ],
                  ),

                  IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_rounded))
                ],
              ),
            ),
            Container(
              //   color: Colors.white,
              width: double.infinity,
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.dark_mode_outlined,
                        size: 30,
                      ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                    ],
                  ),
                  Center(
                    child: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, _) {
                          return IconButton(
                              icon: themeProvider.isDarkMode
                                  ? const FaIcon(FontAwesomeIcons.toggleOn)
                                  : const FaIcon(FontAwesomeIcons.toggleOff),
                              onPressed: () {
                                setState(() {

                                  themeProvider.toggleTheme();
                                  final snackBar = SnackBar(
                                    content: Text(
                                      themeProvider.isDarkMode
                                          ? 'Switched to Dark Mode'
                                          : 'Switched to Light Mode',
                                    ),
                                  );
                                  ScaffoldMessenger.
                                  of(context).showSnackBar(
                                      snackBar);
                                },
                                );
                              });
                        }
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Row(
                    children: [
                      Icon(
                        Icons.credit_card_outlined,
                        //    color: Colors.grey[800],
                        size: 30,
                      ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                    ],
                  ),

                  IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_rounded))
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 30,
                      ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Help and Feedback',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                    ],
                  ),

                  IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_rounded))
                ],
              ),
            ),




          ],
        ),
      ) ,
    );
  }
}