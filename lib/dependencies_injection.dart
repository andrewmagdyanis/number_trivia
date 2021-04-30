import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_concerete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia_feature/domain/repositories/number_trivia_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => NumberTriviaBloc(
        random: sl(),
        concrete: sl(),
        inputConverter: sl(),
      ));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  sl.registerLazySingleton(() => InputConverter());

  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      netWorkInfo: sl(),
      numberTriviaLocalDataSource: sl(),
      numberTriviaRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<NetWorkInfo>(() => NetworkInfoImpl(dataConnectionChecker: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPref: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(httpClient: sl()));

  // api
  final sp = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => sp);
}
