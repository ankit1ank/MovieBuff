//
//  HistoryPopoverViewController.swift
//  MovieBuff
//
//  Created by Ankit Goel on 12/01/16.
//  Copyright © 2016 ankitgoel. All rights reserved.
//

import UIKit

class HistoryPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var historyArray: [String] = []
    
    @IBOutlet weak var noHistoryLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let history = defaults.objectForKey("historyArray") as? [String] {
            self.historyArray = history 
        }
    }
    
    //MARK:- Table View Datasource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyArray.count == 0 {
            self.historyTableView.hidden = true
            self.noHistoryLabel.hidden = false
        } else {
            self.historyTableView.hidden = false
            self.noHistoryLabel.hidden = true
        }
        return historyArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell")
        cell?.textLabel?.text = historyArray[indexPath.row]
        return cell!
    }
    
    // MARK:- Popover Presentation
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
