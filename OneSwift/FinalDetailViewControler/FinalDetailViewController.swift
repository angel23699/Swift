//
//  FinalDetailViewController.swift
//  OneSwift
//
//  Created by Angel Arce Carrillo on 28/05/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import UIKit

class FinalDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var modelo: CancionDTO = CancionDTO()
    
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var nameArtist: UILabel!
    
    let data = [["Blanco", "Rojo", "Verde", "Azul"], ["Blanco", "Rojo", "Verde", "Azul"], ["Blanco", "Rojo", "Verde", "Azul"], ["Blanco", "Rojo", "Verde", "Azul"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DownloadImageWithURL().downloadImage(NSURL(string: modelo.urlImage)!, imageView: self.imageSong)
        nameSong.text = modelo.nameSong
        nameArtist.text = modelo.nameArtist
        
        self.myPicker.dataSource = self
        self.myPicker.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (row == 0) {
            self.view.backgroundColor = UIColor.whiteColor()
        } else if (row == 1) {
            self.view.backgroundColor = UIColor.redColor()
        } else if (row == 2) {
            self.view.backgroundColor = UIColor.greenColor()
        } else {
            self.view.backgroundColor = UIColor.blueColor()
        }
    }
}
