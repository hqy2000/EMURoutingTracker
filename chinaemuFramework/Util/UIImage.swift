//
//  UIImage.swift
//  chinaemu
//
//  Created by Qingyang Hu on 12/14/24.
//

import UIKit

extension CIImage {
    func detectQRCode() -> [String] {
        var options: [String: Any]
        let context = CIContext()
        options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        if self.properties.keys.contains((kCGImagePropertyOrientation as String)){
            options = [CIDetectorImageOrientation: self.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        } else {
            options = [CIDetectorImageOrientation: 1]
        }
        let features = qrDetector?.features(in: self, options: options)
        return features?.compactMap { feature in
            (feature as? CIQRCodeFeature)?.messageString
        } ?? []
    }
}
