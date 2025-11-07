//
//  MainTabView.swift
//  ChineseReader
//
//  Main tab navigation with Camera tab
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
                .tag(0)
        }
    }
}

#Preview {
    MainTabView()
}