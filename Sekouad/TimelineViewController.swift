//
//  TimelineViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

class Sekouad {
    var title: String
    var lastUpdate: String
    var emoji: String
    var thumbnail: String?
    
    init(title: String, lastUpdate: String, emoji: String, thumbnail: Int) {
        self.title = title
        self.lastUpdate = lastUpdate
        self.emoji = emoji
        self.thumbnail = "thumbnail-\(thumbnail)"
    }
}

class TimelineModel {
    
    let sections = ["Perso", "Récents", "Populaires"]
    let sekouads = [
        [Sekouad(title: "BritneyFans", lastUpdate: "5 min", emoji: "👯", thumbnail: 1), Sekouad(title: "PTDR", lastUpdate: "9 min", emoji: "😂", thumbnail: 2)],
        [Sekouad(title: "Wonderboys", lastUpdate: "5 min", emoji: "🦄", thumbnail: 1), Sekouad(title: "Devildu92", lastUpdate: "9 min", emoji: "😵", thumbnail: 2), Sekouad(title: "Avocado", lastUpdate: "1 h", emoji: "🥑", thumbnail: 3)],
        [Sekouad(title: "BlueTeam", lastUpdate: "1 h", emoji: "🥑", thumbnail: 4), Sekouad(title: "Oreo", lastUpdate: "5 min", emoji: "🍿", thumbnail: 4), Sekouad(title: "Fitness", lastUpdate: "23 h", emoji: "💪", thumbnail: 1)]
    ]
}

class HeaderView: UIView {
    @IBOutlet var titleLabel: UILabel!
}

class TimelineViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: HeaderView!

    let model = TimelineModel()
    
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

//MARK: - UIView Extensions

extension UIView {
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}
