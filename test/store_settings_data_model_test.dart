import 'package:flutter_test/flutter_test.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';

void main() {
  test('parses producctUISettings from API json', () {
    final json = '''
    {
      "id": "1",
      "name": "Le Arabia Development",
      "smsAvailableCountries": [],
      "producctUISettings": {
        "spicelevelIcons": {
          "Not Applicable": "\u2B55",
          "Not Spicy": "\u{1F33F}",
          "Mild": "\u{1F336}\uFE0F",
          "Medium": "\u{1F336}\uFE0F\u{1F336}\uFE0F",
          "Hot": "\u{1F336}\uFE0F\u{1F336}\uFE0F\u{1F336}\uFE0F",
          "Extra Hot": "\u{1F336}\uFE0F\u{1F336}\uFE0F\u{1F336}\uFE0F\u{1F336}\uFE0F"
        }
      }
    }
    ''';

    final model = StoreSettingsDataModel.fromJson(json);

    expect(model.producctUISettings, isNotNull);
    expect(model.producctUISettings!.spicelevelIcons, isNotNull);
    expect(
      model.producctUISettings!.spicelevelIcons!['Mild'],
      '\u{1F336}\uFE0F',
    );
    expect(
      model.producctUISettings!.spicelevelIcons!['Hot'],
      '\u{1F336}\uFE0F\u{1F336}\uFE0F\u{1F336}\uFE0F',
    );

    // Round trip
    final restored = StoreSettingsDataModel.fromJson(model.toJson());
    expect(restored.producctUISettings, equals(model.producctUISettings));

    // copyWith (replaces non-null value)
    final replaced = model.copyWith(
      producctUISettings: const StoreProductUISettings(
        spicelevelIcons: {'Mild': 'X'},
      ),
    );
    expect(replaced.producctUISettings!.spicelevelIcons!['Mild'], 'X');
    expect(replaced.id, model.id);

    // Missing key returns null
    final noKey = StoreSettingsDataModel.fromJson('{"smsAvailableCountries":[]}');
    expect(noKey.producctUISettings, isNull);
  });
}