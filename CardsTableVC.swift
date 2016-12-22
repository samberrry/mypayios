//
//  CardsTableVC.swift
//  mypay
//
//  Created by Hessam on 12/22/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class CardsTableVC: UITableViewController {
    
    //MARK: Properties
    static var cards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CardsTableVC.cards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let item = CardsTableVC.cards[indexPath.row]
        // Configure the cell...
        cell.labelCardName.text = item.cardName
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backIsClicked(_ sender: UIBarButtonItem) {
            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToShoppingList(sender: UIStoryboardSegue) {
        if let source = sender.source as? AddCardVC , let card = source.card
        {
            let newIndexPath = NSIndexPath(row: CardsTableVC.cards.count, section:0)
            CardsTableVC.cards.append(card)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            saveCards()
        }
    }
    
    //MARK: NSCoding
    func saveCards() {
        let isSuccessfulsave = NSKeyedArchiver.archiveRootObject(CardsTableVC.cards, toFile: Card.ArchiveURL.path)
        if !isSuccessfulsave {
            print("Failed to save meals...")
        }
    }

}
