//
//  NationalView.swift
//  SupHealth
//
//  Created by Oscar Di Lenarda on 08/03/2021.
//

import SwiftUI
import Kingfisher

struct NationalView: View {
    
    @State private var searchText = ""
    @State private var countries: [Country]?
    @State private var retryFetchCountries = false
    @State private var favoritesOn = UserDefaults.standard.bool(forKey: "showFavorites")
    
    var body: some View {
        List { if (countries != nil) {
            
            SearchBar(text: $searchText)
            Toggle("Show favorites only", isOn: $favoritesOn)
                .onReceive([self.favoritesOn].publisher.first(), perform: { value in
                        UserDefaults.standard.set(self.favoritesOn, forKey: "showFavorites")
                    })
                .padding(5)

            ForEach(self.countries!.filter {
                if !self.favoritesOn {
                    return self.searchText.isEmpty ? true : $0.Country!.lowercased().contains(self.searchText.lowercased())
                } else {
                    let favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []

                    if self.searchText.isEmpty {
                        
                        if favorites.count > 0 {
                            return favorites.contains($0.Country!)
                        }
                        return false
                    
                    } else {
                        
                        if favorites.count > 0 {
                            return favorites.contains($0.Country!) ? (
                                $0.Country!.lowercased().contains(self.searchText.lowercased())
                            ) : false
                        }
                        return false
                        
                    }
                }
            }, id: \.self.Country) { country in
                NavigationLink(destination: CountryView(liked: getFavorite(country: country.Country!), country: country)) {
                    HStack {
                        if (country.ISO2 != nil) {
                            KFImage(URL(string: "https://www.countryflags.io/\(country.ISO2!.lowercased())/flat/64.png")!)
                            .padding(.trailing, 10)
                            .frame(width: 80, height: 40, alignment: .center)
                        }
                        VStack(alignment: .leading) {
                            Text(country.Country ?? "")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .padding(.bottom, 0.5)
                            Text(country.ISO2 ?? "")
                                .font(.footnote)
                        }
                        if getFavorite(country: country.Country!) {
                            Spacer()
                            Text("★")
                                .foregroundColor(.yellow)
                                .font(.title)
                        }
                    }.padding(.vertical, 5)
                }
            }
        }}.onAppear(perform: {
            fetchCountries()
        }).navigationTitle("Countries")
        // Prompt user to retry if API call failed
        .alert(isPresented: $retryFetchCountries) {
            Alert(
                title: Text("Error"),
                message: Text("Failed to fetch COVID-19 data. Retry?"),
                primaryButton: .default(Text("Retry")) {
                    self.retryFetchCountries = false
                    fetchCountries()
                }, secondaryButton: .cancel(Text("Cancel")) {
                    self.retryFetchCountries = false
                }
            )
        }
    }
    
    func getFavorite(country: String) -> Bool {
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
        
        return favorites.contains(country)
    }
    
    func fetchCountries() {
        let url = URL(string: "https://api.covid19api.com/countries")
        
        var requestHeader = URLRequest.init(url: url!)
        requestHeader.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestHeader) { data, response, error in
            if (data != nil) {
                do {
                    let countriesData = try JSONDecoder().decode([Country].self, from: data!)
                    DispatchQueue.main.async {
                        self.countries = countriesData.sorted(by: { $0.Country! < $1.Country! })
                    }
                } catch { self.retryFetchCountries = true }
            }
        }.resume()
    }
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct NationalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                NationalView()
            }
            .previewDevice("iPod touch (7th generation)")
        }
    }
}
