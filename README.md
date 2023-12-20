# AssignmentOne

This project is made to add you daily TODO task and see the hourly temprature based on your location. This app also contain user authentication.

## Features

- Each user has seperate todolist.
- Analyze 24 hour weather with time
- Add your TODO task with title, description and time
- Update your todo task
- delete your todo task
- Add multiple todo task associated with each user

## Getting Started

### Description about project files and structure
- Used MVVM with Rxswift
- Using Coredata with two entities(User and TodoList)
- Followed Repository pattern for contact between viewmodel and coredata
- Followed Singloten pattern for Helper classes

### Prerequisites

- Used RXswift, Firebase, RxCocoa
- You can login using Admin and GaganOne as a username(By default user)

### Installation

Download the code and run in xcode

## Usage

- Login using Admin or GaganOne else give you lagin failed alert
- Observe hourly temprature with time
- From the top right click on that button to add todo
- click on todo to update the details
- swipe to delete todo
