//
//  WindWatchWidget.swift
//  WindWatchWidget
//
//  Created by koyanagi on 2023/09/12.
//

import WidgetKit
import WatchKit
import SwiftUI

struct Provider: TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "https://mysite-906r.onrender.com/wind_speed_hayamas/1.json")!) {(data, response, error) in
            var entries : [SimpleEntry] = []
            if let _ = error {
                print("error")
              return
            }
            if let response = response as? HTTPURLResponse {
                
              if (200...399).contains(response.statusCode) {
                  let wind = (try! JSONSerialization.jsonObject(with: data!) as! [String: Any])["wind_speed_meter_per_second"] as! Float
                  
                  let entry = SimpleEntry(date: Date.now, windSpeed:wind)
                  entries.append(entry)
                  let timeline = Timeline(entries: entries, policy:
                        .after(Calendar.current.date(byAdding: .minute, value: 15, to: entry.date)!
                              )
                                                                          )
                  completion(timeline)
              } else {
                  print(response.statusCode)
              }
            }
        }.resume()
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
//        semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: URL(string: "https://mysite-906r.onrender.com/wind_speed_hayamas/1.json")!)
                request.httpMethod = "GET"

                                           // HTTPリクエスト実行
                                           let res = URLSession.shared.dataTask(with: request).resume()
                                           // requestCompleteHandler内でsemaphore.signal()が呼び出されるまで待機する
        print(res)
                                           
        return SimpleEntry(date: Date.now, windSpeed:12)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date.now, windSpeed: 11)
        completion(entry)
        
        URLSession.shared.dataTask(with: URL(string: "https://mysite-906r.onrender.com/wind_speed_hayamas/1.json")!) {(data, response, error) in
            if let _ = error {
                print("error")
                return
            }
            if let response = response as? HTTPURLResponse {
                
                if (200...399).contains(response.statusCode) {
                    let wind = (try! JSONSerialization.jsonObject(with: data!) as! [String: Any])["wind_speed_meter_per_second"] as! Float
                    
                    let entry = SimpleEntry(date: Date.now, windSpeed:wind)
                    completion(entry)
                } else {
                    print(response.statusCode)
                }
            }
            //        }.resume()
        }
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var windSpeed: Float
}

struct WindWatchWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(String(entry.windSpeed)).task {
                WidgetCenter.shared.reloadTimelines(ofKind: "WindWatchWidget")
            }
        }
    }
}

@main
struct WindWatchWidget: Widget {
    let kind: String = "WindWatchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WindWatchWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .accessoryRectangular) {
    WindWatchWidget()
} timeline: {
    SimpleEntry(date: .now, windSpeed: 14)
    SimpleEntry(date: .now, windSpeed: 15)
}
