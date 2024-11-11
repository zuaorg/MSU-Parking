//
//  ContentView.swift
//  Login Page
//
//  Created by Reshmi Rampa on 10/22/24.
//

import SwiftUI

enum Screen {
    case login, signup, welcome
}

enum UserRole: String, CaseIterable {
    case student = "Student"
    case administrator = "Administrator"
    case parkingOfficer = "Parking Officer"
}

struct ContentView: View {
    @State private var currentScreen: Screen = .login
    @State private var storedUsername: String? = nil
    @State private var storedPassword: String? = nil
    @State private var loggedInUser: String = ""
    
    var body: some View {
        ZStack {
            // Background image with reduced opacity
            Image("parking")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.15)
            
            // Content overlay
            VStack(spacing: 20) {
                Text("MSU PARKING")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.6)) // Light red
                    .shadow(radius: 5)
                
                Spacer()
                
                if currentScreen == .login {
                    LoginScreen(
                        storedUsername: $storedUsername,
                        storedPassword: $storedPassword,
                        currentScreen: $currentScreen,
                        loggedInUser: $loggedInUser
                    )
                } else if currentScreen == .signup {
                    SignUpScreen(
                        storedUsername: $storedUsername,
                        storedPassword: $storedPassword,
                        currentScreen: $currentScreen
                    )
                } else if currentScreen == .welcome {
                    WelcomeScreen(user: loggedInUser)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

struct LoginScreen: View {
    @Binding var storedUsername: String?
    @Binding var storedPassword: String?
    @Binding var currentScreen: Screen
    @Binding var loggedInUser: String
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var selectedRole: UserRole = .student

    var body: some View {
        VStack(spacing: 12) {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.6))
            
            Picker("Role", selection: $selectedRole) {
                ForEach(UserRole.allCases, id: \.self) { role in
                    Text(role.rawValue).tag(role)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color(red: 0.8, green: 0.8, blue: 0.8))
            .cornerRadius(10)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(.black)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(.black)
            
            Button("Login") {
                if storedUsername == nil {
                    alertMessage = "You are not registered with us. Please sign up first."
                    showAlert = true
                } else if username == storedUsername && password == storedPassword {
                    loggedInUser = username
                    currentScreen = .welcome
                } else {
                    alertMessage = "Incorrect username or password. Please try again."
                    showAlert = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(red: 1.0, green: 0.6, blue: 0.6))
            .foregroundColor(.black)
            .cornerRadius(8)
            .disabled(username.isEmpty || password.isEmpty || storedUsername == nil)
            
            Button("Forgot Password") {
                if storedUsername != nil {
                    alertMessage = "Your password has been reset to 'password123'."
                    storedPassword = "password123"
                } else {
                    alertMessage = "You are not registered. Please sign up first."
                }
                showAlert = true
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.3))
            .foregroundColor(.black)
            .cornerRadius(8)
            
            Button("Sign Up") {
                currentScreen = .signup
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.35))
            .foregroundColor(.black)
            .cornerRadius(8)
        }
        .padding()
        .frame(width: 300)
        .background(Color.gray.opacity(0.20))
        .cornerRadius(20)
        
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notice"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct SignUpScreen: View {
    @Binding var storedUsername: String?
    @Binding var storedPassword: String?
    @Binding var currentScreen: Screen
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var selectedRole: UserRole = .student

    var body: some View {
        VStack(spacing: 12) {
            Text("Sign Up")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.6))
            
            Picker("Role", selection: $selectedRole) {
                ForEach(UserRole.allCases, id: \.self) { role in
                    Text(role.rawValue).tag(role)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(10)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.black)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.black)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.black)
            
            Button("Sign Up") {
                if storedUsername == username {
                    showError = true
                } else if !username.isEmpty && password == confirmPassword && !password.isEmpty {
                    storedUsername = username
                    storedPassword = password
                    currentScreen = .login
                } else {
                    showError = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(red: 3.5, green: 0.8, blue: 0.8))
            .foregroundColor(.black)
            .cornerRadius(8)
            
            Button("Clear Input") {
                username = ""
                password = ""
                confirmPassword = ""
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.3))
            .foregroundColor(.black)
            .cornerRadius(8)
            
            Button("Go to Login Page") {
                currentScreen = .login
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(red: 3.5, green: 0.8, blue: 0.8))
            .foregroundColor(.black)
            .cornerRadius(8)
            
            if showError {
                Text("Error: Ensure fields are filled, passwords match, or user already registered.")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

struct WelcomeScreen: View {
    var user: String
    
    var body: some View {
        VStack {
            Text("Welcome, \(user)!")
                .font(.largeTitle)
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.6))
            
            Text("You've successfully logged in.")
                .font(.title2)
        }
    }
}

