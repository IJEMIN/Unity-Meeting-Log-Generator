//
//  ContentView.swift
//  Unity Meeting Log Generator
//
//  Created by Unity Jemin on 2023/09/18.
//

import SwiftUI

struct ContentView: View {
    @State var textInputs: String = ""
    @State var apiKeyText: String = UserDefaults.standard.string(forKey: "API-KEY") ?? ""
    @State var outputText: String = ""
    
    var body: some View {
        VStack {
            TextField("API Key", text: $apiKeyText)
                .onChange(of: apiKeyText, perform: { value in
                    UserDefaults.standard.set(apiKeyText, forKey: "API-KEY")
            })
            TextField("전체 회의 로그", text: $textInputs, axis: .vertical).lineLimit(5...)
            Button(action: onClickSendButton){
                Text("회의 노트 생성하기")
            }
            TextField("생성된 노트", text: $outputText, axis: .vertical).lineLimit(5...)
        }
        .padding()
        
    }
    
    func onClickSendButton() {
        print("Send")
        let request = Request(model: "gpt-4", messages: [
            RequestMessage(role:"system", content: PromptConstants.SetupContext),
            RequestMessage(role:"user", content: textInputs)
        ])
        let jsonEnconder = JSONEncoder()
        
        guard let url = URL(string: OpenApi.Url) else { fatalError("Missing URL") }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? jsonEnconder.encode(request)
        
        urlRequest.setValue(String(format : "Bearer %@", apiKeyText), forHTTPHeaderField: "Authorization")
        
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data,response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard let data = data else {
                return
            }
            
            guard let output = try? JSONDecoder().decode(OpenResponse.self, from: data) else {
                       print("Error: JSON Data Parsing failed")
                       return
                   }
            
            print(output.choices[0].message.content)
            print(response.statusCode)
            print(response)
            outputText = output.choices[0].message.content
        }

        dataTask.resume()
    }
    
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
