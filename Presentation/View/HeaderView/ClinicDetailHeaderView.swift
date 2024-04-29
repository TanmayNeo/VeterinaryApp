//
//  ClinicDetailHeaderView.swift
//  VeterinaryApp
//
//  Created by Tanmay on 27/04/24.
//

import UIKit

protocol ClinicHeaderViewDelegate: NSObject {
    func didClickChatBtn()
    func didClickCallBtn()
}

class ClinicDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var chatBtn: UIButton!  {
        didSet {
            chatBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var callBtn: UIButton! {
        didSet {
            callBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var btnParentView: UIView!
    @IBOutlet weak var workingHrsLabel: UILabel! {
        didSet {
            workingHrsLabel.layer.borderWidth = 1
            workingHrsLabel.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    weak var delegate: ClinicHeaderViewDelegate?

    func setup(clinicDetails: ConfigResponse?, delegate: ClinicHeaderViewDelegate?) {
        workingHrsLabel.text = clinicDetails?.settings?.workHours
        let isCallEnabled = clinicDetails?.settings?.isCallEnabled ?? false
        let isChatEnabled = clinicDetails?.settings?.isChatEnabled ?? false
        callBtn.isHidden = !(isCallEnabled)
        chatBtn.isHidden = !(isChatEnabled)
        btnParentView.isHidden = !(isCallEnabled || isChatEnabled)
        self.delegate = delegate
    }
    
    @IBAction func  didClickChatBtn() {
        delegate?.didClickChatBtn()
    }
    
    @IBAction func didClickCallBtn() {
        delegate?.didClickCallBtn()
    }
}
