//
//  RegisterViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/27.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameValidation: UILabel!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordValidation: UILabel!
    
    @IBOutlet weak var repeatedPassword: UITextField!
    @IBOutlet weak var repeatedPasswordValidation: UILabel!
    
    @IBOutlet weak var signup: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "注册"
        
        
        
        let viewModel = GitHubSignupViewModel(
            input: (
                username: username.rx.text.orEmpty.asDriver(),
                password: password.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPassword.rx.text.orEmpty.asDriver(),
                loginTaps: signup.rx.tap.asSignal()
            ), dependency: (
                networkService: GitHubNetworkService(),
                signupService: GitHubSignupService()))
        
        viewModel.validatedUsername
            .drive(usernameValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatedPassword
            .drive(passwordValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.signupEnabled.drive(onNext: { [weak self](valid) in
            self?.signup.isEnabled = valid
            self?.signup.alpha = valid ? 1.0 : 0.3
            }).disposed(by: disposeBag)
        
        viewModel.signupResult.drive(onNext: { (result) in
            self.showMessage("注册 \(result ? "成功" : "失败")")
            }).disposed(by: disposeBag)
 
        BehaviorRelay
    }

    //详细提示框
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
