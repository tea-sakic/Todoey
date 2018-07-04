//
//  ViewController.swift
//  Todoey
//
//  Created by Tea Sakic on 27/06/2018.
//  Copyright © 2018 Tea Sakic. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Items]()
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        
    }

    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titleOfItem
     
        cell.accessoryType = item.isItDone ? .checkmark : .none
        
        return cell
        
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].isItDone = !itemArray[indexPath.row].isItDone
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

    // MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user click add item
           
            
            let newItem = Items(context: self.context)
            newItem.titleOfItem = textField.text!
            newItem.isItDone = false
            newItem.parentCategory = self.selectedCategory
        
            self.itemArray.append(newItem)
            
 //         self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        }  catch {
            print("Error saving context!")
        }
         self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Items> = Items.fetchRequest(), predicate : NSPredicate? = nil ) {

        let CategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let aditionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, aditionalPredicate])
            
        } else {
            
            request.predicate = CategoryPredicate
            
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
//
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context")
        }
    }
    
}

//MARK: - SearchBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Items> = Items.fetchRequest()
       
        let predicate = NSPredicate(format: "titleOfItem CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "titleOfItem", ascending: true)]
        
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    
}

