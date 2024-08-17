//
//  SampleWidgetBundle.swift
//  SampleWidget
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import WidgetKit
import SwiftUI

@main
struct SampleWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        SampleWidgetLiveActivity()
    }
}
