//
//  ContentView.swift
//  test Watch App
//
//  Created by koyanagi on 2023/09/09.
//

import SwiftUI

struct ContentView: View {
    @State var wind: Float = 0
    var body: some View {
        VStack {
            Text(String(wind)).task {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(time: Timer) in
            
                    URLSession.shared.dataTask(with: URL(string: "https://mysite-906r.onrender.com/wind_speed_hayamas/1.json")!) {(data, response, error) in
                        if let _ = error {
                            print("error")
                          return
                        }
                        if let response = response as? HTTPURLResponse {
                            
                          if (200...399).contains(response.statusCode) {
                              wind = (try! JSONSerialization.jsonObject(with: data!) as! [String: Any])["wind_speed_meter_per_second"] as! Float
                          } else {
                              print(response.statusCode)
                          }
                        }
                    }.resume()
                })
            }.font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
