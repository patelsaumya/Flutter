import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_3/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({
    super.key,
    required this.onAddExpense
  });

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  // void _presentDatePicker() {
  //   final now = DateTime.now();
  //   final firstDate = DateTime(now.year-1, now.month, now.day);
  //   showDatePicker(
  //     context: context,
  //     initialDate: now,
  //     firstDate: firstDate,
  //     lastDate: now
  //   ).then((value) {
  //     print(value);
  //   });
  // }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year-1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amount, date and category was entered.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay')
            )
          ]
        )
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amount, date and category was entered.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay')
            )
          ]
        )
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    // double.tryParse('Hello') = null
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (
      _titleController.text.trim().isEmpty ||
      amountIsInvalid ||
      _selectedDate == null
    ) {
      _showDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory
      )
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final titleWidget = TextField(
      // onChanged: _saveTitleInput,
      controller: _titleController,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Title')
      )
    );

    final amountWidget = TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixText: '\$ ',
        label: Text('Amount')
      )
    );

    final dateWidget = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _selectedDate == null
              ? 'No date selected'
              : formatter.format(_selectedDate!)
        ),
        IconButton(
          onPressed: _presentDatePicker,
          icon: const Icon(
            Icons.calendar_month
          )
        )
      ]
    );

    final categoryWidget = DropdownButton(
      value: _selectedCategory,
      items: Category.values.map(
        (category) => DropdownMenuItem(
          value: category,
          child: Text(category.name.toUpperCase())
        )
      ).toList(), 
      onChanged: (value) {
        if (value == null) {
          return;
        }
        setState(() {
          _selectedCategory = value;
        });
      }
    );

    final buttonWidgets = [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        }, 
        child: const Text('Cancel')
      ),
      ElevatedButton(
        // onPressed: () {
        //   // print(_enteredTitle);
        //   print(_titleController.text);
        // }, 
        onPressed: _submitExpenseData,
        child: const Text('Save Expense')
      )
    ];

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: titleWidget
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: amountWidget
                      )
                    ]
                  )
                else
                  titleWidget,
                if (width >= 600)
                  Row(
                    children: [
                      categoryWidget,
                      const SizedBox(width: 24),
                      Expanded(
                        child: dateWidget
                      )
                    ]
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: amountWidget
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: dateWidget
                      )
                    ]
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      ...buttonWidgets
                    ]
                  )
                else
                  Row(
                    children: [
                      categoryWidget,
                      const Spacer(),
                      ...buttonWidgets
                    ]
                  )
              ]
            )
          )
        )
      );
    });
  }
}