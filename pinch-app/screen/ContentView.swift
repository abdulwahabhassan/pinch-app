//
//  ContentView.swift
//  pinch-app
//
//  Created by Hassan Abdulwahab on 12/01/2022.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Property
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero //the size whose width and height are both zero CGSize(width: 0, height: 0)
    @State private var isDrawerOpen: Bool = true
    //MARK: - Function
    
    //function to rest image to its original scale and position
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1 //set image to its original scale
            imageOffset = .zero //return image to its original position
        }
    }
    //MARK: - Content
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                //MARK: - Page Image
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(1), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height) //offset modifier must come first before scale effect modifier
                    .animation(.linear(duration: 1), value: isAnimating) //apply a one-second linear animation when the value of isAnimating changes. Since we are using the value of isAnimating in the opacity modifier, only the opacity will be modified. This will avoid confusing xcode as to which modifiers to animate and which not to. We could otherwise use a specific swiftui built in transition
                    .scaleEffect(imageScale) //scale this image view by the value of imageScale
                //MARK: - Tap Gesture
                    .onTapGesture(count: 2) { //if it is a double tap
                        //if imageScale is 1, scale it by 5 else scale by 1 with a spring animation
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    }
                //MARK: - Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation //this will update the image's position as the drag gesture changes with a linear animation
                                }
                            })
                            .onEnded({ value in
                                if imageScale <= 1 { //if the image is not in zoom mode
                                    resetImageState()
                                }
                            })
                    )
                //MARK: - Magnification
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
                    
            } //zstack ends here
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline) //title appears at the center
            .onAppear {
                isAnimating = true //trigger animation on appearance of this view
            }
            //MARK: - Info Panel
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }
            //MARK: - Controls
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        //scale down
                        Button {
                            //action
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                                
                        } label: {
                           ContolImageView(icon: "minus.magnifyingglass")
                        }

                        //reset
                        Button {
                            //action
                            resetImageState()
                        } label: {
                            ContolImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        //scale up
                        Button {
                            //action
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ContolImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30)
            }
            .overlay(alignment: .topTrailing) {
                HStack(spacing: 12) {
                    //drawer handle
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle() //toggle the drawer state
                            }
                        }
                    
                    Spacer()
                    //thumbnails
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0) //hide or reveal drawer
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12) //dynamic top padding based on the height of the screen
                .offset(x: isDrawerOpen ? 20 : 215) //open or close drawer depending on the value of isDrawerOpen
            }
        } //naivigationView ends here
        .navigationViewStyle(.stack) //this will avoiding using the side bar on ipad devices
    }
}

//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
