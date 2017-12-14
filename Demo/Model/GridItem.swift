//
//  GridItem.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit

@objcMembers final class GridItem: NSObject, Codable {
    private enum CodingKeys: CodingKey {
        case avatar_url
        case login
    }
    dynamic var avatar_url: String?
    dynamic var login: String?

    init(avatar_url: String = "", login: String = "") {

        self.avatar_url = avatar_url
        self.login = login
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avatar_url, forKey: .avatar_url)
        try container.encode(login, forKey: .login)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:CodingKeys.self)
        avatar_url = try container.decode(String.self, forKey: .avatar_url)
        login = try container.decode(String.self, forKey: .login)
    }
}

extension GridItem: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object ? true : self.isEqual(object)
    }
}
