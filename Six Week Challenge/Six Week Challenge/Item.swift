//
//  Item.swift
//  Six Week Challenge
//
//  Created by Jake Hardy on 3/11/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import Foundation

// Class Item is an object that can accept any "form" of object so long as it has a string title

struct Item: FirebaseType {
    
    // MARK: - Class Keys
    
    var ktitle = "title"
    var krandomMatch = "randomMatch"
    
    // MARK: - Firebase Type Properties
    var identifier: String?
    
    var endpoint: String {
        return "/item/"
    }
    
    var jsonValue: [String : AnyObject] {
        get {
            
            return [
                ktitle : title,
                krandomMatch : randomMatch ?? ""
            ]
        }
    }
    
    // MARK: - Struct Properties
    
    var title: String
    var randomMatch: String? {
        didSet {
            self.save()
        }
    }
    
    // Strucct Init
    init(title: String, identifier: String?) {
        self.title = title
        if let identifier = identifier {
            self.identifier = identifier
        }
    }
    
    // Failable Firebase initializer
    init?(json: [String : AnyObject], identifier: String) {
        guard let title = json[ktitle] as? String else { self.title = "" ; return nil }
        self.title = title
        self.identifier = identifier
        if let randomMatch = json[krandomMatch] as? String {
            self.randomMatch = randomMatch
        }
    }
    
    
    
}