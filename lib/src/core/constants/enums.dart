enum Country {
  ind(
    decimalPlaces: 2,
    currencyDivisor: 100,
    currencyCode: 'INR',
    symbol: '₹',
    countryName: 'India',
  ),
  uk(
    decimalPlaces: 2,
    currencyDivisor: 100,
    currencyCode: 'GBP',
    symbol: '£',
    countryName: 'United Kingdom',
  ),
  bh(
    decimalPlaces: 3,
    currencyDivisor: 1000,
    currencyCode: 'BHD',
    symbol: 'BHD',
    countryName: 'Bahrain',
  );

  final int decimalPlaces;
  final int currencyDivisor;
  final String currencyCode;
  final String symbol;
  final String countryName;

  const Country({
    required this.currencyDivisor,
    required this.decimalPlaces,
    required this.currencyCode,
    required this.symbol,
    required this.countryName,
  });
}

enum AppThemeMode { light, dark, system }
