//
//  SettingsViewModelIE.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 24.03.2025.
//


import SwiftUI

class SettingsViewModelSL: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
}
