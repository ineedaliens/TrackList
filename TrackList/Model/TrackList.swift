//
//  TrackList.swift
//  TrackList
//
//  Created by Евгений on 20.12.2020.
//

import RealmSwift

class TrackList: Object {
    @objc dynamic var artist = ""
    @objc dynamic var album: String?
    @objc dynamic var song: String?
    @objc dynamic var cover: Data?
    @objc dynamic var data: String?
    @objc dynamic var bio: String?
    @objc dynamic var link: String?
    
    
    convenience init(artist: String, album: String!, song: String!, cover: Data?, data: String!, bio: String!, link: String!) {
        self.init()
        self.artist = artist
        self.album = album
        self.song = song
        self.cover = cover
        self.data = data
        self.bio = bio
        self.link = link
    }
}
