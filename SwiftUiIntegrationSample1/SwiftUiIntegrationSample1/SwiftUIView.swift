//
//  SwiftUIView.swift
//  SwiftUiIntegrationSample1
//
//  Created by Ranjeet on 16/07/19.
//  Copyright © 2019 Ranjeet. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack {
            Image("dog")
                .resizable()
                .padding()
            
            Text("I am in Swift UI View \(settings.userName)")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .padding()
            
            Button(action: {
                self.settings.userName = "SwiftUI\(Int.random(in: 1...100))"
            }) {
                Text("Cange User")
            }.padding()
        }
        .navigationBarTitle("SwiftUI")
        .padding()
    }

}
