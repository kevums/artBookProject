//
//  ViewController.swift
//  ArtBookProjet
//
//  Created by Kevin Landry on 6/28/20.
//  Copyright © 2020 Kevin Landry. All rights reserved.
//

import UIKit
// req for fetch request, etc
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    // remember - there will be a unique uuid assigned to each img
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //these have to be called up by the view controller above as UITableViewDelegate, UITableViewDataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //below reaches top area in view controller that is not used by library items; can choose target item up top and select what it does when clicked
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        getData()
    }
    // this retrieves data from core data database
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // below is a "context variable"; gives us context with the fetch method
        let context = appDelegate.persistentContainer.viewContext
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        // if false, means object wont be used except just put in background; speeds up if using lots of data
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            // assigning to the variable "results" because if it fails, it will provide an array; idk this shit is a blur; turns it into a core data model obj so that "bring me the value for X name/year" can be used
           let results = try context.fetch(fetchRequest)
            
            for results in results as! [NSManagedObject] {
                if let name = results.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                }
            
                if let id = results.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
            // reloads tableview data DUH
                self.tableView.reloadData()
                
            }
        } catch {
            print("error")
        }
        
        
        
    }

    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //displays values for name array
        return nameArray.count
    }
    //defines cell for each indiv row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //displays values for name array
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
}

