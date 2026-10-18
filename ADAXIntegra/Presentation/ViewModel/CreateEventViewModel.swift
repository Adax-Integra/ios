//
//  CreateEventViewModel.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import Combine
import Foundation

@MainActor
final class CreateEventViewModel: ObservableObject {
  @Published var title = ""
  @Published var startDate: Date?
  @Published var endDate: Date?
  @Published var startTime: Date?
  @Published var endTime: Date?
  @Published var modality: String? = "Presencial"
  @Published var location = ""
  @Published var link = ""
  @Published var countryCode: String? = "+52"
  @Published var phone = ""
  @Published var description = ""
  @Published var notes = ""
  // Picture the user picked, it stays nil until the user chooses one
  @Published var image: DocumentFile?
  // Catalog for the phone code dropdown
  @Published var countries: [Country] = []
  @Published var eventSaved = false
  // True when the event was created but its picture could not be uploaded
  @Published var imageUploadFailed = false
  // Separate from a loading state: saving only changes the button, it does not dim the screen
  @Published var isSaving = false
  @Published var errorMessage: String?
  // Turned on by the "Guardar evento" tap, so empty fields are not marked before the user tries to save
  @Published var showErrors = false

  // nil when creating, the id of the event when editing
  private let eventId: String?
  private let createEventUseCase: CreateEventUseCaseProtocol
  private let updateEventUseCase: UpdateEventUseCaseProtocol
  private let uploadEventImageUseCase: UploadEventImageUseCaseProtocol
  private let countryRepository: CountryRepository

  private static let isoFormatter = ISO8601DateFormatter()

  init(
    event: EventListItem? = nil,
    createEventUseCase: CreateEventUseCaseProtocol? = nil,
    updateEventUseCase: UpdateEventUseCaseProtocol? = nil,
    uploadEventImageUseCase: UploadEventImageUseCaseProtocol? = nil,
    countryRepository: CountryRepository? = nil
  ) {
    self.eventId = event?.id
    self.createEventUseCase =
      createEventUseCase ?? CreateEventUseCase(dataRepository: RemoteEventRepository())
    self.updateEventUseCase =
      updateEventUseCase ?? UpdateEventUseCase(dataRepository: RemoteEventRepository())
    self.uploadEventImageUseCase =
      uploadEventImageUseCase ?? UploadEventImageUseCase(dataRepository: RemoteEventRepository())
    self.countryRepository = countryRepository ?? RemoteCountryRepository()

    if let event {
      fill(with: event)
    }
  }

  var isEditing: Bool {
    eventId != nil
  }

  // If the catalog fails, the dropdown keeps "+52"
  var countryCodes: [String] {
    let codes = Country.dialCodes(in: countries)
    return codes.isEmpty ? ["+52"] : codes
  }

  var titleError: String? { requiredError(title) }
  var descriptionError: String? { requiredError(description) }
  var startDateError: String? { requiredError(startDate) }
  var startTimeError: String? { requiredError(startTime) }

  var locationError: String? {
    modality == "Presencial" ? requiredError(location) : nil
  }

  // Same rules as the backend validator
  var endDateError: String? {
    if let error = requiredError(endDate) {
      return error
    }
    guard let startDate, let endDate else {
      return nil
    }
    let calendar = Calendar.current
    if calendar.startOfDay(for: endDate) < calendar.startOfDay(for: startDate) {
      return "La fecha de fin no puede ser anterior a la de inicio."
    }
    return nil
  }

  var endTimeError: String? {
    if let error = requiredError(endTime) {
      return error
    }
    guard endDateError == nil, let startsAt, let endsAt else {
      return nil
    }
    if endsAt <= startsAt {
      return "La fecha y hora de fin deben ser posteriores al inicio."
    }
    // An event that already ended would not appear in the list after saving
    if endsAt <= Date() {
      return "La fecha y hora de fin ya pasaron."
    }
    return nil
  }

  var linkError: String? {
    if link.isEmpty {
      return nil
    }
    if link.range(of: #"^https?://"#, options: [.regularExpression, .caseInsensitive]) == nil {
      return "El link debe empezar con http:// o https://"
    }
    return nil
  }

  var phoneError: String? {
    PhoneField.validationError(for: phone)
  }

  // The backend only requires the place for in person events
  var isFormValid: Bool {
    !title.isEmpty && !description.isEmpty
      && startDate != nil && startTime != nil && endDate != nil && endTime != nil
      && modality != nil && (modality != "Presencial" || !location.isEmpty)
      && endDateError == nil && endTimeError == nil && linkError == nil && phoneError == nil
  }

  func loadCountries() async {
    countries = (try? await countryRepository.getCountries()) ?? []
  }

  // Called by the view when the user picks a picture rejects pictures over 5 MB.
  func selectImage(_ file: DocumentFile) {
    if file.isTooLarge {
      errorMessage = "La imagen no debe pesar más de 5 MB."
      return
    }
    image = file
  }

  func saveEvent() async {
    // The button is always enabled, so the first tap reveals the missing fields
    showErrors = true
    guard isFormValid, let newEvent = makeEvent() else { return }
    isSaving = true
    errorMessage = nil

    do {
      // Editing sends the whole event with PUT, so fields left empty are cleared in the backend
      let event: Event
      if let eventId {
        event = try await updateEventUseCase.updateEvent(eventId: eventId, event: newEvent)
      } else {
        event = try await createEventUseCase.createEvent(newEvent)
      }

      // The event already exists, so a failed picture is only a warning
      if let image {
        do {
          _ = try await uploadEventImageUseCase.uploadEventImage(
            eventId: event.eventId, image: image)
        } catch {
          imageUploadFailed = true
        }
      }
      eventSaved = true
    } catch {
      handle(error)
    }

    isSaving = false
  }

  // The same date fills the day and the hour pickers, each one only uses its part
  private func fill(with event: EventListItem) {
    title = event.title
    startDate = event.startDate
    startTime = event.startDate
    endDate = event.endDate
    endTime = event.endDate
    modality = event.modality ?? "Presencial"
    location = event.location ?? ""
    link = event.link ?? ""
    description = event.description ?? ""
    notes = event.notes ?? ""

    // The backend keeps the code and the number together, like "+524421234567"
    if let savedPhone = event.phone, savedPhone.count > 10 {
      countryCode = String(savedPhone.dropLast(10))
      phone = String(savedPhone.suffix(10))
    }
  }

  private func requiredError(_ value: String) -> String? {
    guard showErrors else { return nil }
    return value.isEmpty ? "Este campo es obligatorio." : nil
  }

  private func requiredError(_ value: Date?) -> String? {
    guard showErrors else { return nil }
    return value == nil ? "Este campo es obligatorio." : nil
  }

  private var startsAt: Date? { combine(startDate, startTime) }
  private var endsAt: Date? { combine(endDate, endTime) }

  // Joins the day of one picker with the hour of the other
  private func combine(_ date: Date?, _ time: Date?) -> Date? {
    guard let date, let time else { return nil }
    let calendar = Calendar.current
    let day = calendar.dateComponents([.year, .month, .day], from: date)
    let hour = calendar.dateComponents([.hour, .minute], from: time)
    return calendar.date(
      from: DateComponents(
        year: day.year, month: day.month, day: day.day, hour: hour.hour, minute: hour.minute))
  }

  // Builds the entity to send to the backend from the current form fields
  private func makeEvent() -> NewEvent? {
    guard let startsAt, let endsAt, let modality else { return nil }

    return NewEvent(
      title: title,
      startsAt: Self.isoFormatter.string(from: startsAt),
      endsAt: Self.isoFormatter.string(from: endsAt),
      modality: modality,
      location: location.isEmpty ? nil : location,
      link: link.isEmpty ? nil : link,
      phone: phone.isEmpty ? nil : dialCode + phone,
      description: description,
      notes: notes.isEmpty ? nil : notes
    )
  }

  private var dialCode: String {
    String((countryCode ?? "+52").split(separator: "-").first ?? "+52")
  }

  private func handle(_ error: Error) {
    guard case let APIError.server(statusCode, _) = error else {
      errorMessage = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    switch statusCode {
    case 400:
      errorMessage = "Revisa los datos del evento e intenta de nuevo."
    case 401:
      errorMessage = "Tu sesión expiró. Vuelve a iniciar sesión."
    // Only happens when editing: the event was disabled or deleted while it was open
    case 404:
      errorMessage = "Este evento ya no existe o fue deshabilitado."
    case 429:
      errorMessage = "Hiciste demasiados intentos. Intenta más tarde."
    default:
      errorMessage =
        isEditing
        ? "No se pudo actualizar el evento. Intenta de nuevo."
        : "No se pudo crear el evento. Intenta de nuevo."
    }
  }
}
