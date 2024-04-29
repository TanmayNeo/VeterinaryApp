//
//  ViewController.swift
//  VeterinaryApp
//
//  Created by Tanmay on 27/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            tblView.delegate = self
            tblView.dataSource = self
            tblView.register(UINib(nibName: PetDetailTableViewCell.identifier,
                                   bundle: nil),
                             forCellReuseIdentifier: PetDetailTableViewCell.identifier)
            tblView.register(UINib(nibName: ClinicDetailHeaderView.identifier,
                                   bundle: nil),
                             forHeaderFooterViewReuseIdentifier: ClinicDetailHeaderView.identifier)
        }
    }
    private var viewModel: ViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        addListeners()
        viewModel.loadData()
    }

    private func initViewModel() {
        let apiService = APIService(networkManager: NetworkManager.shared)
        viewModel = ViewModel(apiService: apiService)
    }
    
    private func addListeners() {
        viewModel.clinicDetailsFailed = { errorString in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.showAlert(title: "VeterinaryApp", message: errorString)
                
            }
        }
        
        viewModel.petDataFailed = { errorString in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.showAlert(title: "VeterinaryApp", message: errorString)
                
            }
        }
        
        viewModel.dataLoadCompleted = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.tblView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getPetsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PetDetailTableViewCell.identifier,
                                                       for: indexPath) as? PetDetailTableViewCell else {return UITableViewCell()}
        cell.setup(petDetails: viewModel.getPet(for: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ClinicDetailHeaderView.identifier) as? ClinicDetailHeaderView else {return UIView()}
        headerView.setup(clinicDetails: viewModel.getClinicDetails(), delegate: self)
        
        return headerView
    }
    
}

extension ViewController {
    private func showAlert(title: String?, message: String?, okActionTitle: String = "OK", okActionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okActionTitle,
                                     style: .default) { _ in
            alertController.dismiss(animated: true)
            okActionHandler?()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

extension ViewController: ClinicHeaderViewDelegate {
    func didClickChatBtn() {
       showWorkHoursAlert()
        
    }
    
    func didClickCallBtn() {
        showWorkHoursAlert()
    }
    
    private func showWorkHoursAlert() {

        showAlert(title: "VeterinaryApp", message: viewModel.formatWorkHours())
    }
}
