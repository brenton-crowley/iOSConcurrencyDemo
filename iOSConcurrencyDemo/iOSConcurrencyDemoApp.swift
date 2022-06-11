//
//  iOSConcurrencyDemoApp.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import SwiftUI

@main
struct iOSConcurrencyDemoApp: App {
    var body: some Scene {
        WindowGroup {
            UsersListView()
                .environmentObject(UsersListViewModel())
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
