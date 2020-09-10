//
//  String+Additions.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 10.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
