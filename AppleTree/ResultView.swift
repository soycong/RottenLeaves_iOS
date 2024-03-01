//
//  ResultView.swift
//  AppleTree
//
//  Created by seohuibaek on 2023/10/27.
//

import SwiftUI

struct ResultView: View {
    @Binding var image: UIImage
    @Binding var resultText: String
    @Binding var partText: String
    @Environment(\.presentationMode) var presentationMode
    
    //@State private var diseaseName: String = ""
    @State private var isDetailViewActive: Bool = false

    
    //let disease: Disease

    var body: some View {
        NavigationStack{
            ZStack {
                Color("ADBDB0").ignoresSafeArea()
                
                VStack (alignment: .leading){
                    if let imageData = image.pngData(), let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 250)
                            .clipped()
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                    }
                    
                    Text(resultText)
                        .font(.custom("SFPro-Bold", size: 30))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 15)
                    
                    Text(partText)
                        .font(.custom("SFPro-Regular", size: 20))
                        .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 15)
                    // 새로운 버튼 추가
                    VStack {
                        if resultText == "각질병, 검은별무늬병(Scab)" {
                            Image("error")
                                .padding(20)
                            
                            NavigationLink(destination: getDetailViewForDisease(name: "각질병, 검은별무늬병(Scab)")) {
                                Text("질병 상세보기")
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding()
                                    .padding(.horizontal, 100)
                                    .background(Color("F16161"))
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                            
                        } else if resultText == "녹병(Rust)" {
                            Image("error")
                                .padding(20)
                            
                            NavigationLink(destination: getDetailViewForDisease(name: "뿌리혹병(Crown gall)")) {
                                Text("질병 상세보기")
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding()
                                    .padding(.horizontal, 100)
                                    .background(Color("F16161"))
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                        }
                        else if resultText == "여러 질병에 걸렸습니다." {
                            Image("error")
                                .padding(20)
                            
                            Button(action: {
                                // healthy 버튼에 대한 액션 처리 코드 추가
                            }) {
                                Text("종합병")
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding()
                                    .padding(.horizontal, 100)
                                    .background(Color("F16161"))
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                            
                        } else if resultText == "정상입니다." {
                            
                            Image("normal")
                                .padding(20)
                            
                            Button(action: {
                                // healthy 버튼에 대한 액션 처리 코드 추가
                            }) {
                                Text("사과나무가 건강해요!")
                                    .font(.custom("SFPro-Bold", size: 18))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .padding(.horizontal, 80)
                                    .background(Color("C6C6C6"))
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                            
                        }
                    }
                     .frame(maxWidth: .infinity, alignment: .center) // VStack에 alignment 적용
                    
                    Spacer()
                }
                .padding()
                
                .onAppear {
                    // 뷰가 나타날 때 실행되는 코드
                    print("Result: \(resultText)")
                }
                .onChange(of: resultText) { newValue in
                    // resultText가 변경될 때마다 실행되는 코드
                    print("Result changed: \(newValue)")
                }
            }
            /*.navigationBarTitle("ResultView", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                // 뒤로 가기 버튼 액션 처리
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(Font.title.weight(.regular))
            }
            )*/
        }
    }
    
    func getDetailViewForDisease(name: String) -> some View {
        // 여기에 각 질병에 대한 DetailView를 반환하는 로직을 추가합니다.
        // 예를 들어, diseasesData에서 해당 이름(name)에 해당하는 질병을 찾아 반환하면 됩니다.
        if let disease = diseasesData.first(where: { $0.name == name }) {
            return AnyView(DetailView(disease: disease))
        } else {
            // 해당하는 질병이 없을 경우, 기본적으로 빈 View를 반환하거나 에러 처리를 할 수 있습니다.
            print("해당 질병을 찾을 수 없습니다.")
            return AnyView(EmptyView())
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(image: .constant(UIImage(named: "example")!), resultText: .constant("질병 이름 예시"), partText: .constant("발병 부위: 예시"))
    }
}
