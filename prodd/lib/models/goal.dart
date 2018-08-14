
import 'package:prodd/models/base_model.dart';

class Goal extends Entity {
  Goal({String id, this.title, this.completeBy}) : super(id);

  final String title;
  final DateTime completeBy;
}