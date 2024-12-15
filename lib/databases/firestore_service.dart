import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_shameer/models/login_model.dart';

String collection_ref = "login_details";

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Loginmodel> _loginRef;

  // Fix the constructor name
  FirestoreService() {
    _loginRef = _firestore.collection(collection_ref).withConverter<Loginmodel>(
          fromFirestore: (snapshot, options) =>
              Loginmodel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  // To get login details
  Stream<QuerySnapshot<Loginmodel>> getLogInDetails(String mobileNumber) {
    return _loginRef.where('mobile', isEqualTo: mobileNumber).snapshots();
  }

  // To post login details
  void addLogindetails(Loginmodel login) {
    _loginRef.add(login);
  }
}
