//
//  SearchBar.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/14.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    var tappedSearchButton: (String) -> Void
    
    var body: some View {
        HStack {
            Button {
                tappedSearchButton(searchText)
            } label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .disabled(searchText.isEmpty)
            TextField("please type place!", text: $searchText)
            .padding(8)
            .frame(height: 40)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(.horizontal, 8)
        .background(Color(.searchBarBackground))
        .foregroundStyle(Color(.primaryText))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay {
            RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 0.5)
        }
    }
}

#Preview {
    struct SearchBarPreview: View {
        
        @State var searchText = ""
        
        var body: some View {
            SearchBar(searchText: $searchText) {
                print("do search \($0)")
            }
        }
    }
    
    return SearchBarPreview()
}
