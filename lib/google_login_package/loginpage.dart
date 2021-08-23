import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'google_signin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 160),
              Center(
                child: Text(
                  'HackerEarth Gallery',
                  style: GoogleFonts.montserrat(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              SizedBox(height: 65),
              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ],
                    borderRadius: BorderRadius.circular(120),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/hackereart.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 65),
              Center(
                child: Text(
                  'Sign In With',
                  style: GoogleFonts.montserrat(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 26),
                ),
              ),
              SizedBox(height: 30),
              Center(child: GoogleSignInButtonWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 200,
      //color: Colors.redAccent,
      padding: EdgeInsets.all(4),
      child: OutlinedButton.icon(
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.login();
        },
        icon: FaIcon(
          FontAwesomeIcons.google,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        label: Text(' Google ',
            style: GoogleFonts.montserrat(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
            )),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.green.shade900),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green.shade900),
            ),
          ),
        ),
      ),
    );
  }
}
