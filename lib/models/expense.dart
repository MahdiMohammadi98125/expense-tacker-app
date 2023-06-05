class Expense {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  // constructor
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  // Expense to map
  Map<String, dynamic> toMap() => {
        'title': title,
        'amount': amount.toString(),
        'date': date.toString(),
        'category': category,
      };

  // map to expense
  factory Expense.fromString(Map<String, dynamic> value) => Expense(
      id: value['id'],
      title: value['title'],
      amount: double.parse(value['amount']),
      date: DateTime.parse(value['date']),
      category: value['category']);
}
