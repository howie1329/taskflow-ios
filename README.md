# TaskFlow iOS

A comprehensive task management iOS app built with SwiftUI that helps users organize, track, and manage their tasks efficiently.

## Features

### 📊 Dashboard

- **Task Statistics**: View total, completed, in-progress, and overdue tasks
- **Time Filtering**: Filter tasks by Today, This Week, or This Month
- **Quick Actions**: Easy access to AI assistant, events, task creation, and analytics
- **Priority Breakdown**: Visual representation of task priorities with progress bars
- **Recent Tasks**: Quick overview of your latest tasks
- **Upcoming Deadlines**: Track tasks due within the next 7 days

### 📝 Task Management

- **Task List**: View all tasks with detailed information
- **Task Details**: Comprehensive task information with priority levels
- **Priority Levels**: High, Medium, and Low priority categorization
- **Completion Tracking**: Mark tasks as completed with visual indicators
- **Due Date Management**: Track task deadlines with color-coded urgency

### 🤖 AI Assistant

- **Smart Task Help**: Get AI-powered assistance with task management
- **Context-Aware Responses**: AI understands your current tasks and provides relevant advice
- **Natural Language Interface**: Ask questions in plain English

### 📅 Events

- **Event Management**: Schedule and manage events
- **Calendar Integration**: View events in a calendar format

## Architecture

### Models

- `TaskEvent`: Core task data model with properties for title, description, due date, priority, and completion status
- `Tasks`: Extended task model with additional properties like categories and status

### View Models

- `TaskViewModel`: Manages task data, network operations, and AI interactions
- Observable pattern for real-time UI updates

### Views

- `DashboardView`: Main dashboard with statistics and quick actions
- `TaskListView`: Comprehensive task list with filtering and sorting
- `TaskDetailSheetView`: Detailed task information modal
- `AiAnswerSheet`: AI assistant interface
- `EventView`: Event management interface

### Services

- `NetworkService`: Handles API communication with the backend
- `AINetworkService`: Manages AI-related API calls

## Getting Started

1. Clone the repository
2. Open `taskflow-ios.xcodeproj` in Xcode
3. Build and run the project on your iOS device or simulator

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Backend Integration

The app connects to a backend service at `https://taskflow-backend-production-8812.up.railway.app` for:

- Task data synchronization
- AI assistant functionality
- User data management

## UI/UX Features

- **Modern Design**: Clean, intuitive interface following iOS design guidelines
- **Dark Mode Support**: Automatic adaptation to system appearance settings
- **Responsive Layout**: Optimized for different screen sizes
- **Smooth Animations**: Fluid transitions and interactions
- **Accessibility**: VoiceOver support and accessibility labels

## Dashboard Components

### Statistics Cards

- Total Tasks: Shows the count of all tasks in the selected time period
- Completed: Number of completed tasks
- In Progress: Number of active tasks
- Overdue: Number of tasks past their due date

### Quick Actions

- **Ask AI**: Launch the AI assistant for task-related help
- **Events**: Access the event management interface
- **Add Task**: Quickly create a new task
- **Analytics**: View detailed task analytics (coming soon)

### Priority Breakdown

Visual progress bars showing the distribution of tasks by priority level:

- High Priority (Red)
- Medium Priority (Orange)
- Low Priority (Green)

### Recent Tasks

Shows the 3 most recent tasks with:

- Task title and description
- Priority indicator
- Completion status
- Quick access to task details

### Upcoming Deadlines

Displays tasks due within the next 7 days with:

- Days until deadline
- Color-coded urgency (Red: ≤1 day, Orange: ≤3 days, Green: >3 days)
- Task information

## Future Enhancements

- [ ] Task categories and tags
- [ ] Advanced filtering and search
- [ ] Task templates
- [ ] Team collaboration features
- [ ] Push notifications for deadlines
- [ ] Data export functionality
- [ ] Offline mode support
- [ ] Widget support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
