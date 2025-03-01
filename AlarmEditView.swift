import SwiftUI

struct AlarmEditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AlarmViewModel
    
    @State private var time = Date()
    @State private var label = ""
    @State private var isEnabled = true
    @State private var selectedDays: Set<Int> = []
    @State private var soundName = "default"
    @State private var snoozeEnabled = true
    @State private var snoozeInterval = 9
    
    let weekDays = ["日", "月", "火", "水", "木", "金", "土"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section {
                        DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                    }
                    .listRowBackground(Color.black.opacity(0.6))
                    
                    Section {
                        TextField("ラベル", text: $label)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.black.opacity(0.6))
                    
                    Section(header: Text("繰り返し").foregroundColor(.green)) {
                        ForEach(0..<7) { index in
                            Toggle(weekDays[index], isOn: Binding(
                                get: { selectedDays.contains(index + 1) },
                                set: { isOn in
                                    if isOn {
                                        selectedDays.insert(index + 1)
                                    } else {
                                        selectedDays.remove(index + 1)
                                    }
                                }
                            ))
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                        }
                    }
                    .listRowBackground(Color.black.opacity(0.6))
                    
                    Section {
                        Toggle("スヌーズ", isOn: $snoozeEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                        
                        if snoozeEnabled {
                            HStack {
                                Text("スヌーズ間隔")
                                Spacer()
                                Text("\(snoozeInterval)分")
                                    .foregroundColor(.green)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                // スヌーズ間隔の選択UIを表示
                            }
                        }
                    }
                    .listRowBackground(Color.black.opacity(0.6))
                }
            }
            .navigationTitle("新規アラーム")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("キャンセル") { 
                    dismiss()
                }
                .foregroundColor(.green),
                trailing: Button("保存") {
                    let alarm = Alarm(
                        time: time,
                        isEnabled: isEnabled,
                        label: label,
                        daysOfWeek: selectedDays,
                        soundName: soundName,
                        snoozeEnabled: snoozeEnabled,
                        snoozeInterval: snoozeInterval
                    )
                    viewModel.addAlarm(alarm)
                    dismiss()
                }
                .foregroundColor(.green)
            )
        }
        .preferredColorScheme(.dark)
    }
} 