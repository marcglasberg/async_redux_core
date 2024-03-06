// Developed by Marcelo Glasberg (2024) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/async_redux_core

import 'package:async_redux_core/src/user_exception_i18n.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';

import 'exception_code.dart';

/// The [UserException] represents an error the user could fix, like wrong typed
/// text, or missing internet connection.
///
/// Async Redux will capture [UserException]s to show them in dialogs
/// created with `UserExceptionDialog` or other UI you define in your widget
/// tree (see the explanation in the docs).
///
/// An [UserException] may have a [message] or an error [code] (if you provide
/// both, the message will be ignored), as well as an optional [cause], which
/// is a more specific root cause of the error. For example:
///
/// ```dart
/// throw UserException('Invalid email', cause: 'Must have at least 5 characters.');
/// ```
///
/// Method [titleAndContent] returns the title and content used in the error dialog.
/// If the error has both a [message] an a [cause], the title of the dialog will
/// be the [message], and its content will be the [cause]. Otherwise, the dialog
/// will be empty, and content will be the [message].
///
/// Alternatively, if you provide a [code] instead of a [message], this code must
/// be a subclass of type [ExceptionCode] that you define. In this case, the
/// message of the exception will be the string returned by
/// the [ExceptionCode.asText] method.
///
/// ---
///
/// You can define a special Matcher for your UserException, to use in your
/// tests. Create a test lib with this code:
///
/// ```
/// import 'package:matcher/matcher.dart';
/// const Matcher throwsUserException = Throws(const TypeMatcher<UserException>());
/// ```
///
/// Then use it in your tests:
/// ```
/// expect(() => someFunction(), throwsUserException);
/// ```
///
class UserException implements Exception {
  /// Some message shown to the user.
  final String? message;

  /// Another message which is the cause of the user-exception.
  final String? cause;

  /// Instead of [message] we may provide a code. This may be used for error message
  /// translations, and also to simplify receiving errors from web-services,
  /// cloud-functions etc.
  final ExceptionCode? code;

  /// Creates a [UserException], given a message [message] of type String,
  /// a [cause] of type String or [UserException], and an optional [code] of
  /// type [ExceptionCode]. All fields are optional, but usually at least
  /// the [message] or [code] is provided.
  const UserException(
    this.message, {
    this.code,
    this.cause,
  });

  /// Creates a [UserException], adding the given [cause].
  /// Note the added [cause] won't replace the original cause, but will be added to it.
  ///
  /// The added [cause] must be:
  /// - A [UserException]
  /// - A [String]
  /// - Or Null.
  UserException addCause(Object? cause) {
    //
    if (cause is String) {
      if (_ifHasMsgOrCode()) {
        return UserException(message, code: code, cause: joinCauses(this.cause, cause));
      }
      //
      else if (this.cause != null && this.cause!.isNotEmpty)
        return UserException(this.cause, cause: cause);
      //
      else
        return UserException(cause);
    }
    //
    if (cause is UserException) {
      cause = joinCauses(cause._msgOrCode(), cause.cause);
      return addCause(cause);
    }
    //
    else
      return this;
  }

  (String, String) titleAndContent() {
    if (_ifHasMsgOrCode()) {
      if (cause == null || cause!.isEmpty)
        return ('', _msgOrCode());
      else
        return (_msgOrCode(), cause ?? '');
    }
    //
    else if (cause != null && cause!.isNotEmpty)
      return ('', cause ?? '');
    //
    else
      return ('User Error', '');
  }

  /// Use this to set the locale used to translate the text "Reason:" used to explain the
  /// chain of causes in the [UserException]. The default is the current locale.
  ///
  /// If you remove the default locale with `setDefaultLocale(null)`,
  /// the default will be English of the Unites States.
  ///
  /// Note: This uses the `i18n_extension_core` package from https://pub.dev/packages/i18n_extension_core
  /// If you already use that package (or its Flutter brother `i18n_extension` from https://pub.dev/packages/i18n_extension)
  /// in your app, there is no need to use [UserException.setDefaultLocale]
  /// because the locale here will already work as expected.
  static void setDefaultLocale(String? localeStr) => DefaultLocale.set(localeStr);

  /// Joins the given strings, such as the second is the reason for the first.
  /// Will return a message such as "first\n\nReason: second".
  /// You can change this variable to inject another way to join them.
  static var joinCauses = (
    String? first,
    String? second,
  ) {
    if (first == null || first.isEmpty) return second ?? "";
    if (second == null || second.isEmpty) return first;
    return "$first${defaultJoinString()}$second";
  };

  /// The default text to join the causes in a string.
  /// You can change this variable to inject another way to join them.
  static var defaultJoinString = () => "\n\n${"Reason".i18n}: ";

  /// If there is a [code], and this [code] has a non-empty text returned by
  /// [ExceptionCode.asText] in the given [StringLocale], return this text.
  /// Otherwise, if the [message] is a non-empty text, return this [message].
  /// Otherwise, if there is a [code], return the [code] itself.
  /// Otherwise, return an empty text.
  String _msgOrCode() {
    String? codeAsText = code?.asText();
    if (codeAsText != null && codeAsText.isNotEmpty) return codeAsText;
    if (message != null && message!.isNotEmpty) return message!;
    return code?.toString() ?? "";
  }

  bool _ifHasMsgOrCode() => (message != null && message!.isNotEmpty) || code != null;

  @override
  String toString() => 'UserException{' + joinCauses(_msgOrCode(), cause) + '}';

  /// Creates a [UserException] from a JSON object.
  ///
  /// Important: The [cause] and the [code] will be represented as Strings,
  /// and [_onOk] and [_onCancel] will be ignored. This means the [fromJson] method
  /// may not be able to reconstruct the original exception.
  ///
  /// ---
  /// Use with Celest (https://celest.dev/):
  ///
  /// Currently you can't import Async Redux in the backend part of Celest, because it uses Flutter.
  /// Once I move this [UserException] class into a separate Dart-only package called
  /// `async_redux_core`, you will be able to use it with Celest, as long as you export it
  /// from `celest/lib/exceptions.dart`:
  ///
  /// ```dart
  /// export 'package:async_redux_core/user_exception.dart;
  /// ```
  factory UserException.fromJson(Map<String, dynamic> json) {
    return UserException(
      json['msg'],
      cause: json['cause'],
      code: json['code'],
    );
  }

  /// Creates a JSON object from a [UserException].
  ///
  /// Important: The [cause] and the [code] will be represented as Strings,
  /// and [_onOk] and [_onCancel] will be ignored. This means the [fromJson] method
  /// may not be able to reconstruct the original exception.
  ///
  /// ---
  /// Use with Celest (https://celest.dev/):
  ///
  /// Currently you can't import Async Redux in the backend part of Celest, because it uses Flutter.
  /// Once I move this [UserException] class into a separate Dart-only package called
  /// `async_redux_core`, you will be able to use it with Celest, as long as you export it
  /// from `celest/lib/exceptions.dart`:
  ///
  /// ```dart
  /// export 'package:async_redux_core/user_exception.dart;
  /// ```
  Map<String, dynamic> toJson() => {
        'msg': message,
        if (cause != null) 'cause': cause.toString(),
        if (code != null) 'code': code.toString(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          cause == other.cause &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ cause.hashCode ^ code.hashCode;
}
