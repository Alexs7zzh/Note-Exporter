//
//  View+Extension.swift
//  Note Exporter
//
//  Created by Alex on 2020/10/02.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
