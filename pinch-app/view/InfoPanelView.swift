//
//  InfoPanelView.swift
//  pinch-app
//
//  Created by Hassan Abdulwahab on 12/01/2022.
//

import SwiftUI

struct InfoPanelView: View {
    
    //properties that will be used to give information about the scale and offset values of the image
    var scale: CGFloat
    var offset: CGSize
    
    @State var isInfoPanelVisible: Bool = false
    
    var body: some View {
        HStack {
            //MARK: - Hot Spot
            Image(systemName: "circle.circle") //you must specify the system name for SF symbols. SF Symbols adapts their appearance seamlessly in both dark and light mode
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture(minimumDuration: 1) { //change the visibility of the info panel on long press over 1 sec
                    withAnimation(.easeOut) {
                        isInfoPanelVisible.toggle()
                    }
                }
            
            Spacer()
            
            //MARK: - Info Panel
            HStack(spacing: 2) {
                
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                
                Spacer()
                
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                
                Spacer()
                
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                
            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial) //background material, allows to apply a blur effect on a view which sits on top another view such that the view underneath is visble but blurred (actually gives the appearance of a heavily frosted glass). it adapts to light and dark mode
            .cornerRadius(8)
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisible ? 1 : 0) //sets the visibility of the info panel depending on the isInfoPanelVisible property which is toggled on long press of the hotspot circular image
            
            
        }
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits) //display the view without the device
            .padding()
    }
}
