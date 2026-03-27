//
//  ContentView.swift
//  InstallCertWithCTKS
//
//  Created by victor.maehira on 26/03/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "key")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Agora vai!")
            Button("Instalar certificado") {
                TokenRegistration.registerIfPossible()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
