
import 'package:prodd/models/entity.dart';

enum ChangeType {
  added,
  modified,
  removed,
}

class Change<E extends Entity> {

  Change({this.data, this.type, this.oldIndex, this.newIndex})
    : assert(type != null);

  final E data;
  final ChangeType type;
  final int oldIndex, newIndex;
}