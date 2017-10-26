//
//  FeatureManager.swift
//  SlideController
//
//  Created by Vadim Morozov on 10/25/17.
//

protocol Enablable {
    var isEnabled: Bool { get }
}

final class FeatureManager {
    enum Feature {
        case feature(release: Bool, development: Bool)
    }
    
    let viewUnloading: Feature = .feature(release: false, development: true)
}

private typealias EnablableImplementation = FeatureManager.Feature
extension EnablableImplementation: Enablable {
    var isEnabled: Bool {
        switch self {
        case .feature(let release, let development):
            #if DEBUG
                return development
            #else
                return release
            #endif
        }
    }
}
