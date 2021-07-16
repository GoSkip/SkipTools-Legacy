//
//  ShopperPaymentView.swift
//  SDKExample
//
//  Created by Micah Wilson on 8/10/20.
//  Copyright © 2020 GoSkip. All rights reserved.
//

import SkipTools
import SwiftUI

struct ShopperPaymentsView: View {
    @ObservedObject var viewModel: LaunchOptionsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.paymentMethods) { payment in
                    PaymentRow(payment: payment)
                }
            }
        }
    }
}

struct PaymentRow: View {
    let payment: SkipSDKPaymentMethod

    var paymentImage: String {
        switch payment.paymentType {
        case .americanexpress:
            return "amexIcon"
        case .discover:
            return "discoverIcon"
        case .mastercard:
            return "mastercardIcon"
        case .visa:
            return "visaIcon"
        default:
            return "blankCard"
        }
    }

    var body: some View {
        HStack {
            Image(paymentImage, bundle: Bundle(identifier: "com.goskip.SkipTools"))
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text(payment.lastFour)
                .foregroundColor(.secondary)
                .padding(.leading)
            Spacer()
            Text(payment.description)
        }
        .padding()
    }
}
