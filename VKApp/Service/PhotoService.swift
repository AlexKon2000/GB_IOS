//
//  PhotoService.swift
//  VKApp
//
//  Created by Alex on 19.04.2022.
//

import UIKit

struct Utils<T> {
    var target: T
}

protocol UtilsAvailable {}

extension UtilsAvailable {
    var ps: Utils<Self> {
        Utils(target: self)
    }
}

extension UIImageView: UtilsAvailable {}

extension Utils where T == UIImageView {
    func photo(byURL: String) {
        DispatchQueue.global().async {
            PhotoService.shared.photo(byUrl: byURL) { image in
                guard let image = image else {
                    return
                }

                DispatchQueue.main.async {
                    target.image = image
                }
            }
        }
    }
}

class PhotoService {
    static var shared = PhotoService()

    private init() {}

    private static let pathName: String = {
        let pathName = "images"

        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return pathName
        }

        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }

        return pathName
    }()

    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    private var images = [String: UIImage]()

    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }

        let hashName = url.split(separator: "/").last ?? "default"

        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }

    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData()
        else {
            return
        }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }

    private func getImageFromCache(url: String) -> UIImage? {
        guard
            let fileName = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else {
            return nil
        }

        let lifeTime = Date().timeIntervalSince(modificationDate)

        guard
            lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName)
        else {
            return nil
        }

        self.images[url] = image

        return image
    }

    private func loadPhoto(byUrl urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }

            self?.images[urlString] = image
            self?.saveImageToCache(url: urlString, image: image)
            completion(image)
        }

        task.resume()
    }

    func photo(byUrl url: String, completion: @escaping (UIImage?) -> Void) {
        var image: UIImage?

        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(byUrl: url, completion: completion)
            return
        }

        completion(image)
    }
}
