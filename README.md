[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

[![pub package](https://img.shields.io/pub/v/async_redux_core.svg)](https://pub.dartlang.org/packages/async_redux_core  )

# async_redux_core

_This is the core Dart-only package for
the [async_redux](https://pub.dev/packages/async_redux) package._

## In your Flutter app:

* Do NOT include this core package directly.

  Instead, go to the [async_redux](https://pub.dev/packages/async_redux) package
  which already exports this core code, plus provides Flutter related code.

## In your Dart server or Dart-only code:

* For the moment, this Dart-only package simply contains the `UserException`
  class, and nothing more.

    * If you are creating code for a Dart server (backend)
      like [Serverpod](https://serverpod.dev/),
      or [Celest](https://celest.dev/),
      or developing some other Dart-only package that does not depend on
      Flutter,
      then you can use this package directly:

      ```
      import 'package:async_redux_core/async_redux_core.dart';
      ```                                                              

  > Note: When using Serverpod or Celest, you can throw `UserException` in your
  backend code, and that exception will automatically be thrown in the frontend.
  As long as the Serverpod or Celest cloud function is called inside redux
  actions, Async Redux will display the exception message to the user in a
  dialog (or other UI element that you can customize). This can also be used
  with [package i18n_extension_core](https://pub.dartlang.org/packages/i18n_extension_core)
  to make sure the error message gets translated to the user's language.
  For example: `UserException('The password you typed is invalid'.i18n);` in the
  backend, will reach the frontend already translated as
  `UserException('La contraseña que ingresaste no es válida')` if the user
  device is in Spanish.

  > Note: For this to work in Serverpod, after you import `async_redux_core`
  in the `pubspec.yaml` file of the server project, you must add the
  `UserException` class to your `generator.yaml` file, in its `extraClasses`
  section:

  ```
  type: server

  client_package_path: ../my_client
  server_test_tools_path: test/integration/test_tools

  modules:
    serverpod_auth:
      nickname: auth
  
  extraClasses:
    - package:async_redux_core/async_redux_core.dart:UserException
  ```

## Documentation

Go to [async_redux](https://pub.dev/packages/async_redux) to read the docs.

***

## By Marcelo Glasberg

<a href="https://glasberg.dev">_glasberg.dev_</a>
<br>
<a href="https://github.com/marcglasberg">_github.com/marcglasberg_</a>
<br>
<a href="https://www.linkedin.com/in/marcglasberg/">
_linkedin.com/in/marcglasberg/_</a>
<br>
<a href="https://twitter.com/glasbergmarcelo">_twitter.com/glasbergmarcelo_</a>
<br>
<a href="https://stackoverflow.com/users/3411681/marcg">
_stackoverflow.com/users/3411681/marcg_</a>
<br>
<a href="https://medium.com/@marcglasberg">_medium.com/@marcglasberg_</a>
<br>

*My article in the official Flutter documentation*:

* <a href="https://flutter.dev/docs/development/ui/layout/constraints">
  Understanding constraints</a>

*The Flutter packages I've authored:*

* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/i18n_extension">i18n_extension</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">
  network_to_file_image</a>
* <a href="https://pub.dev/packages/image_pixels">image_pixels</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a>
* <a href="https://pub.dev/packages/back_button_interceptor">
  back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a>
* <a href="https://pub.dev/packages/animated_size_and_fade">
  animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">
  assorted_layout_widgets</a>
* <a href="https://pub.dev/packages/weak_map">weak_map</a>
* <a href="https://pub.dev/packages/themed">themed</a>
* <a href="https://pub.dev/packages/bdd_framework">bdd_framework</a>
* <a href="https://pub.dev/packages/tiktoken_tokenizer_gpt4o_o1">
  tiktoken_tokenizer_gpt4o_o1</a>

*My Medium Articles:*

* <a href="https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6">
  Async Redux: Flutter’s non-boilerplate version of Redux</a> 
  (versions: <a href="https://medium.com/flutterando/async-redux-pt-brasil-e783ceb13c43">
  Português</a>)
* <a href="https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9">
  i18n_extension</a> 
  (versions: <a href="https://medium.com/flutterando/qual-a-forma-f%C3%A1cil-de-traduzir-seu-app-flutter-para-outros-idiomas-ab5178cf0336">
  Português</a>)
* <a href="https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2">
  Flutter: The Advanced Layout Rule Even Beginners Must Know</a> 
  (versions: <a href="https://habr.com/ru/post/500210/">русский</a>)
* <a href="https://medium.com/flutter-community/the-new-way-to-create-themes-in-your-flutter-app-7fdfc4f3df5f">
  The New Way to create Themes in your Flutter App</a> 
