//
//  ImageDownloader.swift
//  GameApp
//
//  Created by Rizki Siraj on 04/05/24.
//

import UIKit

class ImageDownloader {

  func downloadImage(url: URL) async throws -> UIImage {
    async let imageData: Data = try Data(contentsOf: url)
    return UIImage(data: try await imageData)!
  }
}
