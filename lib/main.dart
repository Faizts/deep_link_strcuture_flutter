import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleDeepLinks();
  }

  /// if init already called, than this
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleDeepLinks();
  }

  void _handleDeepLinks() async {
    print('Handling deep links...');
    // Handle initial deep link
    final Uri? initialLink = await _appLinks.getInitialAppLink();
    print('Initial link: $initialLink');
    if (initialLink != null) {
      _navigateToRoute(initialLink);
    }

    // Listen for subsequent deep links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _navigateToRoute(uri);
      }
    });
  }

  void _navigateToRoute(Uri uri) {
    String path = uri.path;
    if (path.isEmpty) {
      //Initial link: deeplinkpro://page1
      path = uri.toString();
      path = path.split('://')[1];
    }
    print('Navigating to route: $path');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (path == '/page1' || path == 'page1') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => Page1()),
        );
      } else if (path == '/page2' || path == 'page2') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => Page2()),
        );
      } else if (path == '/page3' || path == 'page3') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => Page3()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Linking Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => Builder(
              builder: (context) {
                // Pass the correct context to the _navigateToRoute method
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _handleDeepLinks();
                });
                return HomePage();
              },
            ),
        '/page1': (context) => Page1(),
        '/page2': (context) => Page2(),
        '/page3': (context) => Page3(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page1'),
              child: Text('Go to Page 1'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page2'),
              child: Text('Go to Page 2'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page3'),
              child: Text('Go to Page 3'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Center(
        child: Text('This is Page 1'),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: Center(
        child: Text('This is Page 2'),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      body: Center(
        child: Text('This is Page 3'),
      ),
    );
  }
}
