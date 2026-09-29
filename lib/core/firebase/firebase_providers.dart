import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The default Cloud Firestore instance, exposed as a Riverpod dependency.
///
/// This exists so the rest of the app never calls
/// `FirebaseFirestore.instance` directly. Later milestones inject this through
/// repositories, which makes them trivial to test with a fake and keeps the
/// Firestore SDK out of the presentation layer.
///
/// Reading this before [FirebaseBootstrap.initialize] has completed throws;
/// that ordering is guaranteed by `main()`.
final Provider<FirebaseFirestore> firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
