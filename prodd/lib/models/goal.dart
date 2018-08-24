
import 'entity.dart';

class Goal extends Entity {
  Goal({
      String id, 
      this.title, 
      this.completeBy, 
      this.status,
      this.estimatedDuration
    }) 
    : super(id);

  String title;
  DateTime completeBy;
  GoalStatus status;
  Duration estimatedDuration;
  
}

// Careful - the order matters as GoalStatuses are saved to the database using their index number
enum GoalStatus {
  active,     // 0
  completed,  // 1
  deleted     // 2
}