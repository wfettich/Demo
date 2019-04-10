//
//  DetailContentViewController.swift
//  Demo
//
//  Created by Walter Fettich on 05/04/2019.
//  Copyright © 2019 Walter Fettich. All rights reserved.
//

import UIKit

class DetailContentViewController: UITableViewController, TagsCollectionViewDelegate
{
    @IBOutlet weak var viewContent1: ContentView1!

    var modelObject: ModelObject? {
        didSet {
            viewContent1.modelObject = modelObject
        }
    }
    
    @IBOutlet weak var viewTagBar: UIView!
    
    @IBOutlet weak var viewTags: UIView!
    
    let tagBarVC = TagsViewController()
    
    let tagsVC = TagsViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tagsVC.addTagComponentToContainerView(parentVC: self,containerView: viewTags)
        tagsVC.delegate = self
        tagsVC.tags.setData([
            Tag(name:"lalala    ",value:"1",category:"test",selected:false,optional:false ),
            Tag(name:"mumu   ",value:"2",category:"test",selected:false,optional:true ),
            Tag(name:"cucu  ",value:"3",category:"test",selected:true,optional:true ),
            Tag(name:"baba ",value:"4",category:"test",selected:false,optional:false ),
            Tag(name:"dododa",value:"5",category:"test",selected:false,optional:false )
            ])
        
        tagBarVC.addTagComponentToContainerView(parentVC: self,containerView: viewTagBar)
        tagBarVC.directionHorizontal = true
        tagBarVC.delegate = self
        tagBarVC.tags.setData([
            Tag(name:"bar",value:"b1",category:"tagBar",selected:false,optional:false ),
            Tag(name:"cafe",value:"b2",category:"tagBar",selected:false,optional:true ),
            Tag(name:"cucu",value:"b3",category:"tagBar",selected:true,optional:true ),
            Tag(name:"baba ",value:"b4",category:"tagBar",selected:false,optional:false ),
            Tag(name:"mumux",value:"b5",category:"tagBar",selected:false,optional:false ),
            Tag(name:"gugu",value:"b6",category:"tagBar",selected:false,optional:false ),
            Tag(name:"tztzt",value:"b7",category:"tagBar",selected:false,optional:false )
            ])

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func dataSetChanged(_ tagController: TagsViewController, newDataSet: TagViewModelProtocol?)
    {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
