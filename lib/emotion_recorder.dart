import 'package:flutter/material.dart';
import 'package:homework_five/emotion_event.dart';
import 'package:homework_five/view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmotionRecorder extends StatefulWidget {
  // constructor
  const EmotionRecorder({super.key});

  @override
  State<EmotionRecorder> createState() => _EmotionRecorder();
}

class _EmotionRecorder extends State<EmotionRecorder> {
  // data structure to store all 24 hard-coded emoji
  final List<String> emojis = [
    "😀",
    "😍",
    "🥳",
    "🚀",
    "🌟",
    "🎉",
    "🎈",
    "🐱",
    "🐶",
    "🌺",
    "🍕",
    "🍦",
    "🎸",
    "🎮",
    "🚗",
    "🌈",
    "❤️",
    "💡",
    "📚",
    "⚽",
    "🎨",
    "🍔",
    "🚲",
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedValue;
  
  void _onSavePressed() {
    // create an emoji event and add it to the list for rendering
    if (_formKey.currentState!.validate()) {
      EmotionEvent event = EmotionEvent(
        null,
        selectedValue!,
        DateTime.now(),
        0,
      );
      context.read<ViewModel>().addOneEmotionEvent(event);
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetch data from db to populate emo history
    Future<List<EmotionEvent>> futureEmotionEvents = context.select<ViewModel, Future<List<EmotionEvent>>>(
            (viewModel) => viewModel.getAllEmotionEvents()
    );
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // drop down button
                    const Text("Select an emoji"),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DropdownButtonFormField(
                        key: const Key("emojiDropdown"),
                        decoration: InputDecoration(
                          hintText: '-select a value-',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        //value: selectedValue,
                        // array list item
                        items: emojis.map((item) => DropdownMenuItem<String>(
                          key: const Key("dietHistoryDropdownItem"),
                          value: item,
                          child: Text(item, style: const TextStyle(fontSize: 20)),
                        )).toList(),
                        // onchange function to capture user selection
                        onChanged: (String? newValue) {
                          // logging user input
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        validator: (newVal) {
                          if (selectedValue == null) {
                            return "You must select an emoji from the list!";
                          }
                          return null;
                        },
                      ),
                    ),

                    // submit button
                    ElevatedButton(
                        key: const Key("emojiSubmitBt"),
                        onPressed: _onSavePressed,
                        // child - put something in the button, EX: save
                        child: const Text("Save")
                    ),
                  ],
                ),
              ),

              // print a list of emojis and dates history
              FutureBuilder(
                  future: futureEmotionEvents,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      final emotionEvents = snapshot.data!;
                      return Column(
                        children: emotionEvents.map((event) => Row(
                          children: [
                            Text("${event.emoji}  "),
                            Text("${DateFormat().format(event.date)}  "),
                            IconButton(
                              onPressed: () {
                                context.read<ViewModel>().deleteOneEmotionEventById(event.id!);
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
            ],
          ),
        )
    );
  }
}