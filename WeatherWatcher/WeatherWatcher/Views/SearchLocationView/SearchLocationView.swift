//
//  SearchLocationView.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/14.
//

import SwiftUI

struct SearchLocationView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SearchLocationViewModel
    
    var body: some View {
        ZStack {
            VStack {
                SearchBar(searchText: $viewModel.searchText) { text in
                    viewModel.tappedSearchButton(text)
                }
                .padding(.horizontal, 16)
                List {
                    ForEach(viewModel.discoveredLocation) { location in
                        Button {
                            viewModel.tappedLocationRow(location)
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(location.name ?? "-")
                                        .font(.system(size: 20, weight: .bold))
                                    if let address = location.address {
                                        Text(address)
                                            .font(.system(size: 14))
                                    }
                                }
                                
                                Spacer()
                                Text(location.country ?? "")
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 30)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollBounceBehavior(.basedOnSize)
            }
            .padding(.vertical, 16)
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background(.black)
                    .opacity(0.3)
            }
        }
    }
}

#Preview {
    SearchLocationView(viewModel: SearchLocationViewModel(delegate: SearchLocationViewModel.DelegateViewModel()))
}
