//
//  ContentView.swift
//  Weather
//
//  Created by ahmet on 11/25/24.
//

import SwiftUI
import Combine


struct DataModel: Codable{
    var isNight: Bool
    var temperature: [String]
    var imageString: [String]
}

struct ContentView: View {
    typealias a = Bool
    @State private var model: DataModel? = nil
    @State private(set) var isNight: a = false
    var body: some View {
        ZStack{
            BackgroundView(isNight: $isNight)
            VStack{
                CityView(text: "Cedar Park, Texas")
                Spacer()
                WeatherView(image: model!.isNight ? "cloud.sun.fill" : "moon.stars.fill", text: model!.temperature[0])
                Spacer()
            }
            Spacer()
            HStack(spacing: 8){
                DayLayout(passedWeekDay: "Tue", passedImageName: (model?.imageString[1])!, temperatureName: (model?.temperature[1])!)
                DayLayout(passedWeekDay: "Wed", passedImageName: model?.imageString[2]!, temperatureName: model?.temperature[2]!)
                DayLayout(passedWeekDay: "Thr", passedImageName: model?.imageString[3]!, temperatureName: model?.temperature[3]!)
                DayLayout(passedWeekDay: "Fri", passedImageName: model?.imageString[4]!, temperatureName: model?.temperature[4]!)
            }
            Spacer()
            Button{
                isNight.toggle()
            } label: {
                WeatherButton(title: "Change Time", textColor: Color.blue, backgroundColor: Color.white)
            }
            Button{
                let url = URL(string: "www.weather.com")
                let task = URLSession.shared.dataTask(with: url ?? <#default value#>) {
                    data, response, error in
                    do{
                        model = try JSONDecoder().decode(DataModel.self, from: data!)
                    }
                    catch {
                        print("Error")
                    }
                }
                task.resume()
                a = model!.isNight
            }label: {
                WeatherButton(title: "Fetch Data", textColor: Color.blue, backgroundColor: Color.white)
            }
            Spacer()
            }
        }
            
        }


#Preview {
    ContentView()
}
struct DayLayout: View{
    var dayOfWeek: String
    var imageName: String
    var temperature: String
    var body: some View {
        VStack(spacing: 4){
            Text(dayOfWeek)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.bottom, 10)
            Text(temperature)
                .font(.system(size: 25, weight: .light))
                .foregroundStyle(.white)
        }
    }
    init(passedWeekDay: String, passedImageName: String, temperatureName: String){
        self.dayOfWeek = passedWeekDay
        self.imageName = passedImageName
        self.temperature = temperatureName
    }
}
struct BackgroundView: View
{
    @Binding var isNight: Bool
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .blue : .black, isNight ? .white : .purple]),startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
    }
}
struct CityView: View
{
    var text: String
    var body: some View
    {
        Text(text)
            .bold()
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
    init(text: String) {
        self.text = text
    }
}
struct WeatherView: View
{
    var image: String
    var text: String
    var body: some View
    {
        VStack(spacing: 2.5){
            Image(systemName: image)
                .renderingMode(.original)
                .resizable()
                .frame(width: 180, height: 180)
            Text(text)
                .font(.system(size: 70, weight: .medium))
                .foregroundStyle(.white)
            Spacer()
        }
    }
}

