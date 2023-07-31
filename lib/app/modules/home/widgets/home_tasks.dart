import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/models/task_model.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';
import 'package:todo_list_provider/app/modules/home/widgets/task.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Selector<HomeController, String>(
          selector: (context, controller) {
            return controller.filterSelected.description;
          },
          builder: (context, value, child) {
            return Text(
              'TAS\'S DE ${value}',
              style: context.titleStyle,
            );
          },
        ),
        Column(
          children: context
              .select<HomeController, List<TaskModel>>(
                  (controller) => controller.filteredtasks)
              .map((t) => Task(model: t,))
              .toList(),
        )
      ],
    ));
  }
}
