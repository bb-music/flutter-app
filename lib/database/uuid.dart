import 'package:uuid/uuid.dart';

const uuid = Uuid();

String generateUUID() {
  return uuid.v4();
}
