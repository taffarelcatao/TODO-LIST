
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;


  DefaultListenerNotifier({
    required this.changeNotifier,
   
  });

  void listner({
    required BuildContext context,
    required SuccessVoidCallback? successCallback,
    SuccessVoidCallback? errorCallback,
  }){
    changeNotifier.addListener(() { 
      if(changeNotifier.loading){
        Loader.show(context);
      }else{
        Loader.hide();
      }

      if(changeNotifier.hasErro){
        if(errorCallback != null){
          errorCallback(changeNotifier, this);
        }
        Messages.of(context).showError(changeNotifier.error ?? 'Erro interno');
      }else if(changeNotifier.isSuccess){
        if(successCallback != null){
          successCallback(changeNotifier, this);
        }
      }
    });
  }

  void dispose(){
    changeNotifier.removeListener(() { });
  }
}

typedef SuccessVoidCallback = void Function(
  DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance
);

typedef ErrorVoidCallback = void Function(
  DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance
);
