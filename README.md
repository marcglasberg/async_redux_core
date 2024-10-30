[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

[![pub package](https://img.shields.io/pub/v/async_redux_core.svg)](https://pub.dartlang.org/packages/async_redux_core  )

# async_redux_core

_This is the core Dart-only package for
the [async_redux](https://pub.dev/packages/async_redux) package._

## In your Flutter app:

* Do NOT include this core package directly.

  Instead, go to the [async_redux](https://pub.dev/packages/async_redux) package which
  already exports this core code, plus provides Flutter related code.

## In your Dart server or Dart-only code:

* For the moment, this Dart-only package simply contains the `UserException` class, and nothing
  more.

* If you are creating code for a Dart server (backend) like [Celest](https://celest.dev/), or
  developing some Dart-only package that does not depend on Flutter, then you can use this package
  directly:

  ```
  import 'package:async_redux_core/async_redux_core.dart';
  ```                                                              

  > Note: When using [Celest](https://celest.dev/), this is especially useful for
  throwing `UserException` in your backend code. Celest will make sure to throw that exception
  in the frontend. As long as the Celest cloud function is called inside redux actions, Async Redux
  will display the exception message to the user in a dialog (or other UI element that you can
  customize). This can also be used
  with [package i18n_extension_core](https://pub.dartlang.org/packages/i18n_extension_core)
  to make sure the error message gets translated to the user's language.
  For example: `UserException('The password you typed is invalid'.i18n);` in the backend, will
  reach the frontend already translated
  as `UserException('La contraseña que ingresaste no es válida')` if the user device is in Spanish.

## Documentation

Go to [async_redux](https://pub.dev/packages/async_redux) to read the docs.

********

## Marcelo Glasberg

_https://github.com/marcglasberg_<br>
_https://twitter.com/glasbergmarcelo_<br>
_https://stackoverflow.com/users/3411681/marcg_<br>
_https://medium.com/@marcglasberg_<br>

*The Flutter packages I've authored:*

* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/fast_immutable_collections">fast_immutable_collections</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">network_to_file_image</a>
* <a href="https://pub.dev/packages/image_pixels">image_pixels</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a>
* <a href="https://pub.dev/packages/back_button_interceptor">back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a>
* <a href="https://pub.dev/packages/animated_size_and_fade">animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">assorted_layout_widgets</a>
* <a href="https://pub.dev/packages/weak_map">weak_map</a>
* <a href="https://pub.dev/packages/themed">themed</a>

*My Medium Articles:*

* <a href="https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6">
  Async Redux: Flutter’s non-boilerplate version of Redux</a> (
  versions: <a href="https://medium.com/flutterando/async-redux-pt-brasil-e783ceb13c43">
  Português</a>)
* <a href="https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9">
  async_redux</a> (
  versions: <a href="https://medium.com/flutterando/qual-a-forma-f%C3%A1cil-de-traduzir-seu-app-flutter-para-outros-idiomas-ab5178cf0336">
  Português</a>)
* <a href="https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2">
  Flutter: The Advanced Layout Rule Even Beginners Must Know</a> (
  versions: <a href="https://habr.com/ru/post/500210/">русский</a>)
* <a href="https://medium.com/flutter-community/the-new-way-to-create-themes-in-your-flutter-app-7fdfc4f3df5f">
  The New Way to create Themes in your Flutter App</a>
* <a href="https://medium.com/@marcglasberg/a-new-bdd-tool-for-typescript-javascript-and-dart-673933b3b38e">
  A new BDD tool for TypeScript/React, and Flutter/Dart</a>

*My article in the official Flutter documentation*:

* <a href="https://flutter.dev/docs/development/ui/layout/constraints">Understanding constraints</a>
