//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Joshua Archer on 9/27/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import UIKit
import RealmSwift

class NoteDisplayViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayNote(self.note)
        
        titleTextField.returnKeyType = .Next
        titleTextField.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView  {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if note.title.characters.count == 0 && note.content.characters.count == 0 {
                titleTextField.becomeFirstResponder()
            }
        }
    }
    
    func saveNote() {
        if let note = note {
            do {
                let realm = try Realm()
                
                try realm.write() {
                    if (note.title != self.titleTextField.text || note.content != self.contentTextView.text) {
                        note.title = self.titleTextField.text!
                        note.content = self.contentTextView.text
                        note.modificationDate = NSDate()
                    }
                }
            } catch {
                print("handle error")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoteDisplayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {  //1
            contentTextView.returnKeyType = .Done
            contentTextView.becomeFirstResponder()
        }
        
        return false
    }
}
