import SwiftUI

struct CountryCell: View {

    let country: DBModel.Country
    @Environment(\.locale) var locale: Locale

    var body: some View {
        VStack(alignment: .leading) {
            Text(country.name(locale: locale))
                .font(.title)
            Text("Population \(country.population)")
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
    }
}
