//
//  ContentView.swift
//  ABCLOGO
//
//  Created by Cedric Bahirwe on 11/25/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    private let strokeColor = Color.red
    private let lineWidth: CGFloat = 25.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var count = 0
    
    @State private var animate = false
    @State private var scale = false
    @State private var remove = false
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Arc(startAngle: .degrees(120), endAngle: .degrees(60), clockwise: true)
                        .stroke(strokeColor, lineWidth: lineWidth)
                        .frame(width: 100, height: 100)
                        
                        //Animate
                        .rotationEffect(.degrees(animate ? 19 : -50))
                        .offset(x: animate ? 0 : -30, y: animate ? 0 : -100)
                        .opacity(animate ? 1 : 0)
                    
                    
                    Arc(startAngle: .degrees(320), endAngle: .degrees(270), clockwise: true)
                        .stroke(strokeColor, lineWidth: lineWidth)
                        .frame(width: 100, height: 100)
                        
                        //Animate
                        
                        .rotationEffect(.degrees(animate ? 0 : -540))
                        .offset(x: animate ? 0 : -30, y: animate ? 0 : 100)
                        .opacity(animate ? 1 : 0)
                        
                        .overlay(
                            
                            ScaledBezier(bezierPath: .abc)
                                .stroke(strokeColor, lineWidth: 35)
                                .transformEffect(CGAffineTransform(a: 0.6, b: 0.4, c: 0, d: 0.35, tx: 0, ty: 0))
                                .frame(width: 200, height: 180)
                                .offset(x: 16, y: -50)
                                //Animate
                                .rotationEffect(.degrees(animate ? 0 : -220))
                                .offset(x: animate ? 0 : 130, y: animate ? 0 : -230)
                                .opacity(animate ? 1 : 0)
                    )
                        .rotationEffect(.degrees(-14), anchor: .center)
                        .offset(x: -9.8, y: -24)
                    
                }
                .rotationEffect(.degrees(13))
                
                ZStack {
                    Arc(startAngle: .degrees(280), endAngle: .degrees(60), clockwise: true)
                        .stroke(strokeColor, lineWidth: lineWidth)
                        .frame(width: 110, height: 100)
                        .rotationEffect(.degrees(-10))
                        .offset(x: -14, y: 0)
                        
                        // Animate
                        .rotationEffect(.degrees(animate ? 0 : -50))
                        .offset(x: animate ? 0 : -30, y: animate ? 0 : -100)
                        .opacity(animate ? 1 : 0)
                    
                    Arc(startAngle: .degrees(130), endAngle: .degrees(240), clockwise: true)
                        .stroke(strokeColor, lineWidth: lineWidth)
                        .frame(width: 100, height: 100)
                        .offset(x: -16, y: 0)
                        .rotationEffect(.degrees(-10))
                        
                        // animate
                        .rotationEffect(.degrees(animate ? 0 : -250))
                        .offset(x: animate ? 0 : -30, y: animate ? 0 : 200)
                        .opacity(animate ? 1 : 0)
                }
                .offset(x: 0, y: -10)
            }.offset(x: remove ? -900 : 0, y: 0)
        }
        .frame(width: UIScreen.main.bounds.size.width-10, height: 500)
        .scaleEffect(scale ? 4 : 1, anchor: .leading)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    withAnimation(Animation.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5).speed(0.4)) {
                        self.animate = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+4.5) {
                    withAnimation(Animation.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.6).speed(0.4)) {
                        self.scale = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+7) {
                    withAnimation(Animation.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5).speed(0.1)) {
                        self.remove = true
                    }
                }
        }
    }
}

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
}

extension UIBezierPath {
    
    static var abc: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.5, y: 0.0))
        path.addLine(to: .init(x: 0.5, y: 01))
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ScaledBezier: Shape {
    let bezierPath: UIBezierPath
    
    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)
        
        // Figure out how much bigger we need to make our path in order for it to fill the available space without clipping.
        let multiplier = min(rect.width, rect.height)
        
        // Create an affine transform that uses the multiplier for both dimensions equally.
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        
        // Apply that scale and send back the result.
        return path.applying(transform)
    }
}
