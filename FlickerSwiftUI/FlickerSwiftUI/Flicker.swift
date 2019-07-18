//
//  Flicker.swift
//  Flicker
//
//  Created by Ranjeet on 13/07/19.
//  Copyright © 2019 Ranjeet. All rights reserved.
//

import Foundation
import SwiftUI

class SearchTerm {
    var text: String
    var page = 0
    
    init(text: String) {
        self.text = text
    }
}

class Flicker: Codable {
    var photos: Photos?
    let stat: String?
}

struct Photos: Codable {
    let page, pages, perpage: Int?
    let total: String?
    var photo: [Photo]?
}

struct Photo: Codable, Identifiable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    
    var photoURL: URL? {
        guard let farm = self.farm, let server = self.server, let secret = self.secret, let id = self.id else {
            return nil
        }
        let strURL = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        guard let url = URL(string: strURL) else {
            return nil
        }
        return url
    }
}
