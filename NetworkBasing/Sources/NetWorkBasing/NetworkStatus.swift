//
// NetworkStatus.swift
//
//
//  Created by Ali on 15/1/25.
//

import SwiftUI
import Network

// TODO: Preprocess the network status inside the NWPathMonitor closure and then assign it to the `status` property on the MainActor.
// This will separate responsibilities, reduce the workload on the MainActor, and improve code clarity.
// MARK: - Global Actor
@globalActor
public actor NetworkActor {
    public static let shared = NetworkActor()
}

// MARK: - NetworkStatus
@NetworkActor
public final class NetworkStatus: ObservableObject {
    public enum Status {
        case offline, online, unknown
    }

    @Published private(set) var status: Status = .unknown // Cambiado: Protección con actor global
    private let monitor = NWPathMonitor()

    init() {
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { [weak self] path in
            // Cambiado: Actualización segura del estado en NetworkActor
            Task { @NetworkActor in
                self?.status = path.status == .unsatisfied ? .offline : .online
            }
        }
    }

    func currentStatus() async -> Status {
        return status // Cambiado: Lectura protegida por NetworkActor
    }
}
