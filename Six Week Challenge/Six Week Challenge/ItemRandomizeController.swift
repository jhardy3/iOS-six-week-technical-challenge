//
//  ItemRandomizeController.swift
//  Six Week Challenge
//
//  Created by Jake Hardy on 3/11/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import Foundation
import GameKit

// Class carries out fetches on items, persistence, and randomization
class ItemRandomizerController {
    

    // Creates an item sand stores it in Firebase
    static func createItem(itemName: String) {
        var item = Item(title: itemName, identifier: nil)
        item.randomMatch = "nobody yet"
        item.save()
    }
    
    
    // Observe Items
    static func observeItems(completion: (items: [Item]) -> Void) {
        // Call FirebaseController
        FirebaseController.observeDataAtEndPoint("/item") { (data) -> Void in
            
            guard let itemDictionary = data as? [String : AnyObject] else { completion(items: []) ; return }
            print(itemDictionary)
            
            var itemArray = [Item]()
            
            // Loop through dictionary and create an item for each dictionary
            for item in itemDictionary {
                if let json = item.1 as? [String : AnyObject], let item = Item(json: json, identifier: item.0) {
                    itemArray.append(item)
                }
            }
            
            // complete with item array
            completion(items: itemArray)
        }
    }
    
    
    
    // Randomize Items ( and resave )
    static func randomize(completion: (items : [Item]) -> Void) {
        FirebaseController.dataAtEndPoint("/item/") { (data) -> Void in
            guard let itemDictionary = data as? [String : AnyObject] else { completion(items: []) ; return }
            print(itemDictionary)
            
            var itemArray = [Item]()
            // Loop through dictionary ; create item with each array
            for item in itemDictionary {
                if let json = item.1 as? [String : AnyObject], let item = Item(json: json, identifier: item.0) {
                    itemArray.append(item)
                }
            }
            
            
            // Set firebase to nil to erradicate duplicates
            FirebaseController.firebase.setValue("")
            
            // Creates a shuffled array the same length as the item array and randomly assigns positions in a new array
            // reassigns itemArray to the new Item array with shuffled contents
            let shuffledArray = createRandomNumberArray(itemArray.count)
            var newItemArray = itemArray
            var currentPlace = 0
            
            for index in shuffledArray {
                newItemArray[index] = itemArray[currentPlace]
                currentPlace++
            }
            
            itemArray = newItemArray
            
            
            // Declare arrayCount variable ; used to randomize the titles (this works because the array that is pulled from 
            // firebase is already randomized each time
            
            
            var arrayCount = itemArray.count - 1
            if itemArray.count % 2 == 0 {
                for var item in itemArray {
                    item.randomMatch = itemArray[arrayCount].title
                    arrayCount--
                }
            } else {
                var oddball = itemArray.removeFirst()
                arrayCount = itemArray.count - 1
                for var item in itemArray {
                    item.randomMatch = itemArray[arrayCount].title
                    arrayCount--
                }
                oddball.randomMatch = "... ah who's kidding, forever alone."
                itemArray.append(oddball)
            }
            
            // Complete with itemArray
            completion(items: itemArray)
        }
    }
    
    // Delete Item ; self explanatory ;)
    static func deleteItem(identifier: String, completion: (success: Bool) -> Void) {
        FirebaseController.firebase.childByAppendingPath("/item/\(identifier)").removeValue()
    }
    
    
    // Creates a randomArray
    static func createRandomNumberArray(count: Int) -> [Int] {
        var array = [Int]()
        var countingNumber = 0
        while countingNumber < count {
            array.append(countingNumber)
            countingNumber++
        }
        
        return GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(array) as! [Int]
    }
    
}