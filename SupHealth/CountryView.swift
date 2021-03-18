//
//  CountryView.swift
//  SupHealth
//
//  Created by Oscar Di Lenarda on 08/03/2021.
//

import SwiftUI
import SwiftUICharts

struct CountryView: View {
    
    @State var liked: Bool
    @State var country: Country
    @Environment(\.colorScheme) var colorScheme
    
    @State private var newCases = "0"
    @State private var newDeaths = "0"
    @State private var newRecovered = "0"
    
    @State private var totalCases = "0"
    @State private var totalDeaths = "0"
    @State private var totalRecovered = "0"
    
    @State private var retryFetchStats = false
    @State private var selectedChart = "Cases"
    @State private var countryDetails: CountryDetails?
    @State private var countryData: [CountryDetails] = []
    @State private var chartValues: [(title: String, value: Int)] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("Total cases")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.leading, UIScreen.main.bounds.width > 360 ? 16 : 12)
                        .lineLimit(1)
                    
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width - 20, height: 8)
                    
                    Text(totalCases)
                        .foregroundColor(.blue)
                        .font(.largeTitle).bold()
                        .padding(.leading, UIScreen.main.bounds.width > 360 ? 16 : 12)
                        .lineLimit(1)
                    
                    Text("\(newCases) new cases since 24h.")
                        .padding(.top, 8)
                        .padding(.leading, UIScreen.main.bounds.width > 360 ? 16 : 12)
                        .lineLimit(1)
                }
                .padding(10)
                .frame(width: UIScreen.main.bounds.width - 20)
                .background(Color(.systemBlue).opacity(colorScheme == .dark ? 0.25 : 0.1))
                .cornerRadius(6)
                
                // for iPhones larger than 5 / SE / 12 mini
                if (UIScreen.main.bounds.width > 360) {
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Deaths")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Spacer()
                                .frame(width: (UIScreen.main.bounds.width / 2) - 15, height: 8)
                            
                            Text(totalDeaths)
                                .font(.title2).bold()
                                .foregroundColor(.red)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Text("Last 24h: \(newDeaths)")
                                .font(.callout)
                                .padding(.top, 8)
                                .padding(.leading, 12)
                                .lineLimit(1)
                        }
                        .padding(10)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 15)
                        .background(Color(.red).opacity(colorScheme == .dark ? 0.25 : 0.1))
                        .cornerRadius(6)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Recovered")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Spacer()
                                .frame(width: (UIScreen.main.bounds.width / 2) - 15, height: 8)
                            
                            Text(totalRecovered)
                                .font(.title2).bold()
                                .foregroundColor(.green)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Text("Last 24h: \(newRecovered)")
                                .font(.callout)
                                .padding(.top, 8)
                                .padding(.leading, 12)
                                .lineLimit(1)
                        }
                        .padding(10)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 15)
                        .background(Color(.systemGreen).opacity(colorScheme == .dark ? 0.25 : 0.1))
                        .cornerRadius(6)
                    }
                    
                } else {
                    
                    VStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("Deaths")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Spacer()
                                .frame(width: UIScreen.main.bounds.width - 20, height: 8)
                            
                            Text(totalDeaths)
                                .font(.title).bold()
                                .foregroundColor(.red)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Text("Last 24h: \(newDeaths)")
                                .font(.callout)
                                .padding(.top, 8)
                                .padding(.leading, 12)
                                .lineLimit(1)
                        }
                        .padding(10)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .background(Color(.red).opacity(colorScheme == .dark ? 0.25 : 0.1))
                        .cornerRadius(6)
                        
                        VStack(alignment: .leading) {
                            Text("Recovered")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Spacer()
                                .frame(width: UIScreen.main.bounds.width - 20, height: 8)
                            
                            Text(totalRecovered)
                                .font(.title).bold()
                                .foregroundColor(.green)
                                .padding(.leading, 12)
                                .lineLimit(1)
                            
                            Text("Last 24h: \(newRecovered)")
                                .font(.callout)
                                .padding(.top, 8)
                                .padding(.leading, 12)
                                .lineLimit(1)
                        }
                        .padding(10)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .background(Color(.systemGreen).opacity(colorScheme == .dark ? 0.25 : 0.1))
                        .cornerRadius(6)
                    }
                    
                }
                
                // BarChartView inside if conditions for selectedChart, otherwise chart data doesn't refresh in the UI
                if (selectedChart == "Cases") {
                    BarChartView(data: ChartData(values: chartValues), title: selectedChart, legend: "Daily cases: last 7 days", style: Style.lightCases, darkModeStyle: Style.darkCases, form: ChartForm.large).cornerRadius(6)
                } else if (selectedChart == "Deaths") {
                    BarChartView(data: ChartData(values: chartValues), title: selectedChart, legend: "Daily cases: last 7 days", style: Style.lightDeaths, darkModeStyle: Style.darkDeaths, form: ChartForm.large).cornerRadius(6)
                } else {
                    BarChartView(data: ChartData(values: chartValues), title: selectedChart, legend: "Daily cases: last 7 days", style: Style.lightRecovered, darkModeStyle: Style.darkRecovered, form: ChartForm.large).cornerRadius(6)
                }
                
                HStack {
                    Spacer()
                    Button("Cases") {
                        self.selectedChart = "Cases"
                        var newValues: [(title: String, value: Int)] = []
                        
                        if (countryData.count > 0) {
                            for (i, day) in countryData.enumerated() {
                                newValues.append((title: formatDate(date: String((day.Date!).prefix(10))), value: i == 0 ? day.Confirmed! : day.Confirmed! - countryData[i-1].Confirmed!))
                            }
                            self.chartValues = Array(newValues[(newValues.count - 8)...(newValues.count - 1)])
                        }
                    }
                    Spacer()
                    Button("Deaths") {
                        self.selectedChart = "Deaths"
                        var newValues: [(title: String, value: Int)] = []
                        
                        if (countryData.count > 0) {
                            for (i, day) in countryData.enumerated() {
                                newValues.append((title: formatDate(date: String((day.Date!).prefix(10))), value: i == 0 ? day.Deaths! : day.Deaths! - countryData[i-1].Deaths!))
                            }
                            self.chartValues = Array(newValues[(newValues.count - 8)...(newValues.count - 1)])
                        }
                    }
                    Spacer()
                    Button("Recovered") {
                        self.selectedChart = "Recovered"
                        var newValues: [(title: String, value: Int)] = []
                        
                        if (countryData.count > 0) {
                            for (i, day) in countryData.enumerated() {
                                newValues.append((title: formatDate(date: String((day.Date!).prefix(10))), value: i == 0 ? day.Recovered! : day.Recovered! - countryData[i-1].Recovered!))
                            }
                            self.chartValues = Array(newValues[(newValues.count - 8)...(newValues.count - 1)])
                        }
                    }
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width - 20, alignment: .center)
            }.padding(10)
        }.onAppear(perform: { fetchStats() }).navigationTitle(country.Country ?? "Country")
        // Prompt user to retry if API call failed
        .alert(isPresented: $retryFetchStats) {
            Alert(
                title: Text("Error"),
                message: Text("Failed to fetch COVID-19 data. Retry?"),
                primaryButton: .default(Text("Retry")) {
                    self.retryFetchStats = false
                    fetchStats()
                }, secondaryButton: .cancel(Text("Cancel")) {
                    self.retryFetchStats = false
                }
            )
        }
        .navigationBarItems(trailing: Button(self.liked ? "★" : "☆", action: { handleLike() }).foregroundColor(.yellow).font(.title))
    }
    
    func handleLike() {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
        
        if self.liked {
            favorites = favorites.filter { $0 != country.Country! }
        } else {
            favorites.append(country.Country!)
        }
        
        UserDefaults.standard.set(favorites, forKey: "favorites")
        self.liked = !self.liked
    }
    
    func fetchStats() {
        let url = URL(string: "https://api.covid19api.com/total/country/\(country.Slug ?? "france")")!
        let locale = NumberFormatter()
        locale.numberStyle = .decimal
        
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestHeader) { data, response, error in
            if (data != nil) {
                do {
                    let allData = try JSONDecoder().decode([CountryDetails].self, from: data!)
                    self.countryData = allData
                    if !allData.isEmpty {
                        DispatchQueue.main.async {
                            self.countryDetails = allData[countryData.count - 1]
                            
                            self.totalCases = formatData(locale: locale, new: countryDetails?.Confirmed!, old: 0)
                            self.totalDeaths = formatData(locale: locale, new: countryDetails?.Deaths!, old: 0)
                            self.totalRecovered = formatData(locale: locale, new: countryDetails?.Recovered!, old: 0)
                            
                            self.newCases = formatData(locale: locale,
                                new: allData[countryData.count - 1].Confirmed,
                                old: allData[countryData.count - 2].Confirmed
                            )
                            self.newDeaths = formatData(locale: locale,
                                new: allData[countryData.count - 1].Deaths,
                                old: allData[countryData.count - 2].Deaths
                            )
                            self.newRecovered = formatData(locale: locale,
                                new: allData[countryData.count - 1].Recovered,
                                old: allData[countryData.count - 2].Recovered
                            )
                            
                            // For bar chart data
                            var newValues: [(title: String, value: Int)] = []
                            for (i, day) in allData.enumerated() {
                                newValues.append((title: formatDate(date: String((day.Date!).prefix(10))), value: i == 0 ? day.Confirmed! : day.Confirmed! - allData[i-1].Confirmed!))
                            }
                            self.chartValues = Array(newValues[(newValues.count - 8)...(newValues.count - 1)])
                        }
                    }
                } catch { self.retryFetchStats = true }
            }
        }.resume()
    }
    
    func formatData(locale: NumberFormatter, new: Int?, old: Int?) -> String {
        (new != nil && old != nil)
            ?
        locale.string(from: NSNumber(value: new! - old!))!
            :
        "0"
    }
    
    func formatDate(date: String) -> String {
        let months = ["Jan.", "Feb.", "March", "April", "May", "June", "July", "Aug.", "Sep", "Oct.", "Nov.", "Dec."]
        
        let year = String(date.prefix(4))
        var month = String(date.suffix(5))
        let day = String(month.suffix(2))
        month = String(month.prefix(2))
        
        return "\(months[Int(month)! - 1]) \(day), \(year)"
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CountryView(liked: false, country: Country())
        }
        .preferredColorScheme(.dark)
        
    }
}
