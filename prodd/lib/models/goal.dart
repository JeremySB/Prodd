
import 'package:prodd/models/base_model.dart';

class Goal extends Entity {
  Goal({
      String id, 
      this.title, 
      this.completeBy, 
      this.status
    }) 
    : super(id);

  String title;
  DateTime completeBy;
  GoalStatus status;
  
}

// Careful - the order matters as GoalStatus's are saved to the database using their index number
enum GoalStatus {
  active, 
  completed, 
  deleted
}