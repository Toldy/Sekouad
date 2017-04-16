//
//  TimelineFakeModel.swift
//  Sekouad
//
//  Created by Julien Colin on 17/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import Foundation

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

class TimelineFakeModel {
    
    let sections = ["Perso", "Récents", "Populaires"]
    let sekouads = [
        [Sekouad(title: "BritneyFans", lastUpdate: "5 min", emoji: "👯", thumbnail: 1), Sekouad(title: "PTDR", lastUpdate: "9 min", emoji: "😂", thumbnail: 2)],
        [Sekouad(title: "Wonderboys", lastUpdate: "5 min", emoji: "🦄", thumbnail: 1), Sekouad(title: "Devildu92", lastUpdate: "9 min", emoji: "😵", thumbnail: 2), Sekouad(title: "Avocado", lastUpdate: "1 h", emoji: "🥑", thumbnail: 3)],
        [Sekouad(title: "BlueTeam", lastUpdate: "1 h", emoji: "🥑", thumbnail: 4), Sekouad(title: "Oreo", lastUpdate: "5 min", emoji: "🍿", thumbnail: 4), Sekouad(title: "Fitness", lastUpdate: "23 h", emoji: "💪", thumbnail: 1)]
    ]
}
