import 'package:angular2/di.dart';
import 'package:angular2/platform/browser.dart';

import 'package:http/browser_client.dart';
import 'package:testing_example/app/app_component.dart';
import 'package:testing_example/iss.dart';

void main() {

  bootstrap(AppComponent, [
    new Provider(IssLocator, useValue: new IssLocator(new BrowserClient())),
  ]);
}
