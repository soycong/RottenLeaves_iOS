//
//  DetailView.swift
//  AppleTree
//
//  Created by 김유빈 on 2023/10/11.
//

import SwiftUI

struct DetailView: View {
    let disease: Disease  // 선택한 질병 정보를 저장하기 위한 속성
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("예시 질병 사진")
                    .font(.custom("SFPro-Semibold", size: 17))
                    .padding(.leading, 20)
                
                Image(disease.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                
                Text(disease.name)
                    .font(.custom("SFPro-Bold", size: 30))
                    .padding(.leading, 20)
                
                Text("발병 부위: \(disease.part)")
                    .font(.custom("SFPro-Regular", size: 20))
                    .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                    .padding(.leading, 20)
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    ExpandableTextView("발생환경:\n\(disease.environment)", lineLimit: 5)
                        .font(.custom("SFPro-Semibold", size: 17))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .background(.white.opacity(0.2))
                        .cornerRadius(5)
                        .frame(maxWidth: .infinity)
                    
                    ExpandableTextView("증상설명:\n\(disease.symptoms)", lineLimit: 5)
                        .font(.custom("SFPro-Semibold", size: 17))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .background(.white.opacity(0.2))
                        .cornerRadius(5)
                        .frame(maxWidth: .infinity)
                    
                    ExpandableTextView("방제방법:\n\(disease.controlMethod)", lineLimit: 5)
                        .font(.custom("SFPro-Semibold", size: 17))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .background(.white.opacity(0.2))
                        .cornerRadius(5)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 15)
            }
        }
        .background(Color("ADBDB0"))
        .navigationBarTitle("", displayMode: .inline)
    }
    
    init(disease: Disease) {
        self.disease = disease  // 선택한 질병 정보를 초기화
    }
}

struct ExpandableTextView: View {
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var shrinkText: String
    
    @State private var isRendered: Bool = false
    
    private var text: String
    let lineLimit: Int
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? "" : "더보기"
        }
    }
    
    let font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    
    init(_ text: String, lineLimit: Int) {
        self.text = text
        self.lineLimit = lineLimit
        _shrinkText = State(wrappedValue: text)
    }
    
    var body: some View {
        Group {
            if !truncated {
                Text(text)
            } else {
                Text(self.expanded ? text : (shrinkText + "... "))
                + Text(moreLessText)
                    .underline()
            }
        }
        .font(Font(font))
        .multilineTextAlignment(.leading)
        .lineSpacing(4)
        .lineLimit(expanded ? nil : lineLimit)
        .onTapGesture {
            if truncated {
                expanded.toggle()
            }
        }
        .background(
            Text(text)
                .lineSpacing(4)
                .lineLimit(lineLimit)
                .background(GeometryReader { visibleTextGeometry in
                    Color.clear
                        .onChange(of: isRendered) { _ in
                            guard isRendered else {
                                return
                            }
                            let size = CGSize(width: visibleTextGeometry.size.width, height: .greatestFiniteMagnitude)
                            let style = NSMutableParagraphStyle()
                            style.lineSpacing = 4
                            style.lineBreakStrategy = .hangulWordPriority
                            let attributes: [NSAttributedString.Key: Any] = [
                                NSAttributedString.Key.font: font,
                                NSAttributedString.Key.paragraphStyle: style
                            ]
                            
                            let pureAttributedText = NSAttributedString(string: shrinkText, attributes: attributes)
                            let pureBoundingRect = pureAttributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                            
                            if abs(pureBoundingRect.size.height - visibleTextGeometry.size.height) < 1 {
                                return
                            }
                            
                            var low = 0
                            var height = shrinkText.count
                            var mid = height
                            while ((height - low) > 1) {
                                let attributedText = NSAttributedString(string: shrinkText + "... " + moreLessText, attributes: attributes)
                                let boundingRect = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                                
                                if boundingRect.size.height > visibleTextGeometry.size.height {
                                    truncated = true
                                    height = mid
                                    mid = (height + low) / 2
                                } else {
                                    if mid == text.count {
                                        break
                                    } else {
                                        low = mid
                                        mid = (low + height) / 2
                                    }
                                }
                                shrinkText = String(text.prefix(mid))
                            }
                        }
                        .onAppear {
                            isRendered = true
                        }
                })
                .hidden()
        )
    }
}

/*
 struct DetailView_Previews: PreviewProvider {
 static var previews: some View {
 DetailView()
 }
 }
 */
