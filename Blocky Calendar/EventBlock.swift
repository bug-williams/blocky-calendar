//
//  TimeBlock.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import SwiftUI

struct EventBlock: View {
    
    let storageManager = StorageManager.shared
    
    var dataHandlerDelegate: DataHanderDelegate
    
    var isEmpty: Bool = false
    var title: String = ""
    var block: Int = 0
    
    let minimumDragOffset: CGFloat = 80
    @State var dragOffset: CGSize = CGSize.zero
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action:{
                    dataHandlerDelegate.deleteEvent(offsets: [dataHandlerDelegate.getEventIndexFromBlock(block: block)])
                }, label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: abs(-(dragOffset.width) - 4), height: 64)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                })
            }
            .opacity((dragOffset != CGSize.zero && isEmpty == false) ? 1 : 0)
            .scaleEffect(
                min(max(-dragOffset.width / minimumDragOffset, 0.5), 1),
                anchor: .trailing
            )
            HStack(spacing: 16) {
                Text(getEventTimeLabel(block: block))
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(width: 52)
                    .padding(.horizontal, -8)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .frame(height: 64)
                        .foregroundColor(isEmpty ? Color(UIColor.secondarySystemBackground) : Color.accentColor)
                    HStack {
                        if isEmpty {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                                Spacer()
                            }
                        } else {
                            Text(title)
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                    }
                    .padding(24)
                }
            }
            .offset(isEmpty ? CGSize.zero : dragOffset)
            .simultaneousGesture(
                DragGesture(minimumDistance: 16, coordinateSpace: .global)
                    .onChanged({ gesture in
                        withAnimation(.interactiveSpring()) {
                            dragOffset.width = gesture.translation.width
                        }
                    })
                    .onEnded({ (offset) in
                        withAnimation(.spring()) {
                            if abs(dragOffset.width) < minimumDragOffset {
                                dragOffset = CGSize.zero
                            } else {
                                dragOffset = CGSize(width: -(minimumDragOffset), height: 0)
                            }
                        }
                    })
            )
        }
    }
    
    // MARK: - Functions
    private func getEventTimeLabel(block: Int) -> String {
        let hour = block / 3
        let minute = 20 * (block % 3)
        
        if minute == 0 { return "\(hour):00" }
        return "\(hour):\(minute)"
    }
    
}