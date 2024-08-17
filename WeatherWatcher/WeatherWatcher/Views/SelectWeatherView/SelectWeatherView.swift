//
//  SelectWeatherView.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import Combine
import SwiftUI

struct SelectWeatherView: View {
    
    @EnvironmentObject var appState: AppStatus
    @ObservedObject var viewModel: SelectWeatherViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.weathers) { weather in
                            NavigationLink {
                                WeatherDetailView(viewModel: WeatherDetailViewModel(weatherInfo: weather))
                            } label: {
                                createWeatherCard(weather)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .scrollBounceBehavior(.basedOnSize)
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .background(.black)
                        .opacity(0.3)
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.tappedAddLocationButton()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(.systemBlue))
                    }
                }
            }
            .sheet(isPresented: $viewModel.isPresented) {
                SearchLocationView(viewModel: SearchLocationViewModel(delegate: viewModel.delegateViewModel))
            }
            .navigationDestination(for: SelectWeatherViewModel.Path.self) { path in
                
                switch path {
                    
                case .detail(let id):
                    WeatherDetailView(viewModel: WeatherDetailViewModel(weatherInfo: viewModel.weathers.first { $0.id == id } ?? .defaultMock()))
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onReceive(appState.$openAppUrl) { openUrl in
            print("openUrl: \(openUrl)")
            viewModel.receivedOpenUrl(openUrl)
        }
    }
    
    private func createWeatherCard(_ weather: WeatherInfo) -> some View {
        HStack {
            VStack {
                Text("\(weather.temperature)°")
                    .font(.system(size: 24, weight: .bold))
                Text(weather.weatherCondition.rawValue)
            }
            Spacer()
            Text("\(weather.placeName)")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            Image(weather.weatherCondition.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    SelectWeatherView(viewModel: SelectWeatherViewModel(weathers: [WeatherInfo(id: UUID(), isSelected: false, weatherResponse: .defaultMock(), location: .defaultMock())]))
}
