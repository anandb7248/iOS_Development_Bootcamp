//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Anand Batjargal on 2/15/19.
//  Copyright © 2019 anandbatjargal. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var todoListArray: [TodoItem] = []
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Create a plist file in the iOS sandbox, user directory
    // Where we will store our custom data model
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Filemanager")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todoItem = todoListArray[indexPath.row]
        
        cell.textLabel?.text = todoItem.title
        cell.accessoryType = todoItem.done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle todo list checkmark on/off
        
        todoListArray[indexPath.row].done = !todoListArray[indexPath.row].done
        
        saveTodoItems()
        tableView.reloadData()
        // Remove gray selected background
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
            /*
            // Codable Method
            let newTodo = TodoItem(title: textField.text!, done: false)
            self.todoListArray.append(newTodo)
            */
            
            // CoreData Method
            // let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newTodo = TodoItem(context: self.viewContext)
            newTodo.title = textField.text!
            newTodo.done = false
            newTodo.parentCategory = self.selectedCategory
            //
            
            self.todoListArray.append(newTodo)
            
            self.saveTodoItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveTodoItems() {
        /*
         // Codable Method
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(todoListArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding todoListArray: \(error)")
        }
        */
        
        // CoreData Method
        do{
            try viewContext.save()
        }catch {
            print("Error trying to save CoreData contect \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil){
        /*
         // Codable Method
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()

            do{
                todoListArray = try decoder.decode([TodoItem].self, from: data)
            }catch{
                print("Error decoding todoListArray: \(error)")
            }

        }
        */
        
         // CoreData Method
        //let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        

//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        
        do {
            todoListArray = try viewContext.fetch(request)
        } catch {
            print("Error trying to fetch TodoItems: \(error)")
        }
        
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

// MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
//        do {
//            todoListArray = try viewContext.fetch(request)
//        } catch {
//            print("Error trying to fetch TodoItems: \(error)")
//        }
        
        // tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0) {
            loadItems()
            
            searchBar.resignFirstResponder()
        }
    }
}
