//
//  GitHubSignupViewModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/27.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ValidationResult {
    case validating
    case empty
    case ok(message: String)
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .validating:
            return "正在验证..."
        case .empty:
            return ""
        case let .ok(message):
            return message
        case let .failed(message):
            return message
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .validating:
            return .gray
        case .empty:
            return .black
        case .ok:
            return .green
        case .failed:
            return .red
        }
    }
}


class GitHubSignupService {
    
    let minPasswordCount = 5
    
    func validateUsername(_ username:String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        /// 判断用户名是否只有数字和字母
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字和字母"))
        }
        return GitHubNetworkService.usernameAvailable(username).map { (available) in
            return available ? .ok(message: "用户名可用") : .failed(message: "用户名已存在")
        }
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码至少需要 \(minPasswordCount) 个数子字母")
        }
        return .ok(message: "密码o有效")
    }
    
    /// 二次验证密码
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
        if repeatedPassword == password {
            return .ok(message: "密码有效")
        }else{
            return .failed(message: "两次输入密码不一致")
        }
    }
}



class GitHubSignupViewModel {
    
    /// 用户名验证结果
    let validatedUsername: Driver<ValidationResult>
    
    let validatedPassword: Driver<ValidationResult>
    
    let validatedPasswordRepeated: Driver<ValidationResult>
    /// 注册按钮是否可用
    let signupEnabled: Driver<Bool>
    /// 正在注册中
    let signingIn: Driver<Bool>
    /// 注册结果
    let signupResult: Driver<Bool>

    
    init(input: (
        username: Driver<String>,
        password: Driver<String>,
        repeatedPassword: Driver<String>,
        loginTaps: Signal<Void>),
         dependency: (
        networkService: GitHubNetworkService,
        signupService: GitHubSignupService)
    ) {
        validatedUsername = input.username.flatMapLatest({ (username) in
            return dependency.signupService.validateUsername(username).asDriver(onErrorJustReturn: .failed(message: "拂去"))
        })
        
        validatedPassword = input.password.map{
            password in
            return dependency.signupService.validatePassword(password)
        }
        
        validatedPasswordRepeated = Driver.combineLatest(
            input.password,
            input.repeatedPassword,
            resultSelector: dependency.signupService.validateRepeatedPassword)
        
        signupEnabled = Driver.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated
        ){ username, password, repeatedPassword in
            username.isValid && password.isValid && repeatedPassword.isValid
        }.distinctUntilChanged()
        
        signingIn = Driver.just(false)
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            (username: $0, password: $1)
        }
        signupResult = input.loginTaps.withLatestFrom(usernameAndPassword).flatMapLatest({ pari in
            return GitHubNetworkService.signup(pari.username, password: pari.password)
                .asDriver(onErrorJustReturn: false)
        })
    }
}
