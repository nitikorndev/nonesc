//
//  ViewController.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 17/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import Moya

class ProfileViewController: UIViewController {

    static let NOTIFICATION_CELL_IDENTIFIER = "NOTIFICATION_CELL"
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingValueLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followerValueLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeValueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultView: UIView!
    
    // Error view
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorDescLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    var viewModel: ProfileViewModel = ProfileViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableview()
        setupView()
        bindInputs()
        bindOutputs()
        viewModel.inputs.onViewDidLoad()
    }
    
    func setupView() {
        errorDescLabel.text = "You are Offline"
        retryButton.backgroundColor = .yellow
        retryButton.layer.cornerRadius = 12
        retryButton.clipsToBounds = true
        retryButton.setTitle("Retry", for: .normal)
    }
    
    func bindInputs() {
        retryButton
        .rx
        .tap
        .asDriver()
        .drive(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.errorView.isHidden = true
            self.viewModel.inputs.onRetryButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    func bindOutputs() {
        
        viewModel
            .outputs
            .isError
            .drive(onNext: { [weak self] (error) in
                guard let `self` = self else { return }
                if let _error = error as? MoyaError {
                    switch _error {
                    case .underlying:
                        self.errorView.isHidden = false
                        self.resultView.isHidden = true
                    default:
                        print("handle other cases")
                    }
                } else {
                    self.errorView.isHidden = false
                    self.resultView.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        viewModel
            .outputs
            .isLoading
            .drive(UIApplication.shared.rx.isNetworkIndicatorAnimated)
            .disposed(by: disposeBag)
        
        viewModel
        .outputs
        .dataSource
        .drive(tableView.rx.items) { (tableView, row, item) in
            
            let indexPath = IndexPath(item: row, section: 0)

            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewController.NOTIFICATION_CELL_IDENTIFIER, for: indexPath) as? NotificationCell {
                cell.descLabel.text = item.text
                let notificationFormatter = DateFormatter.notificationFormatter
                if let _createdDate = item.created {
                    cell.notificationDateLabel.text = notificationFormatter.string(from: _createdDate)
                    cell.notificationDateLabel.isHidden = false
                } else {
                    cell.notificationDateLabel.isHidden = true
                }
                if indexPath.row % 2 == 0 {
                    cell.containerView.backgroundColor = .white
                } else {
                    cell.containerView.backgroundColor = .gray
                }
                return cell
            }
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        viewModel
        .outputs
        .profileData
        .drive(onNext: { [weak self] (user) in
            guard let `self` = self else { return }
            
            self.errorView.isHidden = true
            self.resultView.isHidden = false
            
            self.followerLabel.text = "Followers"
            self.likeLabel.text = "Likes"
            self.followingLabel.text = "Followings"
            
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
            self.profileImageView.clipsToBounds = true
            self.profileImageView.sd_setImage(with: URL(string: user.avatar ?? ""), completed: nil)
            
            if let _firstName = user.firstName, let _lastName = user.lastName {
                self.nameLabel.text = _firstName + " " + _lastName
            }

            if let followers = user.followers {
                self.followerValueLabel.text = "\(followers)"
            } else {
                self.followerValueLabel.text = "-"
            }
            if let following = user.following {
                self.followingValueLabel.text = "\(following)"
            } else {
                self.followingValueLabel.text = "-"
            }
            if let likes = user.likes {
                self.likeValueLabel.text = "\(likes)"
            } else {
                self.likeValueLabel.text = "-"
            }
        }).disposed(by: disposeBag)
    }
    
    func setupTableview() {
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: ProfileViewController.NOTIFICATION_CELL_IDENTIFIER)
    }
}
