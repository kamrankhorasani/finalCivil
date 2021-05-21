import 'package:civil_project/logic/+workerrole_cubit/workerrole_cubit.dart';
import 'package:civil_project/logic/accident_cubit/accident_cubit.dart';
import 'package:civil_project/logic/activity_cubit/activity_cubit.dart';
import 'package:civil_project/logic/add_extraction_cubit/add_extraction_cubit.dart';
import 'package:civil_project/logic/add_importation_cubit/add_importation_cubit.dart';
import 'package:civil_project/logic/add_provider_cubit/add_provider_cubit.dart';
import 'package:civil_project/logic/addallextraction_cubit/alladdextraction_cubit.dart';
import 'package:civil_project/logic/cartable_cubit/cartable_cubit.dart';
import 'package:civil_project/logic/checklist_cubit/checklist_cubit.dart';
import 'package:civil_project/logic/alarms_cubit/alarms_cubit.dart';
import 'package:civil_project/logic/feed_cubit/feed_cubit.dart';
import 'package:civil_project/logic/homescreen_cubit/homescreen_cubit.dart';
import 'package:civil_project/logic/inquiry_cubit/inquiry_cubit.dart';
import 'package:civil_project/logic/inspection_cubit/inspection_cubit.dart';
import 'package:civil_project/logic/itemdetails2_cubit/itemdeteils2_cubit.dart';
import 'package:civil_project/logic/machinary_cubit/machinary_cubit.dart';

import 'package:civil_project/logic/media_cubit/media_cubit.dart';
import 'package:civil_project/logic/payment_cubit/payment_cubit.dart';
import 'package:civil_project/logic/permit_cubit/permit_cubit.dart';
import 'package:civil_project/logic/program_cubit/program_cubit.dart';
import 'package:civil_project/logic/rent_cubit/rent_cubit.dart';
import 'package:civil_project/logic/session_cubit/session_cubit.dart';
import 'package:civil_project/logic/weather_cubit/weather_cubit.dart';
import 'package:civil_project/logic/worker_cubit/worker_cubit.dart';
import 'package:civil_project/screens/alarm/alarm.dart';
import 'package:civil_project/screens/cartable/add_cartable_screen.dart';
import 'package:civil_project/screens/cartable/item_details2.dart';
import 'package:civil_project/screens/feeds/feedDetail.dart';
import 'package:civil_project/screens/homee/options/addextract/addextract.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/screens/homee/home_screen.dart';
import 'package:civil_project/screens/homee/options/accident/accident.dart';
import 'package:civil_project/screens/homee/options/activity/activities.dart';
import 'package:civil_project/screens/homee/options/checklist/checklist.dart';
import 'package:civil_project/screens/homee/options/inquiry/inquiry.dart';
import 'package:civil_project/screens/homee/options/inspection/inspection.dart';
import 'package:civil_project/screens/homee/options/machinary/machinary.dart';
import 'package:civil_project/screens/homee/options/materials/materials.dart';
import 'package:civil_project/screens/homee/options/media/media.dart';
import 'package:civil_project/screens/homee/options/payment/payment.dart';
import 'package:civil_project/screens/homee/options/permit/permit.dart';
import 'package:civil_project/screens/homee/options/programs/programs.dart';
import 'package:civil_project/screens/homee/options/rent/rent.dart';
import 'package:civil_project/screens/homee/options/session/sessions.dart';
import 'package:civil_project/screens/homee/options/subcontractor/subcontractor.dart';
import 'package:civil_project/screens/homee/options/weather/weather.dart';
import 'package:civil_project/screens/homee/options/workrole/work_role.dart';
import 'package:civil_project/screens/login/digitcode.dart';
import 'package:civil_project/screens/login/login.dart';
import 'package:civil_project/screens/main_screen.dart';
import 'package:civil_project/screens/storage/add_importation.dart';
import 'package:civil_project/screens/storage/add_provider.dart';
import 'package:civil_project/screens/storage/storeage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/storage':
        return MaterialPageRoute(builder: (_) => StorageScreen());
        break;
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
        break;
      case '/digitcode':
        return MaterialPageRoute(
            builder: (_) => DigiCodeScreen(
                  mobileNumber: args,
                ));
        break;
      case '/homescreen':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => HomescreenCubit(), child: HomeScreen()));
        break;
      case '/mainscreen':
        return MaterialPageRoute(builder: (_) => MainScreen());
        break;
      case '/homeitems':
        return MaterialPageRoute(builder: (_) => HomeItems());
        break;

      case '/feeddetail':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                  value: FeedCubit(),
                  child: FeedDetail(
                    tbl: args['tbl'],
                    activityList: args['activityList'],
                    fromDate: args['fromDate'],
                    toDate: args['toDate'],
                  )));
        }

        break;
      case '/accident':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AccidentCubit(), child: Accident()));
        break;
      case '/addcartable':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => CartableCubit(),
                  child: AddCartableScreen(),
                ));
        break;

      case '/itemdetails2':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => Itemdeteils2Cubit(),
                  child: ItemDetails2(
                    itemId: args,
                  ),
                ));
        break;
      case '/activity':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => ActivityCubit(), child: Activity()));
        break;
      case '/checklist':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => ChecklistCubit(), child: CheckList()));
        break;

      case '/inquiry':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => InquiryCubit(), child: Inquiry()));
        break;
      case '/workrole':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => WorkerroleCubit(), child: WorkerRole()));
        break;
      case '/inspection':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => InspectionCubit(), child: Inspection()));
        break;
      case "/addextraction":
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AlladdextractionCubit(),
                  child: Extractions(),
                ));
        break;
      case '/materials':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AddExtractionCubit(), child: Materials()));
        break;
      case '/machinary':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => MachinaryCubit(),
                  child: Machinarys(),
                ));
        break;
      case '/media':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => MediaCubit(), child: Media()));
        break;
      case '/payment':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => PaymentCubit(), child: Payment()));
        break;
      case '/permit':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => PermitCubit(), child: Permit()));
        break;
      case '/program':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => ProgramCubit(), child: Program()));
        break;
      case '/session':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => SessionCubit(), child: Session()));
        break;

      case "/rent":
        return MaterialPageRoute(
            builder: (_) =>
                BlocProvider(create: (context) => RentCubit(), child: Rent()));
        break;

      case '/weather':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => WeatherCubit(), child: Weather()));
        break;
      case '/subcontractor':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: WorkerCubit(), child: SubContractor()));
        break;
      case '/addprovider':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AddProviderCubit(), child: AddProvider()));
        break;
      case '/alarm':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AlarmsCubit(),
                  child: AlarmScreen(),
                ));
        break;
      case '/addimportation':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AddImportationCubit(),
                child: AddImportation()));
        break;
      default:
        return null;
    }
    return null;
  }
}
