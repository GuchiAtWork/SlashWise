<h1 align="center" style=font-size:50px>
SlashWise
</h1>

# About our Project
Welcome to SlashWise! SlashWise is a cloud-based Android app that makes your life easier by keeping track of expenses between you and a particular group you're part of. Our app allows you settle debts that you owe either through cash (that is by directly handing cash to your groupmate) or via PayPal (granted if the other person you owe debt to has a PayPal account). In addition, all expenses on our app can be accompanied by an image that serves as evidence that the expense recorded is legitmate. Please have a look at our app!

## Built With
Our project was built using the following technologies:
* Dart
* Flutter
* Firebase
* Node.js (on a separate repository) 
* Express (on a separate repository)
* Heroku (Express back end operated on Heroku server)
* PayPal

# Building this Project Locally

## Prerequisites
In order to run this app locally, you will need the following technologies:
* Android Studio (and the emulators that come with it)
* VSCode (if you want to, Android Studio will suffice)
* Dart programming language
* Flutter framework

If you don't have any of these following technologies already set up, please take a look at this [guide](https://flutter.dev/docs/get-started/install). It does a great job explaining how to set Flutter up, along with the other technologies above.

## Installation
1. Clone the repository
2. Open a terminal in the SlashWise folder (the repository folder)
3. Open an Android emulator 
4. Type the command ```flutter run``` in the terminal and wait until all dependencies are built and the build file is made
5. Voila! The app is ready

# Features that our App Provides
* User authentication (via Firebase Authentication)
* Image upload (via Firebase Cloud Storage)
* Expense tracking among group (using Firebase Firestore)
* Inviting other users to group
* Filtering out members that expense does not apply to 
* Paying back an individual user using PayPal (using PayPal REST API)
* Changing user credentials

# Contributors
* Frédéric Wojcikowski ([GitHub](https://github.com/oFrederic))
* Hiroki Otani ([GitHub](https://github.com/HirokiOtani))
* Keizo Hamaguchi ([GitHub](https://github.com/GuchiAtWork))
* Nahoko Toyota ([GitHub](https://github.com/tNahoko))
