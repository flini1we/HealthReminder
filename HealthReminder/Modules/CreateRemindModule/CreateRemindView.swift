import SwiftUI

struct CreateRemindView: View {
    
    @ObservedObject private var expandedStateManager: ExpandedStateManager
    @ObservedObject private var sheetOpenerManager: SheetOpenerManager
    
    @StateObject private var viewModel = CreateRemindViewModel()
    @FocusState private var isFocused: Bool
    
    init(expandedStateManager: ExpandedStateManager, sheetOpenerManager: SheetOpenerManager) {
        self.expandedStateManager = expandedStateManager
        self.sheetOpenerManager = sheetOpenerManager
    }
    
    var body: some View {
        let isExpanded = expandedStateManager.isExpanded
        
        ZStack {
            VStack(spacing: .Padding.normal) {
                ExpandedIndicator(isExpanded: isExpanded)
                
                ZStack {
                    Color.white
                    
                    VStack {
                        ScreenView(isExpanded: isExpanded)
                        
                        Spacer()
                    }
                }
            }
        }
        .onDisappear {
            expandedStateManager.isExpanded = false
            sheetOpenerManager.couldOpen = false
            viewModel.remindTitle = ""
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func ScreenView(isExpanded: Bool) -> some View {
        if isExpanded {
            VStack {
                HStack {
                    Text(viewModel.remindTitle)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    RemindTypeMenu(selectedType: $viewModel.selectedType)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Remind me")
                            .fontWeight(.regular)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        
                        Text(viewModel.intervalText)
                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    Stepper("", value: $viewModel.interval, in: 1...24)
                        .labelsHidden()
                }
                .animation(.spring, value: viewModel.interval)
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    print(1)
                } label: {
                    Text("Create remind")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: .Padding.normal)
                                .fill(.baseBG)
                                .shadow(color: .baseBG, radius: .Padding.small, x: 2, y: 2)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, .Padding.medium)
            }
        } else {
            TextField(
                String.createRemindTextFieldPlaceholder,
                text: $viewModel.remindTitle
            )
            .modifier(remindTitleTextFieldModifier())
            .focused($isFocused)
            .padding()
            .onChange(of: viewModel.isTextFieldEmpty) { _, newValue in
                sheetOpenerManager.couldOpen = !newValue
            }
        }
    }
    
    private struct RemindTypeMenu: View {
        
        @Binding var selectedType: RemindType
        
        var body: some View {
            Menu {
                ForEach(RemindType.allCases) { type in
                    Button {
                        selectedType = type
                    } label: {
                        HStack {
                            Image(systemName: type.systemIcon)
                                .foregroundColor(.accentColor)
                                .frame(width: .Padding.medium, height: .Padding.medium)
                            
                            Text(type.displayName)
                                .foregroundColor(.primary)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "chevron.down.circle.fill")
                        .foregroundStyle(.blue)
                    
                    Text(selectedType.displayName)
                }
            }
        }
    }
    
    private struct ExpandedIndicator: View {
        var isExpanded: Bool
        @State private var isPulsing = false
        
        var body: some View {
            Text(verbatim: .indicator.title(isExpanded).text)
                .foregroundStyle(isExpanded ? .black : .blue)
                .fontWeight(.semibold)
                .padding(.Padding.small)
                .background(
                    Capsule()
                        .fill(isExpanded ? .baseBG : .white)
                        .shadow(
                            color: isExpanded ? .baseBG : .clear,
                            radius: .Padding.small,
                            x: 0,
                            y: 0
                        )
                )
                .padding(.top)
                .scaleEffect(isPulsing ? 1.05 : 1.0)
                .opacity(isPulsing ? 0.8 : 1.0)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: isPulsing
                )
                .onAppear {
                    isPulsing = true
                }
        }
    }
}

private extension String {
    
    static let creteRemindTitle = "Create remind for you"
    static let createRemindTextFieldPlaceholder = "Create yout remind"
    
    enum indicator {
        case title(Bool)
        
        var text: String {
            switch self {
            case .title(let isExpanded):
                return isExpanded ? "Creating your goal" : "Enter title and pull"
            }
        }
    }
}

