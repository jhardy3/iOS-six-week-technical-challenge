//
//  IntroItemViewController.swift
//  Six Week Challenge
//
//  Created by Jake Hardy on 3/11/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//


// IN RETROSPECT - I could have moved the network calls for items into their own controller considering 
// itemRandomizerController seems rather specific. Hindisght is 20/20




import UIKit

class IntroItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    var items = [Item]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemEnterTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Begins observing items and pulling them down from firebase for every change. Updates view on main thread
        ItemRandomizerController.observeItems { (items) -> Void in
            self.items = items
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Sweet!", forIndexPath: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        let match = item.randomMatch ?? "Jeff"
        cell.detailTextLabel?.text = "Matched with \(match)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = items[indexPath.row]
            guard let itemID = item.identifier else { return }
            ItemRandomizerController.deleteItem(itemID, completion: { (success) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    
    @IBAction func randomizeButtonTapped(sender: UIButton) {
        if items.count >= 2 {
            ItemRandomizerController.randomize({ (items) -> Void in
                self.items = items
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    @IBAction func enterObjectTapped(sender: UIButton) {
        guard let itemName = itemEnterTextField.text where  itemName.isEmpty == false else { return }
        itemEnterTextField.text = ""
        ItemRandomizerController.createItem(itemName)
    }
}
