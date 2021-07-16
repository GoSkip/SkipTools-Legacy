//
//  ShopperInfoView.swift
//  SDKExample
//
//  Created by Micah Wilson on 8/10/20.
//  Copyright © 2020 GoSkip. All rights reserved.
//

import SwiftUI

struct ShopperInfoView: View {
    @ObservedObject var viewModel: LaunchOptionsViewModel

    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("First Name", text: self.$viewModel.skipSDKUser.firstName)
                        .textContentType(.givenName)
                        .multilineTextAlignment(.leading)
                    TextField("Last Name", text: self.$viewModel.skipSDKUser.lastName)
                        .textContentType(.familyName)
                        .multilineTextAlignment(.leading)
                }
                TextField("Email", text: self.$viewModel.skipSDKUser.email)
                    .textContentType(.emailAddress)
                    .multilineTextAlignment(.leading)
                    .autocapitalization(.none)
                TextField("Phone Number", text: self.$viewModel.skipSDKUser.phoneNumber)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                TextField("Loyalty Number", text: self.$viewModel.skipSDKUser.loyaltyNumber)
                    .textContentType(.telephoneNumber)
                    .multilineTextAlignment(.leading)
                    .autocapitalization(.none)
            }
        }
    }
}
