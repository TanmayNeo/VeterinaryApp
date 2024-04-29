//
//  PetDetailHeaderViewTableViewCell.swift
//  VeterinaryApp
//
//  Created by Tanmay on 27/04/24.
//  Copyright © 2024 Tanmay Khopkar. All rights reserved.
//

import UIKit

class PetDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var petImgView: UIImageView!
    @IBOutlet weak var petNameLbl: UILabel!
    @IBOutlet weak var seperatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(petDetails: Pet?) {
        petNameLbl.text = petDetails?.title
        petImgView.downloaded(from: petDetails?.imageURL)
    }
    
}
