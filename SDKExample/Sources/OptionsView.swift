//
//  OptionsView.swift
//  SDKExample
//
//  Created by Micah Wilson on 8/8/20.
//  Copyright © 2020 GoSkip. All rights reserved.
//

import Combine
import SkipTools
import SwiftUI

struct OptionsView: View {
    enum LaunchType: String, Hashable, CaseIterable, Identifiable {
        case allSkip
        case retailer
        case store

        var id: String {
            return rawValue
        }

        var name: String {
            switch self {
            case .allSkip: return "All Skip Stores"
            case .retailer: return "Retailer Stores"
            case .store: return "Single Store"
            }
        }

        var description: String {
            switch self {
            case .allSkip: return "This option will show a map and list of all stores within a 200 mile radius. List is sorted by closest store."
            case .retailer: return "This option will show the stores for a specific retailer. List is sorted by closest store."
            case .store: return "This option will start a cart in the specified store."
            }
        }
    }
    @ObservedObject var viewModel: LaunchOptionsViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(footer:
                        Text(self.viewModel.launchType.description)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                ) {
                    Picker("Launch Type:", selection: self.$viewModel.launchType) {
                        ForEach(LaunchType.allCases) { type in
                            Text(type.name)
                                .tag(type)
                                .id(type)
                        }
                    }

                    if self.viewModel.launchType == .retailer {
                        HStack {
                            Text("Retailer ID:")
                            Spacer()
                            TextField("35", text: self.$viewModel.retailerID, onCommit:  {
                                print("done")
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            })
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 50)
                        }
                    } else if self.viewModel.launchType == .store {
                        HStack {
                            Text("Store ID:")
                            Spacer()
                            TextField("35", text: self.$viewModel.storeID)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 50)
                        }
                        Picker("Shopping Type:", selection: self.$viewModel.shoppingType) {
                            ForEach(SkipSDKShoppingTripType.allCases) { type in
                                Text(type.description)
                                    .tag(type)
                                    .id(type)
                            }
                        }
                    }
                }

                Section(footer:
                    Text(self.viewModel.walletType.description)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                ) {
                    Picker("Wallet Type:", selection: self.$viewModel.walletType) {
                        ForEach(SkipSDKWalletType.allCases) { type in
                            Text(type.title)
                                .tag(type)
                                .id(type)
                        }
                    }
                }

                Section(footer:
                    Text(self.viewModel.shopperType.description)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                ) {
                    Picker("Shopper Type:", selection: self.$viewModel.shopperType) {
                        ForEach(SkipSDKShopperType.allCases) { type in
                            Text(type.rawValue)
                                .tag(type)
                                .id(type)
                        }
                    }
                }

                Section {
                    Toggle("Show Retailer Logo:", isOn: self.$viewModel.showRetailerLogo)
                }

                Section {
                    Picker("Environment:", selection: self.$viewModel.environment) {
                        ForEach(SkipSDKEnvironment.allCases) { type in
                            Text(type.rawValue)
                                .tag(type)
                                .id(type)
                        }
                    }
                }

                Section(header:
                    Text("Optional Info")
                ) {
                    NavigationLink(destination: ShopperInfoView(viewModel: self.viewModel)) {
                        HStack {
                            Text("Shopper Info")
                            Spacer()
                            Text(self.viewModel.skipSDKUser.firstName + " " + self.viewModel.skipSDKUser.lastName)
                                .foregroundColor(.secondary)
                        }
                    }

                    NavigationLink(destination: ShopperPaymentsView(viewModel: self.viewModel)) {
                        HStack {
                            Text("Payment Methods")
                            Spacer()
                            Text("\(self.viewModel.paymentMethods.count) Linked")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
            .navigationBarTitle(Text("Skip SDK Example"), displayMode: .inline)
        }
    }
}
