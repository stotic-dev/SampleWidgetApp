//
//  WeatherDetailView.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import SwiftUI

struct WeatherDetailView: View {
    
    @StateObject var viewModel: WeatherDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text(viewModel.placeName)
                    Spacer()
                        .frame(height: 24)
                    Text(viewModel.temperature)
                        .font(.system(size: 40, weight: .bold))
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        Text("最高 \(viewModel.maxTemperature)")
                        Spacer()
                            .frame(width: 8)
                        Text("最低 \(viewModel.minTemperature)")
                    }
                    .font(.system(size: 26))
                }
                .frame(height: 300)
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 20), count: 2), spacing: 20) {
                    ForEach(WeatherDetailType.allCases, id: \.self) { type in
                        VStack {
                            type.icon
                                .resizable()
                                .frame(width: 45, height: 45)
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                Text(type.title)
                                Text(type.getValue(viewModel.weatherInfo))
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            Color.gray.opacity(0.2)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .background {
            Image(viewModel.backGroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WeatherDetailView(viewModel: WeatherDetailViewModel(weatherInfo: .defaultMock()))
}
