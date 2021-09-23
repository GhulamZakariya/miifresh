import 'package:flutter/material.dart';
import 'package:flutterdelivery/bloc/change_status/status_bloc.dart';
import 'package:flutterdelivery/bloc/orders/orders_bloc.dart';
import 'package:flutterdelivery/dashboard.dart';
import 'package:flutterdelivery/history.dart';
import 'package:flutterdelivery/login_screen.dart';
import 'package:flutterdelivery/order_details.dart';
import 'package:flutterdelivery/repositories/change_status_repo.dart';
import 'package:flutterdelivery/repositories/orders_repo.dart';
import 'package:flutterdelivery/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login/login_bloc.dart';
import 'repositories/login_repo.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: "Settings",
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }

  void _nextToDetailPage(Widget nextScreen) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => nextScreen));
  }

  void _toHomeScreen(int position) {
    setState(() {
      _selectedIndex = position;
    });
  }

  void _toLoginScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(RealLoginRepo()),
              child: LoginScreen(),
            )));
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          BlocProvider(create: (BuildContext context) => OrdersBloc(RealOrdersRepo()),
          child: Dashboard(_nextToDetailPage)),
          History(_nextToDetailPage),
          BlocProvider(create: (BuildContext context) => StatusBloc(RealChangeStatusRepo()),
          child: Settings(_toHomeScreen, _nextToDetailPage, _toLoginScreen, _dismissDialog)),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
