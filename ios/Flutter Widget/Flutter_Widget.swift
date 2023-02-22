//
//  Flutter_Widget.swift
//  Flutter Widget
//
//  Created by Jonn Alves on 18/02/23.
//

//import WidgetKit
//import SwiftUI
//import Intents
//
//struct Provider: IntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationIntent
//}
//
//struct Flutter_WidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}
//
//@main
//struct Flutter_Widget: Widget {
//    let kind: String = "Flutter_Widget"
//
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
//            Flutter_WidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//    }
//}
//
//struct Flutter_Widget_Previews: PreviewProvider {
//    static var previews: some View {
//        Flutter_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}


//
//  Flutter_Widget.swift
//  Flutter Widget
//
//  Created by Jonn Alves on 18/02/23.
//

import WidgetKit
import SwiftUI
import Intents

private var flutterData: FlutterData? = FlutterData(text:"Loading ...")

struct Provider: IntentTimelineProvider {
    
    
    func placeholder(in context: Context) -> SimpleEntry {
          SimpleEntry(date: Date(), configuration: ConfigurationIntent(), flutterData: FlutterData(text: "Hello from Flutter"))
      }

      func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
          let entry = SimpleEntry(date: Date(),configuration: configuration, flutterData: FlutterData(text: "Hello from Flutter"))
          completion(entry)
      }

    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let sharedDefaults = UserDefaults(suiteName: "group.com.quanticheart.ioswidgetscreen")
        var flutterData: FlutterData? = nil
        
        if(sharedDefaults != nil) {
            do {
              let shared = sharedDefaults?.string(forKey: "widgetData")
              if(shared != nil){
                let decoder = JSONDecoder()
                flutterData = try decoder.decode(FlutterData.self, from: shared!.data(using: .utf8)!)
              }
            } catch {
              print(error)
            }
        }

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, configuration: configuration,flutterData: flutterData)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct Flutter_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    private var FlutterDataView: some View {
      Text(entry.flutterData!.text)
    }
    
    private var NoDataView: some View {
      Text("No data found. 😐 \nAdd data using Flutter App.").multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private func getViewWidget() -> some View {
        if(entry.flutterData == nil) {
            NoDataView
        } else {
            FlutterDataView
        }
    }
    
    var body: some View {
        switch family {
        case .systemSmall: getViewWidget()
        case .systemMedium: getViewWidget()
        case .systemLarge: getViewWidget()
        case .systemExtraLarge: getViewWidget()
        case .accessoryCircular:
            getViewWidget()
        case .accessoryRectangular:
            getViewWidget()
        case .accessoryInline:
            getViewWidget()
        @unknown default:
            getViewWidget()
        }
        
    }
}

struct FlutterData: Decodable, Hashable {
    let text: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let flutterData: FlutterData?
}

@main
struct Flutter_Widget: Widget {
    let kind: String = "Flutter_Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Flutter_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Flutter_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Flutter_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), flutterData: FlutterData(text:"test")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

