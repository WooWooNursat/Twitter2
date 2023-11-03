//
//  File.swift
//  Twitter2
//
//  Created by Nursat Saduakhassov on 03.11.2023.
//

import Foundation
protocol ProfileUpdaterDelegate: AnyObject {
    func didUpdateProfile()
}

final class ProfileUpdater {
    weak var delegate: ProfileUpdaterDelegate?

    static let shared = ProfileUpdater()

    func notify() {
        delegate?.didUpdateProfile()
    }
}
