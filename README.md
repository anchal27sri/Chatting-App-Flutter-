# Chat App

This is an android application made in flutter. This application can be used for chat between two people. 

## Demo

<p align="center">
  <img width="200" height="350" src="project_images/demo.gif">
</p>

## For users

### Features:
1. Sign-in/Sign-up (Authentication) with email and password.
2. Each user will have a username to be presented to others.
3. The user can change app color theme, username and his email.
4. The user have to add the person he wants to chat to in his friends list and also the person should add him too. 
5. In the chatroom, we can see the time at which the message sent. 

### How to use:
1. Sign in: The first page of the app is the sign-in page. If you have an account in the app, you can directly sign by entering your correct email and password.
2. Sign up: If you don't have an account, you can click on 'Sign up' link on the sing in page. It will take you to the Sign up page. There you can enter your email, password and username and get started with an account.
3. Adding friends: After the first page, the 'Your Friends' list will be empty. To include a friend, click on the button below. It will open a search page. Type your friend's name and click on the '+' button on the right side of his name. The friend will be added to your list.
4. Chatting: In the 'Your Friends' list, click on the 'chat' button corresponding to the friend with whom you want to chat.
5. Settings: Click on the 'settings' button present at the top right corner in the app bar. In the settings page, you can edit your email and username by clicking on the pencil icon. You can also choose your color from there.
6. Logout: The logout button is present at the bottom of the settings page.

## For Developers:

### Technologies used in this preoject: 
1. Platform: Flutter (version 1.17.5)
2. Programming Language: Dart(version 2.8.4)
3. Editor: VS Code 
4. Recorder: Android Emulator
5. Database: Firebase (have to be included as a dependency)

### Widgets used: 
1. Scaffold (to have a general layout of the structure of the app)
2. AppBar (to display options, actions and current page)
4. FloatingActionButton (to add item to a list)
6. ListTile (to represent each item)
8. Text (to display text)
9. Color (to set color of a perticular widget)
11. Dialog (to display pop dialog box)
12. Form (to validate the input in input fields and save them) 
13. FutureBuilder (to handle asynchronosity i.e. to provide a dummy(CircularProgressBar here) when loading)
14. CircularPrgressBar (to show loading)
15. InputTextFormField (to display input fields)
16. StreamBuilder (to show real time friends list and chat screen)
17. Flexible (to use in chat screen to wrap messages by column)
18. Column (for layout)
19. Row (for layout)
20. RaisedButton(sign up, sign in and logout buttons) and IconButton (settings button)

## Flutter Documentation
Follow [this](https://flutter.dev/docs)  link.

## SQLite Documentation
Follow [this](https://www.sqlite.org/docs.html)  link.
