import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import '../components/grocery_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/grocery_item.dart';

class GroceryItemScreen extends StatefulWidget {

  final Function(GroceryItem)? onCreate;

  final Function(GroceryItem)? onUpdate;

  final GroceryItem? originalItem;

  final bool isUpdating;

  const GroceryItemScreen({
    Key? key,
    this.onCreate,
    this.onUpdate,
    this.originalItem
  }) : isUpdating = (originalItem != null), super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroceryItemScreenState();
  }
}

class _GroceryItemScreenState extends State<GroceryItemScreen> {
  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime? _dueDate = DateTime.now();
  TimeOfDay? _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  @override
  void initState() {
    if (widget.originalItem != null) {
      final item = widget.originalItem!;
      _nameController.text = item.name;
      _name = item.name;
      _currentSliderValue = item.quantity;
      _importance = item.importance;
      _currentColor = item.color;
      final date = item.date;
      _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
      _dueDate = date;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final groceryItem = GroceryItem(
                id: widget.originalItem?.id ?? const Uuid().v1(),
                name: _nameController.text, 
                importance: _importance, 
                color: _currentColor, 
                quantity: _currentSliderValue, 
                date: DateTime(_dueDate!.year, _dueDate!.month, 
                _dueDate!.day, _timeOfDay!.hour, _timeOfDay!.minute),
              );

              if (widget.isUpdating) {
                widget.onUpdate!(groceryItem);
              } else {
                widget.onCreate!(groceryItem);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
        elevation: 0.0,
        title: Text(
          'Grocery Item',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildNameField(),
            buildImportanceField(),
            buildDateField(context),
            buildTimeField(context),
            buildColorPicker(context),
            buildQantityField(),
            buildGroceryTile(),
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Name',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
            hintText: 'E.g. Apples, Banana, 1 Bag of salt',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImportanceField() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Importance',
            style: GoogleFonts.lato(fontSize: 28.0),
          ),

          Wrap(
            spacing: 10.0,
            children: [
              buildChoiceChip(
                chipLabel: 'Low', targetImportance: Importance.low),
              buildChoiceChip(chipLabel: 'Medium', 
                targetImportance: Importance.medium),
              buildChoiceChip(chipLabel: 'High', 
                targetImportance: Importance.high),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChoiceChip({
    required String chipLabel, 
    required Importance targetImportance }) {
    return ChoiceChip(
      selected: _importance == targetImportance,
      label: Text(
        chipLabel,
        style: const TextStyle(color: Colors.white),
      ),
      selectedColor: Colors.black,
      onSelected: (selected) {
        setState(() {
          _importance = targetImportance;
        });
      },
    );
  }

  Widget buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: GoogleFonts.lato(fontSize: 28.0),
              ),

              TextButton(
                onPressed: () async {
                  final currentDate = DateTime.now();
                  final selectedDate = await showDatePicker(
                    context: context, 
                    initialDate: currentDate, 
                    firstDate: currentDate, 
                    lastDate: DateTime(currentDate.year + 5),
                  );

                  setState(() {
                    if (selectedDate != null) {
                      _dueDate = selectedDate;
                    }
                  });
                },
                child: const Text('Select'),
              ),
            ],
          ),
          
          if (_dueDate != null)
            Text('${DateFormat('yyyy-MM-dd').format(_dueDate!)}'),
        ],
      ),
    );
  }

  Widget buildTimeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time of Day',
                style: GoogleFonts.lato(fontSize: 28.0),
              ),

              TextButton(
                onPressed: () async {
                  final timeOfDay = await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.now()
                  );

                  setState(() {
                    if (timeOfDay != null) {
                      _timeOfDay = timeOfDay;
                    }
                  });
                }, 
                child: const Text('Select'),
              ),
            ],
          ),
          if (_timeOfDay != null) 
            Text('${_timeOfDay!.format(context)}'),
        ],
      ),
    );
  }

  Widget buildColorPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(height: 50.0, width: 10, color: _currentColor),
              const SizedBox(width: 80,),
              Text('Color', style: GoogleFonts.lato(fontSize: 28.0),),
            ],
          ),

          TextButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    content: BlockPicker(
                      pickerColor: Colors.white,
                      onColorChanged: (color) {
                        setState(() {
                          _currentColor = color;
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
                        child: const Text('Save'),
                      ),
                    ],
                  );
                }
              );
            }, 
            child: const Text('Select')
          ),
        ],
      ),
    );
  }

  Widget buildQantityField() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Quantity',
                style: GoogleFonts.lato(fontSize: 28.0),
              ),
              const SizedBox(width: 16.0,),
              Text(
                _currentSliderValue.toInt().toString(),
                style: GoogleFonts.lato(fontSize: 18.0),
              ),
            ],
          ),

          Slider(
            inactiveColor: _currentColor.withOpacity(0.5),
            activeColor: _currentColor,
            value: _currentSliderValue.toDouble(), 
            min:  0.0,
            max: 100.0,
            divisions: 100,
            label: _currentSliderValue.toInt().toString(),
            onChanged: (value) {
              setState(() {
                _currentSliderValue = value.toInt();
              });
            }
          ),
        ],
      ),
    );
  }

  Widget buildGroceryTile() {
    if (_dueDate != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: GroceryTile(
          item: GroceryItem(
            id: 'previewMode',
            name: _name,
            importance: _importance,
            color: _currentColor,
            quantity: _currentSliderValue,
            date: DateTime(
              _dueDate!.year, _dueDate!.month, 
              _dueDate!.day, _timeOfDay!.hour, _timeOfDay!.minute
            ),
          ),
        ),
      );
    }
    return Container(color: Colors.purple,);
  }
}