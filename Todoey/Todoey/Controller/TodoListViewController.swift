//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Anand Batjargal on 2/15/19.
//  Copyright © 2019 anandbatjargal. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var itemResults: Results<Item>?
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.colorHexVal {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist!")}
            
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                
                searchBar.tintColor = navBarColor
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "0974C0") else {fatalError()}
        
        navigationController?.navigationBar.tintColor = originalColor
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : FlatWhite()]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let todoItem = itemResults?[indexPath.row]{
            cell.textLabel?.text = todoItem.title
            cell.accessoryType = todoItem.done ? .checkmark : .none
            if let categoryColor = UIColor(hexString: selectedCategory!.colorHexVal)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemResults!.count)){
                cell.backgroundColor = categoryColor
                cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            }
            
            
            
        }else{
            cell.textLabel?.text = "No items added"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedItem = itemResults?[indexPath.row] {
            do{
                try realm.write {
                    selectedItem.done = !selectedItem.done
                }
            }catch{
                print("Error updating selected item: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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

    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            
            if let newCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newTodo = Item()
                        newTodo.title = textField.text!
                        newTodo.dateCreated = Date()
                        newCategory.items.append(newTodo)
                    }
                    
                }catch {
                    print("Error trying to add todo item in Realm\(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){

        itemResults = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.itemResults?[indexPath.row]{
            
            do{
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            }catch{
                print("Error deleting todo item in Realm: \(error)")
            }
        }
    }
}

// MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemResults = itemResults?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0) {
            loadItems()

            searchBar.resignFirstResponder()
        }
    }
}
