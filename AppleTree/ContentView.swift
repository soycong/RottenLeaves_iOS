//
//  ContentView.swift
//  AppleTree
//
//  Created by 김유빈 on 2023/10/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CameraView()
                .tabItem {
                    Image(systemName: "camera.fill")
                }
            
            ListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
