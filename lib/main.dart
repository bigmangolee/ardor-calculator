// Copyright 2019-present the Ardor.App authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:ardor_calculator/app/ardor/calculator/app_global.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:flutter/material.dart';

import 'package:ardor_calculator/app/ardor/calculator/cal_home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/ardor/calculator//treasure/account_page.dart';
import 'app/ardor/calculator//treasure/group_page.dart';

void main(){
  Future.wait([AppGlobal.instance.init()]).then((result) {
    runApp(ArdorApp());
  });
}

class ArdorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => S.of(context).app_name,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback:
      S.delegate.resolution(fallback: AppGlobal.instance.getLocale()),
      localeListResolutionCallback:
      S.delegate.listResolution(fallback: AppGlobal.instance.getLocale()),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.cyan,
      ),
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => CalHome(),
        '/group': (BuildContext context) => GroupHomePage(),
        '/account': (BuildContext context) => AccountHomePage(),
      },
    );
  }
}
