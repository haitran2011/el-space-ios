import RxSwift

protocol DailyReportViewModelProtocol {
    var title: String? { get }
    var day: String { get }
    var dayType: DayType { get }
    var reportsViewModel: [ReportDetailsViewModelProtocol] { get }
}

class DailyReportViewModel: DailyReportViewModelProtocol {

    init(date: Date, reports: [ReportViewModelProtocol], projects: [ProjectDTO]) {
        self.date = date
        reportsViewModel = reports.map { report in
            let project = projects.first(where: { $0.id == report.projectId })
            let reportDetailsViewModel = ReportDetailsViewModel(report: report, project: project)
            return reportDetailsViewModel
        }
    }

    // MARK: - DailReportViewModelProtocol

    var title: String? {
        switch dayType {
        case .weekday: return weekdayTitle
        case .missing: return "Missing"
        case .comming: return nil
        case .weekend: return "Weekend!"
        }
    }

    var day: String {
        return dayFormatter.string(from: date)
    }

    var dayType: DayType {
        if areAnyReports {
            return .weekday
        } else if date.isInWeekend {
            return .weekend
        } else if date.isBefore(date: Date(), granularity: .day) && reportsViewModel.isEmpty {
            return .missing
        } else {
            return .comming
        }
    }

    let reportsViewModel: [ReportDetailsViewModelProtocol]

    // MARK: - Private

    private var dayValue: Double {
        return reportsViewModel.reduce(0.0) { (result, viewModel) -> Double in viewModel.value + result }
    }

    private let dayFormatter = DateFormatter.dayFormatter
    private let date: Date

    // MARK: Helpers

    private var areAnyReports: Bool {
        return reportsViewModel.isEmpty == false
    }

    private var viewModelsContainsUnpaidVacations: Bool {
        return reportsViewModel.contains(where: { viewModel -> Bool in viewModel.type == .unpaidDayOff })
    }

    private var viewModelsContainsSickLeave: Bool {
        return reportsViewModel.contains(where: { viewModel -> Bool in viewModel.type == .sickLeave })
    }

    private var weekdayTitle: String {
        if viewModelsContainsUnpaidVacations {
            return "Unpaid vacations"
        } else if viewModelsContainsSickLeave {
            return "Sick leave"
        } else {
            return "Total: \(dayValue) hours"
        }
    }

}

enum DayType {
    case weekday
    case weekend
    case missing
    case comming
}

extension DailyReportViewModelProtocol {

    var titleObservable: Observable<String?> {
        return Observable.just(title)
    }

    var dayObservable: Observable<String> {
        return Observable.just(day)
    }

    var dayTypeObservable: Observable<DayType> {
        return Observable.just(dayType)
    }

    var reportsViewModelObservable: Observable<[ReportDetailsViewModelProtocol]> {
        return Observable.just(reportsViewModel)
    }

}
