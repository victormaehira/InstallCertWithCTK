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
            Text("Instalar certificado")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
