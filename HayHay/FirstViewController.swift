//
//  FirstViewController.swift
//  HayHay
//
//  Created by Lacie on 3/18/16.
//  Copyright © 2016 Lacie. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var topLogo: UIBarButtonItem!
    @IBOutlet weak var threadTable: UITableView!
    
    var threads = [Thread]()
    
    //MARK: Actions

    
    override func viewDidAppear(animated: Bool) {
        topLogo.image?.imageWithRenderingMode(.AlwaysOriginal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.threadTable.dataSource = self
        
        loadSampleThreads()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadSampleThreads() {
        let thread1 = Thread(content:"Wish I could write more. But the words are just floating away. I need to write this longer. I am running out of creativity hihihihihihihihihihihihihihihihihihi", time: "2min", topic: nil)
        
        let thread2 = Thread(content:"Testingtesting", time: "2min", topic: nil)
        
        threads.append(thread1!)
        threads.append(thread2!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.threads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ThreadTableViewCell"
        let cell:ThreadTableViewCell! = self.threadTable.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ThreadTableViewCell
        
        let thread = self.threads[indexPath.row]
        cell.content.text = thread.content
        cell.time.text = thread.time
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }



}

