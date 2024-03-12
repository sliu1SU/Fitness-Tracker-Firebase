import 'package:flutter/material.dart';
import 'package:homework_five/diet_recorder_edit_form.dart';
import 'package:homework_five/view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:homework_five/diet_event.dart';

class DietRecorder extends StatefulWidget {
  const DietRecorder({super.key});

  @override
  State<DietRecorder> createState() => _DietRecorder();
}

class _DietRecorder extends State<DietRecorder> {
  String? dropdown;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController dietInputController = TextEditingController();
  final TextEditingController unitInputController = TextEditingController();
  final TextEditingController editValController = TextEditingController();
  Set<String> dietHistory = {};

  @override
  void initState() {
    super.initState();
    fetchDietHistory(); // Fetch diet history data when the widget is initialized
  }

  // create a function here
  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      DateTime curDatetime = DateTime.now();
      if (dietInputController.text.isNotEmpty) {
        // user text input higher priority
        DietEvent event = DietEvent(
          null,
          dietInputController.text,
          int.parse(unitInputController.text),
          curDatetime,
          0,
        );
        dietHistory.add(dietInputController.text);
        context.read<ViewModel>().addOneDietEvent(event);
      } else {
        // user did not enter new food in text box
        DietEvent event = DietEvent(
          null,
          dropdown!,
          int.parse(unitInputController.text),
          curDatetime,
          0,
        );
        context.read<ViewModel>().addOneDietEvent(event);
      }
      _formKey.currentState!.reset();
      // need to do manual reset coz of TextFormField bug
      dietInputController.clear();
      unitInputController.clear();
    }
  }

  Future<void> fetchDietHistory() async {
    try {
      // Fetch diet events from the database
      List<DietEvent> dietEvents = await context.read<ViewModel>().getAllDietEvents();

      // Extract diet names from diet events and update the diet history set
      setState(() {
        dietHistory = dietEvents.map((event) => event.diet).toSet();
      });
    } catch (e) {
      print('Error fetching diet history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetch data from db to populate diet history
    Future<List<DietEvent>> futureDietEvents = context.select<ViewModel, Future<List<DietEvent>>>(
            (viewModel) => viewModel.getAllDietEvents()
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
                children: [
                  // form widget to handle user inputs
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // diet text input
                        const Text("Enter a Diet", style: TextStyle(fontSize: 15),),
                        TextFormField(
                          key: const Key("dietFoodInput"),
                          controller: dietInputController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter a food...',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                // clear the text box
                                dietInputController.clear();
                              },
                            ),
                          ),
                          validator: (newValue) {
                            if (dropdown == null && (newValue == null || newValue.isEmpty)) {
                              return "You must enter a diet OR select a diet from \"Previous Diets\"!";
                            }
                            return null;
                          },
                        ),

                        // dropdown menu
                        if(dietHistory.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text("Previous Diets", style: TextStyle(fontSize: 15),),
                                DropdownButtonFormField(
                                  key: const Key("dietDropdown"),
                                  //style: const TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: '-select a value-',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: dietHistory.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item, style: const TextStyle(fontSize: 10)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newVal) {
                                    setState(() {
                                      dropdown = newVal;
                                    });
                                  },
                                  validator: (newValue) {
                                    if (dietInputController.text.isEmpty
                                        && dropdown == null) {
                                      return "You must select a diet OR enter a diet in \"Enter a Diet\"!";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                        // unit text input
                        const Text("Unit", style: TextStyle(fontSize: 15),),
                        TextFormField(
                          key: const Key("dietUnitInput"),
                          controller: unitInputController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter unit in integer...',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                // clear the text box
                                unitInputController.clear();
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

                        // submit button
                        ElevatedButton(
                            key: const Key("dietSubmitBt"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black87,
                            ),
                            onPressed: _onSavePressed,
                            // child - put something in the button, EX: save
                            child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold),)
                        ),
                      ],
                    ),
                  ),

                  // cheating a bit here coz i cannot fig it out
                  // Form(
                  //     key: _formKey2,
                  //     child: Column(
                  //       children: [
                  //         const Text("Editing - New Unit", style: TextStyle(fontSize: 15),),
                  //         TextFormField(
                  //           controller: editValController,
                  //           keyboardType: TextInputType.number,
                  //           style: const TextStyle(fontSize: 8),
                  //           decoration: InputDecoration(
                  //             border: const OutlineInputBorder(),
                  //             hintText: 'Enter new unit and click edit button at the corresponding entry...',
                  //             suffixIcon: IconButton(
                  //               icon: const Icon(Icons.clear),
                  //               onPressed: () {
                  //                 // clear the text box
                  //                 editValController.clear();
                  //               },
                  //             ),
                  //           ),
                  //           validator: (newValue) {
                  //             if (newValue == null || newValue.isEmpty) {
                  //               return "New unit must not be blank!";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ],
                  //     )
                  // ),

                  // column widget to print a list of food and dates history
                  FutureBuilder(
                      future: futureDietEvents,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          final dietEvents = snapshot.data!;
                          return Column(
                            children: dietEvents.map((event) => Row(
                              children: [
                                Text("${event.diet}  "),
                                Text("${event.unit}  "),
                                Text("${DateFormat().format(event.date)}  "),
                                IconButton(
                                  onPressed: () {
                                    context.read<ViewModel>().deleteOneDietEventById(event.id!);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                                IconButton(
                                  // onPressed: () {
                                  //   if (_formKey2.currentState!.validate()) {
                                  //     context.read<ViewModel>().updateOneDietEvent(event.id!, int.parse(editValController.text));
                                  //     _formKey2.currentState!.reset();
                                  //   }
                                  // },
                                  icon: const Icon(Icons.create),
                                  color: Colors.black,
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return DietRecorderEditForm(event);
                                      },
                                    );
                                  },
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
      )
    );
  }
}