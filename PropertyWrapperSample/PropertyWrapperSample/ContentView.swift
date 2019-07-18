//
//  ContentView.swift
//  PropertyWrapperSample
//
//  Created by Ranjeet on 16/07/19.
//  Copyright © 2019 Ranjeet. All rights reserved.
//

import SwiftUI
import Combine



@propertyWrapper
struct Trimmed
{
    private(set) var value: String = ""
    
    init(initialValue: String) {
        self.wrappedValue = initialValue
    }
    
    var wrappedValue: String {
        set {
            value = newValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        get {
            value
        }
    }
}

@propertyWrapper
struct MyUserDefault<T>
{
    var key: String
    
    init(initialValue value: T, _ key: String) {
        self.key = key
        wrappedValue = value
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.value(forKey: key) as! T
        }
        set  {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}


struct CustomPropertyWrapper
{
    @Trimmed var sampleText = " \n Trimed char  "
    @MyUserDefault("user") var storedUserName = "Ranjeet"
    @MyUserDefault("password") var storedPassword = "Ranjeet1234"
}

class MyBindableObject: BindableObject {
    var didChange = PassthroughSubject<Void, Never>()

    var object = CustomPropertyWrapper() {
        didSet {
            debugPrint("\(object.sampleText)")
            debugPrint("\(object.storedUserName)")
            debugPrint("\(object.storedPassword)")

            didChange.send()
        }
    }
}

struct ContentView : View {
    
    @ObjectBinding var myObject = MyBindableObject()
    @State var isAllow: Bool = false
    
    var body: some View {
        VStack {
            
            Spacer(minLength: 50)
            Toggle(isOn: $isAllow) {
                Text("Change in property is: \(isAllow ? "Allowed" : "Not Allowed")")
            }.padding()
            
            
            Group {
                Text("Trimmed text is:\t\(myObject.object.sampleText)")
                Text("User is:\t\(myObject.object.storedUserName)")
                Text("Password is:\t\(myObject.object.storedPassword)")
            }
            
            
            Spacer(minLength: 100)
            Button(action: {
                if self.isAllow {
                    self.myObject.object.sampleText = "   Random property value \(Int.random(in: 1...100))    "
                    self.myObject.object.storedUserName = "SwiftUI version\(Int.random(in: 100...1000))"
                    self.myObject.object.storedPassword = "XCode \(Int.random(in: 1000...100000))"
                }
                
            }) {
                Text("Tap & Guase")
            }
            .frame(width: 250, height: 50)
            .accentColor(Color.blue)
            .background(Color.green)
            .cornerRadius(12)
            .border(Color.purple, width: 3, cornerRadius: 12)
            .shadow(radius: 3)
            
            
            
            Spacer(minLength: 50)
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
