//
//  Country.swift
//  SupHealth
//
//  Created by Oscar Di Lenarda on 08/03/2021.
//

import Foundation

final class Global: Codable {
    var NewConfirmed: Int?,
        TotalConfirmed: Int?,
        NewDeaths: Int?,
        TotalDeaths: Int?,
        NewRecovered: Int?,
        TotalRecovered: Int?,
        Date: String?
}
