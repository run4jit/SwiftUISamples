//
//  ContentView.swift
//  SwiftUIComponents
//
//  Created by Ranjeet on 16/07/19.
//  Copyright © 2019 Ranjeet. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State private var isEnableView: Bool = false
    @State private var searchText: String = ""
    @State private var securesearchText: String = ""
    @State private var sliderValue: Double = 10
    @State private var steperValue: Int = 10
    @State private var opacity: Double = 1
    
    var body: some View {
        VStack {
            
            
            Image(systemName: "cloud.sun.rain.fill")
                .resizable()
                .frame(width: 120, height: 100)
                .aspectRatio(contentMode: ContentMode.fit)
                .saturation(1)
                .contrast(0.5)
//                .blur(radius: 3, opaque: false)

            
            //Label
            Text("I am similar to label.")
                .font(.body)
                .foregroundColor(.green)
                .padding()
                .lineLimit(nil)
                .border(Color.orange, width: 5, cornerRadius: 12)
                .background(Color.yellow)
                .cornerRadius(12)
                .shadow(radius: 5)
                .rotationEffect(Angle.init(degrees: 180))
            // Button
            Button(action: {
        
                withAnimation(.basic(duration: 3)) {
                    self.opacity -= 0.2
                }
                
            })
            {
                HStack {
                    Image(systemName: "bolt.fill")
                        .padding()
                        .background(Color.green)
                        .clipShape(Circle())
                    
                    Text("My Button")
                        .font(.title)
                    //                    .foregroundColor(Color.white)
                }
            }
            .padding()
            .accentColor(Color.orange)
            .background(Color.gray)
            .cornerRadius(12)
            .border(Color.purple, width: 3, cornerRadius: 12)
            .shadow(radius: 3)
            .opacity(opacity)
            
            
            
            //Toggle
            
            Toggle(isOn: $isEnableView) {
                Text("This is my toggle")
                    .foregroundColor(Color.blue)
                    .font(.title)
            }
            .shadow(radius: 15)
            .padding()
            
            
            //Normal TextField
            TextField("Place holder text", text: $searchText) {
                debugPrint("Key board return key tapped \(self.searchText)")
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            .foregroundColor(Color.red)
            .font(.title)
            
            
            
            //Secure TextField
            SecureField("Place holder text", text: $securesearchText) {
                debugPrint("Key board return key tapped \(self.securesearchText)")
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            .foregroundColor(Color.orange)
            .font(.title)
            
            
            
            
            //Slider
            Slider(value: $sliderValue, from: 1.0, through: 100.0, by: 50) { (flag) in
                debugPrint("slider value is \(self.sliderValue)")
            }
            .frame(height: 44)
            .padding()
            
            
            //Steper
            Stepper("My Steper value is \(steperValue)", value: $steperValue, in: 1...100)
                .font(.body)
                .foregroundColor(Color.orange)
                .padding()
            
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
