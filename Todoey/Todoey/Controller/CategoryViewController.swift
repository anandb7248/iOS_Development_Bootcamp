//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anand Batjargal on 2/16/19.
//  Copyright © 2019 anandbatjargal. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destination = segue.destination as! TodoListViewController
            
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                destination.selectedCategory = categoryArray?[selectedRow]
            }
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            field.placeholder = "New category"
            textField = field
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in

            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error trying to save category in Realm: \(error)")
        }
    }
    
    func loadCategories() {
        
        do {
            categoryArray = realm.objects(Category.self)
            tableView.reloadData()
        }catch {
            print("Error trying to load category in Realm: \(error)")
        }
    }
}
