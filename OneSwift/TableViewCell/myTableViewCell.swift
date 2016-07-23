//
//  TableViewCell.swift
//  SwiftDemo01
//
//  Created by Angel Arce Carrillo on 22/05/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {
    
    @IBOutlet var miImagen: UIImageView!
    @IBOutlet var labelNameSong: UILabel!
    @IBOutlet var labelArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
