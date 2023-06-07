//
//  SettingsView.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 05. 04..
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("runSequentially") private var runSequentially = false
    
    var body: some View {
        Form {
              Toggle("Run tests sequentially", isOn: $runSequentially)
          }
          .padding(20)
          .frame(width: 350, height: 100)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
