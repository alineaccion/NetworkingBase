//
// UnavailableNetwork.swift
//
//
//  Created by Ali on 15/1/25.
//

import SwiftUI

fileprivate struct UnavailableNetwork: ViewModifier {
    let status: NetworkStatus.Status
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    ContentUnavailableView("Network not available",
                                           systemImage: "network.slash",
                                           description: Text("There's no internet connection at this moment. This app needs connection in order to work properly. Come back when you have internet again."))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .opacity(status == .online ? 0.0 : 1.0)
            }
            .animation(.default, value: status)
    }
}

public extension View {
    func unavailableNetwork(status: NetworkStatus.Status) -> some View {
        modifier(UnavailableNetwork(status: status))
    }
}
