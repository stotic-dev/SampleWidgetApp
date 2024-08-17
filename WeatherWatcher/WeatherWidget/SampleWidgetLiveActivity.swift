//
//  SampleWidgetLiveActivity.swift
//  SampleWidget
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SampleWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SampleWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SampleWidgetAttributes {
    fileprivate static var preview: SampleWidgetAttributes {
        SampleWidgetAttributes(name: "World")
    }
}

extension SampleWidgetAttributes.ContentState {
    fileprivate static var smiley: SampleWidgetAttributes.ContentState {
        SampleWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SampleWidgetAttributes.ContentState {
         SampleWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SampleWidgetAttributes.preview) {
   SampleWidgetLiveActivity()
} contentStates: {
    SampleWidgetAttributes.ContentState.smiley
    SampleWidgetAttributes.ContentState.starEyes
}
