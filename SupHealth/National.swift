//
//  Country.swift
//  SupHealth
//
//  Created by Oscar Di Lenarda on 08/03/2021.
//

import Foundation

final class Country: Codable, Identifiable {
    var Country: String?,
        Slug: String?,
        ISO2: String?
}

final class CountryDetails: Codable {
    var Country: String?,
        CountryCode: String?,
        Province: String?,
        City: String?,
        CityCode: String?,
        Lat: String?,
        Lon: String?,
        Confirmed: Int?,
        Deaths: Int?,
        Recovered: Int?,
        Active: Int?,
        Date: String?
}
