//
//  SearchBar.swift
//  SupHealth
//
//  Created by Oscar Di Lenarda on 09/03/2021.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) { _text = text }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchBar.text = ""
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        }
        
        func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)

        searchBar.returnKeyType = .done
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Search a country"
        searchBar.enablesReturnKeyAutomatically = false
        
        return searchBar
    }

    func updateUIView(_ searchBar: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        searchBar.text = text
    }
}

