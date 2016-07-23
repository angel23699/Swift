//
//  CancionParser.swift
//  SwiftDemo01
//
//  Created by Angel Arce Carrillo on 20/05/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import Foundation

class CancionParser: NSObject {
    
    let KEY_SONG: String = "canciones"
    let KEY_ARTIST: String = "artistas"
    let KEY_URL: String = "url"
    
    func parserSongWithDictionary(dictionary: NSMutableDictionary) -> CancionDTO {
        
        let nameSong: String = (dictionary[KEY_SONG])! as! String
        let nameArtist: String = (dictionary[KEY_ARTIST])! as! String
        let iconURL: String = (dictionary[KEY_URL])! as! String
        
        let cancionDTO = CancionDTO()
        cancionDTO.nameSong = nameSong
        cancionDTO.nameArtist = nameArtist
        cancionDTO.urlImage = iconURL
        
        return cancionDTO
    }
}