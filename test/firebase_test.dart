import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heres_the_move/core/errors/app_exception.dart';
import 'package:heres_the_move/core/firebase/firebase_bootstrap.dart';
import 'package:heres_the_move/firebase_options.dart';

Future<String> _read(String path) => File(path).readAsString();

/// Strips `//` comments so the rules assertions test real rules rather than the
/// prose that documents them.
String _withoutComments(String rules) =>
    rules.split('\n').map((line) => line.split('//').first).join('\n');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('generated Firebase configuration', () {
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('Android options point at the intended Firebase project', () {
      final options = DefaultFirebaseOptions.android;

      expect(options.projectId, 'heres-the-move');
      expect(options.appId, '1:1048485800134:android:a412675e2fe239ed3b4fc7');
      expect(options.messagingSenderId, '1048485800134');
    });

    test('iOS options point at the intended project and bundle id', () {
      final options = DefaultFirebaseOptions.ios;

      expect(options.projectId, 'heres-the-move');
      expect(options.appId, '1:1048485800134:ios:6dc4b7aede349e883b4fc7');
      // The bundle identifier must match ios/Runner.xcodeproj exactly, or
      // Firebase rejects the app at runtime.
      expect(options.iosBundleId, 'com.roj.heresTheMove');
    });

    test('currentPlatform resolves to Android on Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(
        DefaultFirebaseOptions.currentPlatform,
        DefaultFirebaseOptions.android,
      );
    });

    test('currentPlatform resolves to iOS on iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      expect(
        DefaultFirebaseOptions.currentPlatform,
        DefaultFirebaseOptions.ios,
      );
    });

    test('currentPlatform refuses platforms this app does not ship', () {
      // Firebase is Android/iOS only. A desktop build must fail loudly rather
      // than silently start with no backend.
      for (final platform in [
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        debugDefaultTargetPlatformOverride = platform;

        expect(
          () => DefaultFirebaseOptions.currentPlatform,
          throwsA(isA<UnsupportedError>()),
          reason: '$platform has no Firebase configuration',
        );
      }
    });
  });

  group('native client configuration matches the settled identifiers', () {
    test('google-services.json targets com.roj.heres_the_move', () async {
      final json = await _read('android/app/google-services.json');

      expect(json, contains('com.roj.heres_the_move'));
      expect(json, contains('heres-the-move'));
      expect(json, isNot(contains('genroj')));
    });

    test('GoogleService-Info.plist targets com.roj.heresTheMove', () async {
      final plist = await _read('ios/Runner/GoogleService-Info.plist');

      expect(plist, contains('com.roj.heresTheMove'));
      expect(plist, contains('heres-the-move'));
      expect(plist, isNot(contains('genroj')));
    });

    test('firebase_options.dart carries no stale identifier', () async {
      final source = await _read('lib/firebase_options.dart');

      expect(source, contains('heres-the-move'));
      expect(source, isNot(contains('genroj')));
    });
  });

  group('FirebaseBootstrap', () {
    setUp(FirebaseBootstrap.resetForTesting);
    tearDown(FirebaseBootstrap.resetForTesting);

    test('reports that it has not run yet', () {
      expect(FirebaseBootstrap.isInitialized, isFalse);
    });

    test(
      'translates a backend failure into a user-safe AppException',
      () async {
        const channel = MethodChannel('plugins.flutter.io/firebase_core');
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

        messenger.setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(
            code: 'firebase-core/initialization-failed',
            message: 'raw internal detail that must never reach a user',
          );
        });
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

        await expectLater(
          FirebaseBootstrap.initialize(),
          throwsA(
            isA<AppException>()
                .having(
                  (e) => e.message,
                  'user-facing message',
                  isNot(contains('raw internal detail')),
                )
                .having((e) => e.cause, 'diagnostic cause', isNotNull)
                .having((e) => e.stackTrace, 'stack trace', isNotNull),
          ),
        );

        expect(
          FirebaseBootstrap.isInitialized,
          isFalse,
          reason: 'a failed initialisation must not look successful',
        );
      },
    );

    test('does not remain stuck after a failure', () async {
      // The first attempt fails...
      await expectLater(
        FirebaseBootstrap.initialize(
          options: const FirebaseOptions(
            apiKey: 'key',
            appId: 'app',
            messagingSenderId: 'sender',
            projectId: 'heres-the-move',
          ),
        ),
        throwsA(isA<AppException>()),
      );

      // ...so a second attempt must actually try again rather than replaying
      // the cached failure.
      await expectLater(
        FirebaseBootstrap.initialize(
          options: const FirebaseOptions(
            apiKey: 'key',
            appId: 'app',
            messagingSenderId: 'sender',
            projectId: 'heres-the-move',
          ),
        ),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('Firestore security rules posture', () {
    late String rules;
    late String active;

    setUpAll(() async {
      rules = await _read('firestore.rules');
      active = _withoutComments(rules);
    });

    test('declare rules version 2', () {
      expect(rules.trimLeft(), startsWith("rules_version = '2';"));
    });

    test('deny by default via a root catch-all', () {
      expect(
        active,
        contains('match /{document=**} {'),
        reason: 'without the catch-all, unlisted collections are exposed',
      );
    });

    test('never grant open access', () {
      expect(active, isNot(contains('if true')));
      expect(
        active,
        isNot(contains('allow read, write: if request.auth != null')),
        reason: 'a database-wide authenticated rule is not owner-scoped',
      );
    });

    test('every allow statement is currently denied', () {
      final allowLines = active
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.startsWith('allow '))
          .toList();

      expect(allowLines, isNotEmpty);
      for (final line in allowLines) {
        expect(
          line,
          endsWith('if false;'),
          reason: 'rules must stay denied until Milestone 3: $line',
        );
      }
    });

    test('prepares user-owned data for owner-scoped access later', () {
      // The structure exists so Milestone 3 flips a condition rather than
      // inventing collections under pressure.
      for (final path in [
        '/users/{userId}',
        '/users/{userId}/partner/{document=**}',
        '/users/{userId}/cycle/periods/{periodId}',
        '/users/{userId}/moveCompletions/{completionId}',
        '/users/{userId}/missions/{userMissionId}',
      ]) {
        expect(active, contains('match $path'), reason: '$path is missing');
      }

      expect(
        rules,
        contains('request.auth.uid == userId'),
        reason: 'the intended ownership check should be documented in place',
      );
    });

    test('keeps global content unwritable by clients', () {
      for (final collection in [
        'moves',
        'missions',
        'messageSuggestions',
        'appConfig',
      ]) {
        expect(
          active,
          contains('match /$collection/{'),
          reason: '$collection has no explicit rule',
        );
      }
    });
  });

  group('Firebase project files', () {
    test('firebase.json wires the Firestore rules and indexes', () async {
      final json = await _read('firebase.json');

      expect(json, contains('"rules": "firestore.rules"'));
      expect(json, contains('"indexes": "firestore.indexes.json"'));
    });

    test('.firebaserc pins the intended project', () async {
      final rc = await _read('.firebaserc');

      expect(rc, contains('"default": "heres-the-move"'));
    });

    test('no server credentials were committed', () async {
      // Service-account keys are the one Firebase artefact that genuinely
      // grants privileged access. None may ever appear in the tree.
      final offenders = <String>[];
      await for (final entity in Directory(
        '.',
      ).list(recursive: true, followLinks: false)) {
        if (entity is! File) continue;
        final path = entity.path.replaceAll(r'\', '/');
        if (path.startsWith('build/') || path.contains('/.git/')) continue;
        if (path.contains('service-account') ||
            path.endsWith('.jks') ||
            path.endsWith('.keystore') ||
            path.endsWith('.p12')) {
          offenders.add(path);
        }
      }

      expect(offenders, isEmpty);
    });
  });
}
