//
//  CameraView.swift
//  AppleTree
//
//  Created by 김유빈 on 2023/10/09.
//

import SwiftUI
import UIKit
import CoreML
import Vision

struct CameraView: View {
    @State private var openCamera = false
    @State private var openAlbum = false
    @State private var image = UIImage()
    
    @State private var resultText: String = "" // AI 모델의 결과를 저장하는 변수
    @State private var partText: String = ""
    
    @State private var isShowingResultView = false // ResultView를 표시할 상태
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("logo")
                        .padding(.top, 20)
                        .padding(.leading, 10)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                VStack {
                    Spacer().frame(height: 50)
                    
                    Button(action: {
                        self.openCamera = true
                    }) {
                        VStack {
                            Image("camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            Text("카메라로 촬영")
                                .foregroundColor(.black)
                                .font(.custom("SFPro-Semibold", size: 20))
                        }
                    }
                    .fullScreenCover(isPresented: $openCamera) {
                        CameraImagePicker(sourceType: .camera, selectedImage: self.$image).onDisappear {
                            self.isShowingResultView = true // 앨범에서 이미지 선택 시 ResultView 표시
                        }
                    }
                    .padding(20)
                    .padding(.horizontal, 80)
                    .background(Color("C3DCC2"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    
                    Spacer().frame(height: 30)
                    
                    Button(action: {
                        self.openAlbum = true
                        //self.isShowingResultView = true // 앨범에서 이미지 선택 시 ResultView 표시
                    }) {
                        VStack {
                            Image("photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            Text("앨범에서 선택")
                                .foregroundColor(.black)
                                .font(.custom("SFPro-Semibold", size: 20))
                        }
                    }
                    .padding(20)
                    .padding(.horizontal, 80)
                    .background(Color("FFBABA"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        
        .fullScreenCover(isPresented: $openAlbum) {
            AlbumImagePicker(sourceType: .photoLibrary, selectedImage: self.$image).onDisappear {
                //self.isShowingResultView = true // 앨범에서 이미지 선택 시 ResultView 표시
                
                if !image.isEqual(UIImage()) { // 이미지가 선택된 경우에만 ResultView 표시
                    self.isShowingResultView = true
                }
            }
        }
        
        .sheet(
            isPresented: self.$isShowingResultView,
            onDismiss: {
                // Code to execute when the sheet is dismissed
                self.isShowingResultView = false
            }
        ) {
            //ResultView(image: $image)
            ResultView(image: $image, resultText: $resultText, partText: $partText)
                .onAppear {
                    // 이미지가 선택되면 AI 모델을 사용하여 처리하고 결과를 resultText에 설정
                    processImageWithMLModel()
                }
        }
    }
    // AI 모델을 사용하여 이미지 처리하는 함수
    func processImageWithMLModel() {
        guard let model = try? _25EFR_74().model else {
            fatalError("AI 모델을 불러오는 데 실패했습니다.")
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            fatalError("이미지를 데이터로 변환하는 데 실패했습니다.")
        }
        
        var handler: VNImageRequestHandler? // handler 변수를 여기에 정의합니다
        
        do {
            let visionModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                guard let results = request.results as? [VNClassificationObservation],
                      let firstResult = results.first else {
                    self.resultText = "이미지를 분류할 수 없습니다."
                    return
                }
                
                if firstResult.identifier == "scab" {
                    // 여기에서 결과를 처리하거나 저장합니다.
                    self.resultText = "각질병, 검은별무늬병(Scab)"
                    self.partText = "발병 부위: 잎, 가지, 과실"
                    
                } else if firstResult.identifier == "rust" {
                    // 여기에서 결과를 처리하거나 저장합니다.
                    self.resultText = "녹병(Rust)"
                    self.partText = "발병 부위: 잎"
                    
                } else if firstResult.identifier == "mutiplediseases" {
                    // 여기에서 결과를 처리하거나 저장합니다.
                    self.resultText = "여러 질병에 걸렸습니다."
                    self.partText = "발병 부위: 잎, 가지, 과실"
                } else {
                    // 여기에서 결과를 처리하거나 저장합니다.
                    self.resultText = "정상입니다."
                    self.partText = ""
                }
                // 여기에서 결과를 처리하거나 저장합니다.
                //self.resultText = firstResult.identifier
                
                print("ml 결과 \(resultText)")
            }
            
            // Core ML 모델에 사용할 이미지를 준비합니다.
            if let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) {
                handler = VNImageRequestHandler(
                    cgImage: image.cgImage!,
                    orientation: orientation
                )
            } else {
                // 처리할 수 없는 경우에 대한 처리
            }
            
            try handler?.perform([request]) // handler를 옵셔널로 선언했기 때문에 여기서 옵셔널 체이닝을 사용합니다
        } catch {
            self.resultText = error.localizedDescription
            print("이미지 처리 중 오류 발생: \(error.localizedDescription)")
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
