import 'package:flutter/material.dart';

class TukarMataUangPage extends StatefulWidget {
  @override
  _TukarMataUangPageState createState() => _TukarMataUangPageState();
}

class _TukarMataUangPageState extends State<TukarMataUangPage> {
  final List<String> currencies = [
    'IDR (Rupiah)',
    'USD (US Dollar)',
    'EUR (Euro)',
    'GBP (Pound Sterling)',
    'JPY (Yen)',
    'CNY (Yuan)',
    'KRW (Won)'
  ];

  String fromCurrency = 'IDR (Rupiah)';
  String toCurrency = 'USD (US Dollar)';
  TextEditingController amountController = TextEditingController();

  double convertedAmount = 0.0;
  double convertedCheapTicket = 0.0;
  double convertedSingaporeTicket = 0.0;
  double convertedExpensiveTicket = 0.0;

  double aveCheapTicketPrice = 498;
  double aveSingaporeTicketPrice = 557;
  double aveExpensiveTicketPrice = 1617;

  // Simulasi konversi (Anda dapat mengganti dengan API kurs yang sebenarnya)
  double getConversionRate(String from, String to) {
    Map<String, double> rates = {
      'USD': 1.0,        // USD adalah basis (1.0)
      'IDR': 15385.0,    // 1 USD = 15,385 IDR
      'EUR': 0.92,       // 1 USD = 0.92 EUR
      'GBP': 0.78,       // 1 USD = 0.78 GBP
      'JPY': 148.0,      // 1 USD = 148 JPY
      'CNY': 7.3,        // 1 USD = 7.3 CNY
      'KRW': 1315.0,     // 1 USD = 1,315 KRW
    };

    String fromCode = from.split(' ')[0];
    String toCode = to.split(' ')[0];
    return rates[toCode]! / rates[fromCode]!;
  }

  void convertCurrency() {
    double amount = double.tryParse(amountController.text) ?? 0.0;

    // Hitung konversi untuk input amount berdasarkan fromCurrency dan toCurrency
    double rate = getConversionRate(fromCurrency, toCurrency);
    setState(() {
      convertedAmount = amount * rate;

      // Konversi tiket berdasarkan toCurrency langsung dari USD
      double ticketRate = getConversionRate('USD (US Dollar)', toCurrency);
      convertedCheapTicket = aveCheapTicketPrice * ticketRate;
      convertedSingaporeTicket = aveSingaporeTicketPrice * ticketRate;
      convertedExpensiveTicket = aveExpensiveTicketPrice * ticketRate;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/f1.png',
              width: 70,
              fit: BoxFit.contain,
            ),
            SizedBox( width: 10,),
            Text('Konversi Mata Uang'),
          ],
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'From',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: fromCurrency,
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  fromCurrency = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'To',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: toCurrency,
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  toCurrency = newValue!;
                  // Update ticket prices when currency changes
                  convertCurrency();
                });
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(              
                onPressed: convertCurrency,
                child: Text('Convert'),
              ),
            ),            
            SizedBox(height: 16),
            Text(
              'Hasil konversi: ${convertedAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Tiket termurah (Chinese GP): \n${convertedCheapTicket.toStringAsFixed(2)} $toCurrency',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10,),
            Text(
              'Tiket terdekat (Singapore GP): \n${convertedSingaporeTicket.toStringAsFixed(2)} $toCurrency',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10,),
            Text(
              'Tiket termahal (Las Vegas GP): \n${convertedExpensiveTicket.toStringAsFixed(2)} $toCurrency',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
