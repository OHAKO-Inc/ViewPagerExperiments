//
//  ContentViewController.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/05.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func buttonDidTap(sender: AnyObject) {
        print("buttonDidTap")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ContentViewController viewDidLoad")
    }
}

extension ContentViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

