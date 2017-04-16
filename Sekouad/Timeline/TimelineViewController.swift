//
//  TimelineViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet var titleLabel: UILabel!
}

class TimelineViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: HeaderView!

    let model = TimelineFakeModel()
    
    @IBAction func addSekouad(_ sender: Any) {
        print("addSekouad")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sekouads[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCellReuseIdentifier", for: indexPath) as! TimelineTableViewCell
        
        let sekouad = model.sekouads[indexPath.section][indexPath.row]
        cell.setup(sekouad: sekouad, indexPath: indexPath)
        
        return cell
    }
}

extension TimelineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionName = model.sections[section]
        
        headerView.titleLabel.text = sectionName
        return headerView.copyView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView.copyView()
    }
}
