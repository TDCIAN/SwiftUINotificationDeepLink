//
//  ContentView.swift
//  SwiftUINotificationDeepLink
//
//  Created by 김정민 on 2/16/25.
//

import SwiftUI

/*
 We can trigger remote notifications in our simulator by dropping an APNS file into it.
 The Payload example provided is simple, containing a title and body.
 You can also add additional values to your payload, as I did with the "pageLink" value.
 Additionaly, you must specify your app bundle ID in the "Simulator Targe Bundle" field so that the push notification can be triggered on the simulator.
 */

struct ContentView: View {
    
    @Environment(AppData.self) private var appData
    
    var body: some View {
        
        /// Bindable Environment Values
        @Bindable var appData = appData
        
        NavigationStack(path: $appData.mainPageNavigationPath) {
            List {
                NavigationLink("View 1", value: "View1")
                NavigationLink("View 2", value: "View2")
                NavigationLink("View 3", value: "View3")
            }
            .navigationTitle("Notification Deep Link")
            /// Navigation Destination Views
            .navigationDestination(for: String.self) { value in
                Text("Hello From \(value)")
                    .navigationTitle(value)
            }
        }
        .task {
            /// Notification Permission
            let _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        }
    }
}

#Preview {
    ContentView()
}
