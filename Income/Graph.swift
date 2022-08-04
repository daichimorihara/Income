//
//  Graph.swift
//  Income
//
//  Created by Daichi Morihara on 2022/08/04.
//

import SwiftUI

struct Graph: View {
    @State private var showPlot = false
    @State private var currentPlot = ""
    @State private var offset: CGSize = .zero
    @State private var offsetX: CGFloat = 0
    
    
    var data: [CGFloat]
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = proxy.size.width / CGFloat(data.count - 1)
            let maxPoint = data.max() ?? 0
            let points = data.enumerated().compactMap { item -> CGPoint in
                let x = width * CGFloat(item.offset)
                let y = (1 - (item.element / maxPoint)) * height
                return CGPoint(x: x, y: y)
            }
            ZStack {
                Path { path in
                    path.move(to: points.first!)
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                
                Color.blue.opacity(0.1)
                    .clipShape(
                        Path{path in
                            // drawing the points..
                            path.move(to: points.first!)
                            path.addLines(points)

                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))

                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    )
            }
            .overlay(content: {
                ZStack {
                    Text(currentPlot)
                        .padding(3)
                        .background(.yellow)
                        .clipShape(Capsule())
                        .offset(x: offsetX, y: -70)
                        
                    poin
                    line
                }
                .offset(offset)
                .opacity(showPlot ? 1 : 0)
                

         
            })
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        withAnimation{ showPlot = true }
                        
                        let x = value.location.x
                        let index = max(min(Int((x / width).rounded()), data.count - 1), 0)
                        currentPlot = "$ \(data[index])"
                        
                        offset = CGSize(width: points[index].x - (proxy.size.width / 2) , height: points[index].y - (height / 2))
                        
                        
                        
                        offsetX = x < 20 ? 20 : x > (proxy.size.width - 20) ? -20 : 0
                    })
                    .onEnded({ value in
                        withAnimation { showPlot = false }
                        
                    })
                    
            
            )
            .background(
                ZStack(alignment: .leading) {
                    VStack {
                        Divider()
                        Spacer()
                        Divider()
                    }
                    
                    HStack {
                        Divider()
                        Spacer()
                        Divider()
                    }
        
                    VStack(spacing: 0) {
                        Text("$ 299")
                        Spacer()
                        Text("$ 0")
                    }
                }
                ,alignment: .leading
            )
            
            
            
        }
        .frame(height: 200)
        .padding()
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph(data: samplePlot)
    }
}




let samplePlot: [CGFloat] = [

    989,1200,750,790,650,950,1200,600,500,600,890,1203,1400,900,1250,
1600,1200
]


extension Graph {
    private var line: some View {
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 2, height: 100)
            
    }
    
    private var poin: some View {
        Circle()
            .fill(Color.yellow)
            .frame(width: 20, height: 20)
      
    }
}
