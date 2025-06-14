import SwiftUI

struct CreateRemindView: View {
    
    @ObservedObject private var expandedStateManager: ExpandedStateManager
    @ObservedObject private var sheetOpenerManager: SheetOpenerManager
    
    @StateObject private var viewModel = CreateRemindViewModel()
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    private let remindService: IRemindService
    
    init(expandedStateManager: ExpandedStateManager, sheetOpenerManager: SheetOpenerManager, remindService: IRemindService) {
        self.expandedStateManager = expandedStateManager
        self.sheetOpenerManager = sheetOpenerManager
        self.remindService = remindService
    }
    
    var body: some View {
        let isExpanded = expandedStateManager.isExpanded
        
        ZStack {
            VStack(spacing: .Padding.normal) {
                ExpandedIndicator(isExpanded: isExpanded)
                
                ZStack {
                    Color.white.ignoresSafeArea()
                    
                    ScreenView(isExpanded: isExpanded)
                }
            }
        }
        .onDisappear {
            expandedStateManager.isExpanded = false
            sheetOpenerManager.couldOpen = false
            viewModel.remindTitle = ""
        }
    }
    
    @ViewBuilder
    func ScreenView(isExpanded: Bool) -> some View {
        VStack {
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
                            Text(verbatim: .remindIntervalTitle)
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
                    
                    RemindPrioritySegment(selectedPriority: $viewModel.remindPriority)
                    
                    Spacer()
                    
                    Button {
                        remindService.appendRemind(viewModel.buildRemind())
                        dismiss()
                    } label: {
                        Text("Create \(viewModel.remindPriority.embend) remind")
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
                    .animation(.smooth, value: viewModel.remindPriority)
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
                .onChange(of: isFocused) { _, isEditing in
                    if isEditing {
                        // TODO: Keyboard
                    }
                }
            }
            Spacer()
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
    
    private struct RemindPrioritySegment: View {
        
        @Binding var selectedPriority: RemindsPriority
        @Namespace private var namespace
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(RemindsPriority.allCases, id: \.self) { priority in
                    if priority != .all {
                        ZStack {
                            if selectedPriority == priority {
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .matchedGeometryEffect(id: "selectedTab", in: namespace)
                            }
                            
                            Text(priority.rawValue)
                                .foregroundStyle(selectedPriority == priority ? .black : .gray)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .onTapGesture {
                            selectedPriority = priority
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedPriority)
                    }
                }
            }
            .padding(2.5)
            .background(
                Capsule()
                    .fill(Color(.systemGray6))
            )
            .padding()
        }
    }
}

private extension String {
    
    static let creteRemindTitle = "Create remind for you"
    static let createRemindTextFieldPlaceholder = "Create yout remind"
    static let remindIntervalTitle = "Remind me"
    
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

