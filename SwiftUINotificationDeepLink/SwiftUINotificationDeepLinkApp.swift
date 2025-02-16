//
//  SwiftUINotificationDeepLinkApp.swift
//  SwiftUINotificationDeepLink
//
//  Created by 김정민 on 2/16/25.
//

import SwiftUI

/*
 The primary advantage of using deep links is that they're not limited to navigation paths.
 You can use them to push pages, sheets, alerts, dialogs, and more.
 */
@main
struct SwiftUINotificationDeepLinkApp: App {
    
    @UIApplicationDelegateAdaptor(AppData.self) private var appData
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appData)
                .onOpenURL { url in
                    if let pageName = url.host() {
                        appData.mainPageNavigationPath.append(pageName)
                    }
                }
        }
    }
}

@Observable
class AppData: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var mainPageNavigationPath: [String] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        /// Showing alert event when app is active
        return [.sound, .banner]
    }
    
    /// Handling Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let pageLink = response.notification.request.content.userInfo["pageLink"] as? String {
            /*
             if mainPageNavigationPath.last != pageLink {
                 /// Optional: Removing all previous pages
                 /// You can skip this step if you want to maintain previous pages as well
                 mainPageNavigationPath = []
                 /// Pushing our new page
                 mainPageNavigationPath.append(pageLink)
             }
             */
            
            guard let url = URL(string: pageLink) else { return }
            UIApplication.shared.open(url, options: [:]) { _ in
                
            }
        }
    }
}
