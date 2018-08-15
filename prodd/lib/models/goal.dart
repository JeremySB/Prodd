
import 'package:prodd/models/base_model.dart';

class Goal extends Entity {
  Goal({String id, this.title, this.completeBy}) : super(id);

  String title;
  DateTime completeBy;
}