//
//  ViewController.swift
//  SDKExample
//
//  Created by Micah Wilson on 8/6/20.
//  Copyright © 2020 GoSkip. All rights reserved.
//

import SkipTools
import SwiftUI
import UIKit

extension SkipSDKShopperType: Identifiable {
    public var id: String {
        rawValue
    }

    public var description: String {
        switch self {
        case .anonymous:
            return "With this option no user object is created for the shopper. Simulates a \"Guest\" checkout experience. You will be in responsible of ensuring valid authentication for the user."
        case .pending:
            return "Skip handles the creating a storing of a user object, but you can pass in data to streamline the onboarding process. Use the SkipSDKUser object to pass this data."
        case .skipShopper:
            return "When launching the SDK with this option Skip will handle the creation and storing of a user object."
        @unknown default:
            fatalError()
        }
    }
}

extension SkipSDKShoppingTripType: Identifiable {
    public var id: String {
        rawValue
    }

    var description: String {
        switch self {
        case .scanAndGo:
            return "Scan and Go"
        case .orderAhead:
            return "Order Ahead"
        default:
            fatalError()
        }
    }
}

extension SkipSDKWalletType: Identifiable {
    public var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .providedWallet:
            return "Provided Wallet"
        case .skipWallet:
            return "Skip Wallet"
        default:
            fatalError()
        }
    }

    var description: String {
        switch self {
        case .providedWallet:
            return "You will handle the storage and processing of payments."
        case .skipWallet:
            return "Skip will handle the storage and processing of payments."
        default:
            fatalError()
        }
    }
}

extension SkipSDKEnvironment: Identifiable {
    public var id: String {
        rawValue
    }
}

extension SkipSDKPaymentMethod: Identifiable {}

class LaunchOptionsViewModel: ObservableObject {
    @Published var launchType = OptionsView.LaunchType.allSkip
    @Published var retailerID = "14"
    @Published var storeID = "35"
    @Published var shopperType = SkipSDKShopperType.skipShopper
    @Published var shoppingType = SkipSDKShoppingTripType.scanAndGo
    @Published var walletType = SkipSDKWalletType.skipWallet
    @Published var environment = SkipSDKEnvironment.sandbox
    @Published var showRetailerLogo = true
    @Published var skipSDKUser = SkipSDKUser()
    @Published var paymentMethods = [
        SkipSDKPaymentMethod(id: 0, preferred: false, paymentType: .visa, lastFour: "0000", description: "Sample Visa"),
        SkipSDKPaymentMethod(id: 1, preferred: false, paymentType: .americanexpress, lastFour: "0001", description: "Sample Amex"),
        SkipSDKPaymentMethod(id: 2, preferred: false, paymentType: .mastercard, lastFour: "0002", description: "Sample Mastercard"),
        SkipSDKPaymentMethod(id: 3, preferred: false, paymentType: .discover, lastFour: "0003", description: "Sample Discover"),
        SkipSDKPaymentMethod(id: 4, preferred: false, paymentType: .other, lastFour: "0004", description: "Sample Other", cardURL: "https://images-na.ssl-images-amazon.com/images/I/41CEAeArsKL.jpg")
    ]

    var sdkLaunchType: SkipSDKLaunchType {
        switch launchType {
        case .allSkip:
            return .allSkip
        case .retailer:
            return .retailer(ids: [retailerID.intValue])
        case .store:
            return .store(id: storeID.intValue, retailerID: retailerID.intValue, shoppingTripType: shoppingType)
        }
    }
}

class ViewController: UIViewController, SkipCallBacks {
    let launchOptionsViewModel = LaunchOptionsViewModel()
    let threePadApi = ThreepadAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let optionsVC = UIHostingController(rootView: OptionsView(viewModel: self.launchOptionsViewModel))

        view.addSubview(optionsVC.view)

        optionsVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionsVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionsVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            optionsVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            optionsVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70)
        ])
    }

    @IBAction
    func launchSDKPressed() {
        let programName = launchOptionsViewModel.shoppingType == .scanAndGo ? "Scan & Pay" : "Order Ahead"
        let config = SkipSDK.Config(launchType: launchOptionsViewModel.sdkLaunchType,
                                    introType: .custom(programName: programName, features: [.init(title: "Test Feature", description: "Test description")], explainerString: nil),
                                    walletType: launchOptionsViewModel.walletType,
                                    paymentMethods: launchOptionsViewModel.paymentMethods,
                                    shopperType: launchOptionsViewModel.shopperType,
                                    skipSDKUser: launchOptionsViewModel.skipSDKUser,
                                    environment: launchOptionsViewModel.environment)
        SkipSDK.launchSkip(from: self, withConfig: config)
    }
}

extension ViewController {
    func startSkipCart(storeID: Int, completionHandler: @escaping SkipSDKCartHandler) {
        SkipLoader.showLoader()
        threePadApi.requestData(for: .startCart(storeId: storeID)) { (response: SDKStartCartResponse?, _, _) in
            SkipLoader.dismissLoader()
            if let response = response {
                let defaultConfetti = SkipSDKConfetti(colors: ["#F26645", "#FFC75C", "#7AC7A3", "#4DC2D9", "#94638C"], darkTheme: false, name: "Default", url: "https://storage.googleapis.com/skip-prod-frontend-docs/confetti_skip.png", backgroundColor: "#FFFFFF", backgroundImageUrl: nil)
                let startCartResponse = SkipSDKStartCartResponse(token: response.token, cartID: response.cartId, confetti: defaultConfetti)
                completionHandler(startCartResponse)
            } else {
                CoverAlertViewController().addTitle(LocalizedString("Uh Oh")).addMessage(LocalizedString("An error occured starting the cart")).addButton(LocalizedString("Okay"), target: nil, selector: nil).show()
                SkipSDK.inputCancelledForPaymentMethod()
            }
        }
    }

    func tenderSkipCart(cartID: Int, paymentMethod: SkipSDKPaymentMethod?, total: String) {
        SkipLoader.showLoader()
        threePadApi.requestData(for: .tenderCart(cartId: cartID), response: { (response: SDKTenderCartResponse?, _, _) in
            SkipLoader.dismissLoader()
            if response == nil {
                CoverAlertViewController().addTitle(LocalizedString("Uh Oh")).addMessage(LocalizedString("An error occured tendering the cart")).addButton(LocalizedString("Okay"), target: nil, selector: nil).show()
                SkipSDK.inputCancelledForPaymentMethod()
            }
        })
    }

    struct SDKTenderCartResponse: Codable {}

    struct SDKStartCartResponse: Codable {
        var cartId: Int
        var token: String
    }
}
