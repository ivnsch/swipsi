//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct LegalView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(
                     """
Terms and Conditions
                     
Last Updated: 15.02.2025

Welcome to swapsi (the "App"). By using this App, you agree to the following terms and conditions. If you do not agree, please do not use the App.

1. Affiliate Disclosure

This App contains links to third-party e-commerce platforms, including Amazon, where you can purchase products. These links include an affiliate ID, meaning we may earn a commission on purchases made through them at no additional cost to you.

2. Third-Party Links

The App provides links to external websites (e.g., Amazon). We do not own, operate, or control these third-party platforms and are not responsible for their content, policies, or practices. Your interactions with these third parties are governed by their respective terms and conditions.

3. No Guarantee of Availability

Product listings, prices, and availability may change without notice. Prices displayed in the App are updated daily on a best effort basis but may not always reflect the latest pricing on third-party platforms. We do not guarantee that any listed product will be available for purchase or that prices displayed in the App are current.

4. Limitation of Liability

We provide this App "as is" without warranties of any kind. We are not responsible for any issues, including but not limited to, inaccurate product information, transaction failures, or any damages resulting from using the App or third-party links.

5. User Responsibility

By using the App, you agree to review all product details, terms, and conditions on the third-party platform before making a purchase. We are not responsible for disputes between you and any external seller.

6. Changes to These Terms

We reserve the right to update these terms at any time. Continued use of the App after modifications constitutes your acceptance of the revised terms.

7. Contact Information

If you have any questions, you can contact us at https://discord.gg/Pwx7Sh8Suf.

By using this App, you acknowledge that you have read and agreed to these Terms and Conditions.

""")
                    .padding(20)
                    .foregroundColor(Color.black)

            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("Legal")
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("About")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
}
