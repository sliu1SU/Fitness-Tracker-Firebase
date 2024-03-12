import 'package:flutter/material.dart';
import 'package:homework_five/view_model.dart';
import 'package:homework_five/workout_event.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkoutRecorder extends StatefulWidget {
  // constructor
  const WorkoutRecorder({super.key});

  @override
  State<WorkoutRecorder> createState() => _WorkoutRecorder();
}

class _WorkoutRecorder extends State<WorkoutRecorder> {
  String? selectedWorkout;
  final TextEditingController numController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> workouts = [
    'Bench press',
    'Cycling',
    'Pullup',
    'Pushups',
    'Pulldown',
    'Swimming',
    'Bicep curls',
    'Running'
  ];

  // create a function here
  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      DateTime curDatetime = DateTime.now();
      WorkoutEvent event = WorkoutEvent(
        null,
        selectedWorkout!,
        int.parse(numController.text),
        curDatetime,
        0,
      );
      context.read<ViewModel>().addOneWorkoutEvent(event);
      _formKey.currentState!.reset();
      // need to do manual reset because of TextFormField bug
      numController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetch data from db to populate emo history
    Future<List<WorkoutEvent>> futureWorkoutEvents = context.select<ViewModel, Future<List<WorkoutEvent>>>(
            (viewModel) => viewModel.getAllWorkoutEvents()
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
                children: [
                  Form(
                    key:_formKey,
                    child: Column(
                      children: [
                        // exercise dropdown
                        const Text(
                          "Exercise",
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: DropdownButtonFormField(
                            key: const Key("workoutDropdown"),
                            decoration: InputDecoration(
                              hintText: '-select a value-',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            //value: _selectedWorkout,
                            // array list item
                            items: workouts.map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item, style: const TextStyle(fontSize: 15)),
                            )).toList(),
                            // onchange function to capture user selection
                            onChanged: (String? newVal) {
                              setState(() {
                                selectedWorkout = newVal;
                              });
                            },
                            validator: (selectedWorkout) {
                              if (selectedWorkout == null) {
                                return "You must select an exercise from the list!";
                              }
                              return null;
                            },
                          ),
                        ),

                        // quantity textfield
                        const Text(
                          "Unit",
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TextFormField(
                            key: const Key("workoutUnitTextInput"),
                            controller: numController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Enter unit in integer...',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  // clear the text box
                                  numController.clear();
                                },
                              ),
                            ),
                            validator: (newValue) {
                              if (newValue == null || newValue.isEmpty) {
                                return "Unit must not be blank!";
                              }
                              return null;
                            },
                          ),
                        ),

                        // submit button
                        ElevatedButton(
                            key: const Key("workoutSubmitBt"),
                            onPressed: () {
                              _onSavePressed();
                            },
                            // child - put something in the button, EX: save
                            child: const Text("Save")
                        ),
                      ],
                    ),
                  ),

                  // print a list of emojis and dates
                  FutureBuilder(
                      future: futureWorkoutEvents,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          final workoutEvents = snapshot.data!;
                          return Column(
                            children: workoutEvents.map((event) => Row(
                              children: [
                                Text("${event.workout}  "),
                                Text("${event.unit}  "),
                                Text("${DateFormat().format(event.date)}  "),
                                IconButton(
                                  onPressed: () {
                                    context.read<ViewModel>().deleteOneWorkoutEventById(event.id!);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                )
                              ],
                            )).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return const Text('An error occurred trying to load your data and we have no idea what to do about it. Sorry.');
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                  ),
                ]
            )
        ),
      ),
    );
  }
}