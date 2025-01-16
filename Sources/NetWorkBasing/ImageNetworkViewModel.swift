//
// ImageNetworkViewModel.swift
//
//
//  Created by Ali on 15/1/25.
//
import SwiftUI

// MARK: - ImageNetworkVM
@NetworkActor
final class ImageNetworkViewModel: ObservableObject {
    @Published private(set) var image: UIImage? // Imagen protegida por el actor global
    private let interactor: NetworkImageInteractor

    init(interactor: NetworkImageInteractor = ImageNetwork()) {
        self.interactor = interactor
    }

    // Descarga una imagen desde la red o caché
    func getImage(url: URL?, size: CGFloat = 300) async {
        guard let url else { return }

        do {
            let networkImage = try await fetchNetworkImage(url: url, size: size)

            // Cambiado: Actualización de `image` protegida por NetworkActor
            await self.updateImage(networkImage)
        } catch {
            print("Failed to fetch image: \(error)")
        }
    }

    // MARK: - Private Helpers
    private func fetchNetworkImage(url: URL, size: CGFloat) async throws -> UIImage? {
        let fileName = url.lastPathComponent
        let cacheDoc = URL.cachesDirectory.appending(path: fileName)

        if FileManager.default.fileExists(atPath: cacheDoc.path()) {
            do {
                let data = try Data(contentsOf: cacheDoc)
                return UIImage(data: data)
            } catch {
                print("Error retrieving \(fileName) from cache.")
                return nil
            }
        } else {
            do {
                let image = try await interactor.getImage(url: url)
                if let resized = await image.byPreparingThumbnail(ofSize: CGSize(width: size, height: size)) {
                    try saveImageToCache(resized, at: cacheDoc)
                    return resized
                } else {
                    return nil
                }
            } catch {
                throw error
            }
        }
    }

    private func saveImageToCache(_ image: UIImage, at path: URL) throws {
        if let data = image.heicData() {
            try data.write(to: path, options: .atomic)
        }
    }

    // Cambiado: Método para actualizar la imagen protegida por NetworkActor
    private func updateImage(_ newImage: UIImage?) async {
        self.image = newImage // Acceso permitido porque está en NetworkActor
    }
}
