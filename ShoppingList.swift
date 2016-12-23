//
//  MainTableVC.swift
//  mypay
//
//  Created by Hessam on 12/9/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class ShoppingList: UIViewController,UITableViewDelegate,UITableViewDataSource{

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    static var goodsList = [Goods]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedCards = loadCards(){
            CardsTableVC.cards += savedCards
        }else{
            print("failed to load data!")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ShoppingList.goodsList.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainMenuCell", for: indexPath) as! MainMenuCell
        let item = ShoppingList.goodsList[indexPath.row]
        // Configure the cell...
        cell.labelName.text = item.name
        cell.labelPrice.text = "Price: \(String(item.price))$"
        cell.labelDescription.text = "Description: \(item.description)"
        
        return cell
    }
 
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ShoppingList.goodsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    //  to support rearranging the table view.
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    //  to support conditional rearranging of the table view.
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: NSCoding
    func loadCards() -> [Card]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Card.ArchiveURL.path) as? [Card]
    }
}
