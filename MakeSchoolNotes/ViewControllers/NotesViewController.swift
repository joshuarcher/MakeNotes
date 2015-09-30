//
//  NotesViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Updated by Chris Orcutt on 09/07/2015.
//  Copyright © 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UITableViewController {
    
    var selectedNote: Note!
    
    var notes: Results<Note>! {
        didSet {
            // Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        do {
            let realm = try Realm()
            notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        } catch {
            print("handle error")
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
            
            do {
                let realm = try Realm()
                
                switch identifier {
                case "Save":
                    
                    let source = segue.sourceViewController as! NewNoteViewController
                    
                    try realm.write() {
                        realm.add(source.currentNote!)
                    }
                    
                case "Delete":
                    
                    try realm.write() {
                        realm.delete(self.selectedNote!)
                    }
                    
                    let source = segue.sourceViewController as! NoteDisplayViewController
                    source.note = nil
                    
                default:
                    print("nobody likes \(identifier)")
                    
                }
                
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
                
            } catch {
                print("handle error")
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper functions
    
    func deleteNote(note: Note, realm: Realm) {
        
        do  {
            try realm.write() {
                realm.delete(note)
            }
        } catch {
            print("handle error")
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExistingNote") {
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController
            noteViewController.note = selectedNote
        }
    }
    
  
}

extension NotesViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //1
        
//        cell.titleLabel.text = "Hello"
//        cell.dateLabel.text = "Today"
        
        let row = indexPath.row
        let note = notes[row] as Note
        cell.note = note
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedNote = notes[indexPath.row]
        
        self.performSegueWithIdentifier("ShowExistingNote", sender: self)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let note = notes[indexPath.row] as Note
            
            do {
                let realm = try Realm()
                try realm.write() {
                    realm.delete(note)
                }
                
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
            } catch {
                print("handle error")
            }
        }
    }
    
}