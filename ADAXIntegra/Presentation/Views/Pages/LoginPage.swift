//
//  LoginPage.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 22/09/26.
//

import SwiftUI

// ViewModel, guarda los datos y la lógica del login
struct LoginPage: View {
  @StateObject var viewModel: LoginViewModel

// Opens the password flow recovery
  @State private var showForgotPassword = false

  var body: some View {
    // Permite hacer scroll si la pantalla es pequeña
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {

        // Logo centrado
        Image("adaxFairy")
          .resizable()
          .scaledToFit()
          .frame(height: 150)
          .frame(maxWidth: .infinity)
          .padding(.top, 48)
          .padding(.bottom, 40)

        //Encabezado alineado hacia la izquierda
        VStack(alignment: .leading, spacing: 2) {
          Text("Bienvenida a")
            .font(.system(size: 34))
            .foregroundColor(.black)

          Text("ADAX INTEGRA")
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(Color("PrimaryAdax"))

          Text("Accede a tu cuenta para continuar")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color("SecondaryAdax"))
            .padding(.top, 6)
        }
        .padding(.bottom, 32)

        // Campos para ingresar correo y contraseña
        VStack(spacing: 20) {
          IconTextField(
            title: "Correo electrónico",
            placeholder: "tu@correo.com",
            systemIcon: "envelope",
            keyboard: .emailAddress,
            text: $viewModel.email
          )

          IconTextField(
            title: "Contraseña",
            placeholder: "**************",
            systemIcon: "lock",
            isSecure: true,
            text: $viewModel.password
          )
        }

        // Muestra un mensaje si ocurre un error
        Text(viewModel.error ?? " ")
          .font(.footnote)
          .foregroundColor(.red)
          .frame(maxWidth: .infinity, alignment: .center)
          .frame(height: 56)

        // Botones para iniciar sesión o registrarse
        HStack(spacing: 32) {
          PrimaryButton(
            title: viewModel.isLoading ? "Cargando..." : "Iniciar Sesión",
            isDisabled: viewModel.isLoading
          ) {
            viewModel.login()
          }

          SecondaryButton(title: "Registrarse", isDisabled: false) {
            // Nota: Falta agregar la pantalla de registro
          }
        }
          // Botton para recuperar contraseña
          Button {
            showForgotPassword = true
          } label: {
            Text("¿Olvidaste tu contraseña?")
                .font(.system(size: 16))
                .foregroundColor(Color("SecondaryAdax"))
          }
          
        .frame(maxWidth: .infinity)
        .padding(.top, 14)
      }
      .padding(.horizontal, 28)
    }
    // Oculta el teclado cuando se hace scroll
    .scrollDismissesKeyboard(.interactively)
    // Color de fondo de la pantalla
    .background(Color("Background").ignoresSafeArea())
    // The recovery flow opens over the login with its own navigation
    .fullScreenCover(isPresented: $showForgotPassword) {
        NavigationStack {
            ForgotPasswordPage()
        }
    }
  }
}
// Permite visualizar la pantalla desde Xcode
#Preview {
  LoginPage(viewModel: LoginViewModel(repository: RemoteAuthRepository()))
}
