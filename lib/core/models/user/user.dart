import '../../exceptions/null_attribute_exception.dart';

/// [User] is a class that represents the user object.
/// Used in [loginUserWithEmailAndPassword], [signUpUserWithEmailAndPassword]
/// and in [authWithGoogle].
class User {
  User({
    this.password,
    this.email,
    this.name,
    this.imageURI,
    this.uuid,
  })  : assert(password != null, throw NullAttributeException('password')),
        assert(email != null, throw NullAttributeException('email')),
        assert(name != null, throw NullAttributeException('name')),
        assert(imageURI != null, throw NullAttributeException('imageURI')),
        assert(uuid != null, throw NullAttributeException('uuid'));

  String name;
  String password;
  String email;
  String imageURI;
  String uuid;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'favoriteSongs': [],
      'type': 'Email',
      'imageURI': imageURI,
      'uuid': uuid,
    };

    return map;
  }

  Map<String, dynamic> toMapGoogle() {
    final mapGoogle = {
      'name': name,
      'email': email,
      'favoriteSongs': [],
      'type': 'Google',
      'imageURI': imageURI,
      'uuid': uuid,
    };

    return mapGoogle;
  }

  Map<String, dynamic> toMapFacebook() {
    final mapFacebook = {
      'name': name,
      'email': email,
      'favoriteSongs': [],
      'type': 'Facebook',
      'imageURI': imageURI,
      'uuid': uuid,
    };

    return mapFacebook;
  }
}
