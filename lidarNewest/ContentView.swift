//
//  ContentView.swift
//  lidarNewest
//
//  Created by Giovanni Zinzi on 11/16/21.
//

import SwiftUI

struct NavigationIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = ARView
   func makeUIViewController(context: Context) -> ARView {
      return ARView()
   }
   func updateUIViewController(_ uiViewController:
   NavigationIndicator.UIViewControllerType, context:
   UIViewControllerRepresentableContext<NavigationIndicator>) { }
}

struct ContentView: View {
   @State var page = "Home"
   
   var body: some View {
      VStack {
         if page == "Home" {
            Button("Switch to ARView") {
               self.page = "ARView"
            }
         } else if page == "ARView" {
            ZStack {
               NavigationIndicator()
               VStack {
                  Spacer()
                  Spacer()
                  Button("Home") {
                     self.page = "Home"
                  }.padding()
                  .background(RoundedRectangle(cornerRadius: 10)
                  .foregroundColor(Color.white).opacity(0.7))
               }
            }
         }
      }
   }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
