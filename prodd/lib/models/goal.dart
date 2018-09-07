
import 'entity.dart';

class Goal extends Entity {
  Goal({
      String id, 
      this.title, 
      this.completeBy, 
      this.status,
      this.estimatedDuration,
      this.beginNotifications,
      this.notificationFrequency
    }) 
    : super(id);

  String title;
  DateTime completeBy, beginNotifications;
  GoalStatus status;
  Duration estimatedDuration;
  GoalNotificationFrequency notificationFrequency;
}

// Careful - the order matters as GoalStatuses are saved to the database using their index number
enum GoalStatus {
  active,     // 0
  completed,  // 1
  deleted     // 2
}

enum GoalNotificationFrequency {
  none,           // 0
  twiceADay,      // 1
  daily,          // 2
  everyOtherDay   // 3
}