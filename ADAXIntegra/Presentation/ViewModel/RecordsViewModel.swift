//
//  RecordsViewModel.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import Foundation
import Combine


final class RecordsViewModel: ObservableObject {
    @Published var records: [RecordListItem] = []
    @Published var total = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var searchText = ""
    @Published var hasOpenCasesFilter: Bool?
    @Published var statusFilter: String?
    
    private var currentPage = 1
    
    private var repository: RecordListRepository
    
    init(repository: RecordListRepository = RemoteRecordListRepository()) {
        self.repository = repository
    }
    
    var canLoadMore: Bool {
        records.count < total
    }
    
    func refresh() async {
        currentPage = 1
        await load(reset: true)
    }
    
    func loadMoreIfNeeded(currentItem: RecordListItem) async {
        guard currentItem.id == records.last?.id else { return }
        guard canLoadMore, !isLoading else { return }
        currentPage += 1
        await load(reset: false)
    }
    
    private func load(reset: Bool) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await repository.listRecords(
                page: currentPage,
                search: searchText.trimmingCharacters(in: .whitespaces),
                hasOpenCases: hasOpenCasesFilter,
                status: statusFilter
            )
            guard !Task.isCancelled else { return }
            
            if reset {
                records = result.records
            } else {
                records.append(contentsOf: result.records)
            }
            total = result.total
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = "No se pudieron cargar  los expedientes."
            print("Error al cargar los expedientes", error)
        }
        
        isLoading = false
    }
}
