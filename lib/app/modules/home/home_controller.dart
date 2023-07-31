import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/models/task_model.dart';
import 'package:todo_list_provider/app/models/total_tasks_model.dart';
import 'package:todo_list_provider/app/models/week_task_model.dart';
import 'package:todo_list_provider/app/services/tasks/tasks_service.dart';

class HomeController extends DefaultChangeNotifier {
  final TasksService _taskService;
  var filterSelected = TaskFilterEnum.today;
  TotalTasksModel? todayTotaltasks;
  TotalTasksModel? tomorrowTotalTasks;
  TotalTasksModel? weekTotalTasks;

  HomeController({required TasksService tasksService})
      : _taskService = tasksService;

  Future<void> loadTotalTasks() async {
    final alltasks = await Future.wait([
      _taskService.getToday(),
      _taskService.getTomorrow(),
      _taskService.getWeek()
    ]);

    final todayTasks = alltasks[0] as List<TaskModel>;
    final tomorrowTasks = alltasks[1] as List<TaskModel>;
    final weekTasks = alltasks[2] as WeekTaskModel;

    todayTotaltasks = TotalTasksModel(
      totalTasks: todayTasks.length,
      totalTasksFinish: todayTasks.where((task) => task.finished).length,
    );

    tomorrowTotalTasks = TotalTasksModel(
      totalTasks: tomorrowTasks.length,
      totalTasksFinish: tomorrowTasks.where((task) => task.finished).length,
    );

    weekTotalTasks = TotalTasksModel(
      totalTasks: weekTasks.tasks.length,
      totalTasksFinish: weekTasks.tasks.where((task) => task.finished).length,
    );
    notifyListeners();
  }
}
