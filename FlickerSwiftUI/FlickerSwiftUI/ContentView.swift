//
//  ContentView.swift
//  FlickerSwiftUI
//
//  Created by Ranjeet on 15/07/19.
//  Copyright © 2019 Ranjeet. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State private var searchText = "dog"

    @ObjectBinding var flickerService = FlickerServiceManager()
    @ObjectBinding var imageService = ImageService()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if self.flickerService.photos.count > 0 {
                    TextField("Animal Name", text: $searchText) {
                        self.flickerService.flickerRequest(SearchTerm(text: self.searchText))
                    }
                    .textFieldStyle(.roundedBorder)
                        .padding()
                        .foregroundColor(Color.red)
                        .font(.title)
                    
                    
                    List {
                        ForEach(self.flickerService.photos) { photo in
                            NavigationLink(destination: DetailView(photo: photo)) {
                                HStack {
                                    MyImageView(url: photo.photoURL)
                                    VStack(alignment:.leading) {
                                        Text("Title: \(photo.title ?? "")")
                                            .lineLimit(2)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        Text("Owner: \(photo.owner ?? "")")
                                            .lineLimit(2)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                   
                                }
                            }
                        }
                    }

                } else {
                    Text("My response not came yet...")
                }
            }.onAppear {
                self.flickerService.flickerRequest(SearchTerm(text: self.searchText))
            }
            .navigationBarTitle("Flicker")
            .padding()
        }
    }
}


struct MyImageView : View {
    
    var imageUrl: URL?
    @ObjectBinding private var imageLoader: ImageService = ImageService()
    @State private var image: UIImage = UIImage(named: "imagePlaceHolder")!

    init(url: URL?) {
        self.imageUrl = url
    }
    
    var body: some View {
        Group {
                Image(uiImage: self.imageLoader.cachedImageForURL(url: imageUrl!))
                .resizable()
                .frame(width: 70, height: 70)
                .aspectRatio(contentMode: ContentMode.fit)
                .border(Color.gray, width: 1, cornerRadius: 70/2.0)
                .clipShape(Circle())
                .shadow(color: Color.gray, radius: 3)


        }.onAppear {
            self.imageLoader.loadImageFor(photoUrl: self.imageUrl) { result in
                switch result
                {
                case .success(let img) : self.image = img
                default: debugPrint("Image load failed")
                }
            }
        }
    }
}


struct DetailView: View {
    let photo: Photo
    @State private var image: UIImage = UIImage(named: "imagePlaceHolder")!
    @ObjectBinding private var imageLoader = ImageService()
    var body: some View {
        VStack {
            Image(uiImage: self.imageLoader.cachedImageForURL(url: photo.photoURL!))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .border(Color.gray, width: 3, cornerRadius: 16)
            
            MyCustomText(message: photo.title ?? "")
            
        }.onAppear {
            self.imageLoader.loadImageFor(photoUrl: self.photo.photoURL) { result in
                switch result
                {
                case .success(let img) : self.image = img
                default: debugPrint("Image load failed")
                }
            }
        }
//        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle(Text("DetailView").font(.title), displayMode: .inline)
        .padding()
        
    }
}


struct MyCustomText: View {
    let message: String
    var body: some View {
        Text(message)
            .font(.body)
            .foregroundColor(.blue)
            .padding()
            .lineLimit(nil)
            .border(Color.yellow, width: 5, cornerRadius: 12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}
/*
 
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
*/
