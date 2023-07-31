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
  List<TaskModel> alltasks = [];
  List<TaskModel> filteredtasks = [];
  DateTime? initialDateOfWeek;
  DateTime? selectedDay;

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

  Future<void> findTasks({required TaskFilterEnum filter}) async{
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;

    switch(filter){
      case TaskFilterEnum.today:
      tasks = await _taskService.getToday();
      break;
      case TaskFilterEnum.tomorrow:
      tasks = await _taskService.getTomorrow();
      break;
      case TaskFilterEnum.week:
      final weekModel = await _taskService.getWeek();
      initialDateOfWeek = weekModel.startDate;
      tasks = weekModel.tasks;
      break;
    }
    filteredtasks = tasks;
    alltasks = tasks;

    if(filter == TaskFilterEnum.week){
      if(selectedDay != null){
        filterByDay(initialDateOfWeek!);
      }else if(initialDateOfWeek != null){
        filterByDay(initialDateOfWeek!);
      }else{
        selectedDay = null;
      }
    }

    hideLoading();
    notifyListeners();
  }
  void filterByDay(DateTime date) {
    selectedDay = date;
    filteredtasks = alltasks.where((task) {
      return task.dateTime == date;
    }).toList();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }
}
