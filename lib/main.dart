import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app_themes/themes.dart';
import 'google_login_package/google_signin.dart';
import 'google_login_package/loginpage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          title: 'HackerEarth Gallery',
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          home: StartingPage(),
        );
      },
    ),
  );
}

class StartingPage extends StatefulWidget {
  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            if (provider.isSigningIn) {
              return buildLoading();
            } else if (snapshot.hasData) {
              return MyHomePage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          //CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool search = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final picker = ImagePicker();
  bool light;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.isDarkMode ? light = false : light = true;
    return Scaffold(
      appBar: AppBar(
        actions: [
          search == false
              ? IconButton(
                  icon:
                      Icon(Icons.search, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    setState(() {
                      search = !search;
                    });
                  },
                )
              : IconButton(
                  icon:
                      Icon(Icons.cancel, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    setState(() {
                      search = !search;
                    });
                  },
                ),
        ],
        backgroundColor: Colors.green.shade900,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: search == true
            ? TextField(
                style: GoogleFonts.montserrat(
                    color: Theme.of(context).primaryColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon:
                      Icon(Icons.search, color: Theme.of(context).primaryColor),
                  hintText: 'Search ... ',
                  hintStyle: GoogleFonts.montserrat(
                      color: Theme.of(context).primaryColor),
                ),
                onChanged: (text) {
                  searchMethod(text);
                },
              )
            : Text(
                'HackerEarth Gallery',
                style: GoogleFonts.nunito(
                  color: Theme.of(context).primaryColor,
                ),
              ),
      ),
      drawer: new Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.green.shade900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    maxRadius: 60,
                    backgroundImage: NetworkImage(user.photoURL),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    child: Text(
                      user.displayName,
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.email,
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SizedBox.fromSize(
                              size: Size(100, 1000),
                              child: WebView(
                                initialUrl:
                                    "https://kishoremuthuselvan7.blogspot.com/?m=1",
                                javascriptMode: JavascriptMode.unrestricted,
                              ),
                            )));
              },
              child: ListTile(
                title: Text(
                  'Developer Info',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(color: Colors.grey, thickness: 1),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(light);
                  light = !light;
                });
              },
              child: ListTile(
                title: Text(
                  'Change Theme',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                leading: light == true
                    ? Icon(Icons.wb_sunny_outlined,
                        color: Theme.of(context).secondaryHeaderColor)
                    : Icon(Icons.wb_incandescent_outlined,
                        color: Theme.of(context).secondaryHeaderColor),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(color: Colors.grey, thickness: 1),
            ),
            InkWell(
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: ListTile(
                title: Text(
                  'Logout',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(color: Colors.grey, thickness: 1),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Firebase Init Error'));
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    child: _buildBody(context),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade900,
        onPressed: _takeImage,
        child: Icon(Icons.add_a_photo, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<firebase_storage.ListResult>(
      stream: Stream.fromFuture(
          firebase_storage.FirebaseStorage.instance.ref(user.email).listAll()),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.items.isEmpty)
            return Text(
              "Please Add Image",
              style: GoogleFonts.nunito(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 24,
              ),
            );
          return _buildList(context, snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildList(
      BuildContext context, firebase_storage.ListResult snapshot) {
    return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.items
            .map((data) => _buildListItem(context, data))
            .toList());
  }

  Widget _buildListItem(BuildContext context, firebase_storage.Reference data) {
    return FutureBuilder(
        future: data.getDownloadURL(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return Container();
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleImageDetails(
                            name: data.name,
                            url: snapshot.data.toString(),
                            bucket: data.bucket,
                            location: data.fullPath,
                          )));
            },
            child: Padding(
              key: ValueKey(data.name),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100), blurRadius: 10.0),
                  ],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            data.name,
                            style: GoogleFonts.nunito(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Do you want to delete this image?",
                                        style: GoogleFonts.nunito(),
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "No",
                                              style: GoogleFonts.nunito(
                                                  color: Colors.grey),
                                            )),
                                        FlatButton(
                                            onPressed: () async {
                                              await firebase_storage
                                                  .FirebaseStorage.instance
                                                  .ref(data.fullPath)
                                                  .delete();
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Text(
                                              "Yes",
                                              style: GoogleFonts.nunito(
                                                  color: Colors.green.shade900),
                                            ))
                                      ],
                                    );
                                  });
                            })
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(snapshot.data),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future _takeImage() async {
    // Get image from gallery.
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    final File imageFile = File(pickedFile.path);
    _uploadImageToFirebase(imageFile);
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = '${user.email}/image$randomNumber.jpg';

      // Upload image to firebase.
      await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .putFile(imageFile);
      setState(() {});
    } on FirebaseException catch (e) {
      print(e.code);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.code),
            );
          });
    } catch (e) {
      print(e.message);
    }
  }

  void searchMethod(String text) {}
}

class SingleImageDetails extends StatelessWidget {
  final String name;
  final String url;
  final String location;
  final String bucket;

  const SingleImageDetails(
      {Key key, this.name, this.url, this.location, this.bucket})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green.shade900,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(name,
              style: GoogleFonts.montserrat(
                  color: Theme.of(context).primaryColor))),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .secondaryHeaderColor
                                  .withAlpha(100),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.network(url)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: Text(
                    name,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
              )),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _launchURL(url);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Center(
                      child: Text(
                        url,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String place) async {
    var url = place;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
