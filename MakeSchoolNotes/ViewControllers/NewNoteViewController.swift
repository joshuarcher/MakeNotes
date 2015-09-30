//
//  NewNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Joshua Archer on 9/27/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import UIKit
import RealmSwift

class NewNoteViewController: UIViewController {
    
    var newNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        newNote = Note()
        newNote!.title = "Simple note title"
        newNote!.content = "Some simple content"
        
    }


}