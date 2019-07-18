//
//  FlickerService.swift
//  Flicker
//
//  Created by Ranjeet on 13/07/19.
//  Copyright © 2019 Ranjeet. All rights reserved.
//

import Foundation
import UIKit
import Combine
import SwiftUI

/**
 This service manager is resposible to makeing request and recived processed response.
 It initialized depends on the Session to make request. So we can use Mock Session for tesing.
 It will store the image in imageCache object with url as key.
 */

enum ServiceError: Error {
    case failToCreateURL
    case serverError
    case conversionError
    case noNetwork
}

class FlickerServiceManager: BindableObject
{
    
    var didChange = PassthroughSubject<Void, Never>()
    
    var flicker: Flicker? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send()
            }
        }
    }
    
    var photos: [Photo] {
        flicker?.photos?.photo ?? []
    }
    
    private var session: URLSession
    //Dependency injection of URLSession used to actual network call and mock call for testing
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    
    func flickerRequest(_ search: SearchTerm) {
        //custruct URL
        var str = String("\(baseURL)/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1&safe_search=1&text=\(search.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
        
        str += ((search.page > 0) ? "&page=\(search.page)" : "&page=1")
        
        guard let url = URL(string: str) else {
            self.flicker = nil
            return
        }
     
        //Request for the fliker data
        self.session.codableTask(with: url) { (flicker: Flicker?, response, error) in
            if error != nil {
                self.flicker = nil
            } else {
                self.flicker = flicker
            }
            
        }.resume()
    }
    
}

class ImageService: BindableObject {
    private var imageCache = NSCache<NSString, UIImage>()
    private var session: URLSession
    private var url: URL?
    //Dependency injection of URLSession used to actual network call and mock call for testing
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send()
            }
        }
    }
    
    func cachedImageForURL(url: URL) -> UIImage {
        return self.imageCache.object(forKey: url.absoluteString as NSString) ?? UIImage(named: "imagePlaceHolder")!
    }
    
    var didChange = PassthroughSubject<Void, Never>()
    
    @discardableResult func loadImageFor(photoUrl url: URL?, receivedData:((Result<UIImage, ServiceError>)->())? = nil) -> UIImage {
        self.url = url
        
        let placeHolderImage = UIImage(named: "imagePlaceHolder")!
        guard let url = url else { return placeHolderImage }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return cachedImage
        } else {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            let task = self.session.dataTask(with: request) { (data, responce, error) in
                guard let data = data, error == nil else {
                    receivedData?(.failure(.conversionError))
                    self.image = nil
                    return
                }
                guard let image = UIImage(data: data) else {
                    receivedData?(.failure(.conversionError))
                    self.image = nil
                    return
                }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                receivedData?(.success(image))
                self.image = image
            }
            task.resume()
            return placeHolderImage
        }
    }
}

// MARK: - URLSession
extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
}

