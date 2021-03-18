//
//  SupHealthApp.swift
//  SupHealth
//
//  Created by Oscar Di Lenarda on 08/03/2021.
//

import SwiftUI

@main
struct SupHealthApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                //NavigationView {
                    GlobalView()
                //}
                .tabItem {
                    Image(systemName: "globe")
                    Text("Global")
                }
                
                NavigationView {
                    NationalView()
                }
                .tabItem {
                    Image(systemName: "flag.fill")
                    Text("National")
                }
            }
        }
    }
}
