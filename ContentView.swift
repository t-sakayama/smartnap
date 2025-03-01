import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AlarmViewModel()
    @State private var showingAddAlarm = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                List {
                    ForEach(viewModel.alarms) { alarm in
                        AlarmRow(alarm: alarm, viewModel: viewModel)
                            .listRowBackground(Color.black)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            viewModel.deleteAlarm(viewModel.alarms[index])
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("アラーム")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddAlarm = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                AlarmEditView(viewModel: viewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct AlarmRow: View {
    let alarm: Alarm
    @ObservedObject var viewModel: AlarmViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(timeString(from: alarm.time))
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.white)
                if !alarm.label.isEmpty {
                    Text(alarm.label)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in viewModel.toggleAlarm(alarm) }
            ))
            .toggleStyle(SwitchToggleStyle(tint: .green))
        }
        .padding(.vertical, 8)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 