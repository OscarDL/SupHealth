//
//  GlobalView.swift
//  SupHealth
//
//  Created by Oscar Di Lenarda on 08/03/2021.
//

import SwiftUI
import SwiftUICharts

struct GlobalView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var totalCases = "0"
    @State private var totalDeaths = "0"
    @State private var totalRecovered = "0"
    
    @State private var newCases = "0"
    @State private var newDeaths = "0"
    @State private var newRecovered = "0"
    
    @State private var retryFetchStats = false
    @State private var selectedChart = "Cases"
    @State private var globalData: [Global] = []
    @State private var chartValues: [(title: String, value: Int)] = []
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                // Remove with NavigationView - workaround master detail landscape issue
                Text("Global Stats")
                    .font(.largeTitle).bold()
                    .padding(EdgeInsets(top: 38, leading: 10, bottom: 10, trailing: 5))
                    .multilineTextAlignment(.leading)

                VStack(alignment: .leading) {
                    Text("Total cases")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.leading, UIScreen.main.bounds.width > 360 ? 16 : 12)
                        .lineLimit(1)
                    
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width - 20, height: 8)
                    
                    Text(String(totalCases))
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
                            
                            Text(String(totalDeaths))
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
                            
                            Text(String(totalRecovered))
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
                            
                            Text(String(totalDeaths))
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
                            
                            Text(String(totalRecovered))
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
                        
                        if (globalData.count > 0) {
                            for day in globalData {
                                newValues.append((title: day.Date!, value: day.NewConfirmed!))
                            }
                            self.chartValues = Array(newValues[(globalData.count - 8)...(globalData.count - 1)])
                        }
                    }
                    Spacer()
                    Button("Deaths") {
                        self.selectedChart = "Deaths"
                        var newValues: [(title: String, value: Int)] = []
                        
                        if (globalData.count > 0) {
                            for day in globalData {
                                newValues.append((title: day.Date!, value: day.NewDeaths!))
                            }
                            self.chartValues = Array(newValues[(globalData.count - 8)...(globalData.count - 1)])
                        }
                    }
                    Spacer()
                    Button("Recovered") {
                        self.selectedChart = "Recovered"
                        var newValues: [(title: String, value: Int)] = []
                        
                        if (globalData.count > 0) {
                            for day in globalData {
                                newValues.append((title: day.Date!, value: day.NewRecovered!))
                            }
                            self.chartValues = Array(newValues[(globalData.count - 8)...(globalData.count - 1)])
                        }
                    }
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width - 20, alignment: .center)
            }.padding(10)
        }.onAppear(perform: { fetchStats() }).navigationTitle("Global Stats")
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
    }
    
    func fetchStats() {
        let url = URL(string: "https://api.covid19api.com/world")!
        let locale = NumberFormatter()
        locale.numberStyle = .decimal
        
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestHeader) { data, response, error in
            if (data != nil) {
                do {
                    let global = try JSONDecoder().decode([Global].self, from: data!)
                    
                    var sortedDates: [Global] = []
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    for day in global {
                        let date = dateFormatter.date(from: String((day.Date!).prefix(10)))
                        if let date = date {
                            day.Date = formatDate(date: dateFormatter.string(from: date))
                            sortedDates.append(day)
                        }
                    }

                    self.globalData = sortedDates.sorted(by: { $0.Date! < $1.Date! })

                    DispatchQueue.main.async {
                        self.totalCases = locale.string(from: NSNumber(value: globalData[globalData.count - 1].TotalConfirmed ?? 0)) ?? "0"
                        self.totalDeaths = locale.string(from: NSNumber(value: globalData[globalData.count - 1].TotalDeaths ?? 0)) ?? "0"
                        self.totalRecovered = locale.string(from: NSNumber(value: globalData[globalData.count - 1].TotalRecovered ?? 0)) ?? "0"
                        
                        self.newCases = locale.string(from: NSNumber(value: globalData[globalData.count - 1].NewConfirmed ?? 0)) ?? "0"
                        self.newDeaths = locale.string(from: NSNumber(value: globalData[globalData.count - 1].NewDeaths ?? 0)) ?? "0"
                        self.newRecovered = locale.string(from: NSNumber(value: globalData[globalData.count - 1].NewRecovered ?? 0)) ?? "0"
                        
                        // For bar chart data
                        var newValues: [(title: String, value: Int)] = []
                        for day in globalData {
                            newValues.append((title: day.Date!, value: day.NewConfirmed!))
                        }
                        self.chartValues = Array(newValues[(globalData.count - 8)...(globalData.count - 1)])
                    }
                } catch { self.retryFetchStats = true }
            }
        }.resume()
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

struct GlobalView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView()
            .preferredColorScheme(.dark)
    }
}
