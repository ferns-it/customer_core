String countryCodeToEmoji(String countryCode) {
  return countryCode
      .toUpperCase()
      .codeUnits
      .map((c) => String.fromCharCode(c + 127397))
      .join();
}