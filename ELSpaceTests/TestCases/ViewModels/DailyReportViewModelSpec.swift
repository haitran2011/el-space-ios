import Quick
import Nimble
import SwiftDate

@testable import ELSpace

class DailyReportViewModelSpec: QuickSpec {

    override func spec() {
        describe("DailyReportViewModel") {

            var sut: DailyReportViewModel!
            var formatter: DateFormatter!

            beforeEach {
                formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
            }

            afterEach {
                sut = nil
                formatter = nil
            }

            context("when initialize with 2 normal weekday reports") {
                var dateFake: Date!

                beforeEach {
                    dateFake = formatter.date(from: "2017/08/09 22:31")
                    let fakeReports: [ReportViewModelProtocol] = [
                        ReportViewModelFake(projectId: 10, date: dateFake, value: 3.0, comment: "fake_comment1", type: 0),
                        ReportViewModelFake(projectId: 11, date: dateFake, value: 5.0, comment: "fake_comment2", type: 0)
                    ]
                    let fakeProjectsDTO = [
                        ProjectDTO.fakeProjectDto(name: "fake_name1", id: 10),
                        ProjectDTO.fakeProjectDto(name: "fake_name2", id: 11)
                    ]
                    sut = DailyReportViewModel(date: dateFake, reports: fakeReports, projects: fakeProjectsDTO)
                }

                it("should have correct title") {
                    expect(sut.title).to(equal("Total: 8.0 hours"))
                }

                it("should have correct day") {
                    expect(sut.day).to(equal(DateFormatter.dayFormatter.string(from: dateFake)))
                }

                it("should have correct dayType") {
                    expect(sut.dayType).to(equal(DayType.weekday))
                }

                describe("ReportsViewModel") {
                    var reportsViewModel: [ReportDetailsViewModelProtocol]!

                    beforeEach {
                        reportsViewModel = sut.reportsViewModel
                    }

                    it("should have 2 elements") {
                        expect(reportsViewModel).to(haveCount(2))
                    }
                }
            }

            context("when initialize with weekday report with type 1") {
                var dateFake: Date!

                beforeEach {
                    dateFake = formatter.date(from: "2017/08/09 22:31")
                    let fakeReports: [ReportViewModelProtocol] = [
                        ReportViewModelFake(projectId: nil, date: dateFake, value: 8.0, comment: nil, type: 1)
                    ]
                    let fakeProjectsDTO = [
                        ProjectDTO.fakeProjectDto(name: "fake_name1", id: 10),
                        ProjectDTO.fakeProjectDto(name: "fake_name2", id: 11)
                    ]
                    sut = DailyReportViewModel(date: dateFake, reports: fakeReports, projects: fakeProjectsDTO)
                }

                it("should have correct title") {
                    expect(sut.title).to(equal("Total: 8.0 hours"))
                }

                it("should have correct dayType") {
                    expect(sut.dayType).to(equal(DayType.weekday))
                }
            }

            context("when initialize with weekday report with type 2") {
                var dateFake: Date!

                beforeEach {
                    dateFake = formatter.date(from: "2017/08/09 22:31")
                    let fakeReports: [ReportViewModelProtocol] = [
                        ReportViewModelFake(projectId: nil, date: dateFake, value: 8.0, comment: nil, type: 2)
                    ]
                    let fakeProjectsDTO = [
                        ProjectDTO.fakeProjectDto(name: "fake_name1", id: 10),
                        ProjectDTO.fakeProjectDto(name: "fake_name2", id: 11)
                    ]
                    sut = DailyReportViewModel(date: dateFake, reports: fakeReports, projects: fakeProjectsDTO)
                }

                it("should have correct title") {
                    expect(sut.title).to(equal("Unpaid vacations"))
                }

                it("should have correct dayType") {
                    expect(sut.dayType).to(equal(DayType.weekday))
                }
            }

            context("when initialize with weekday report with type 3") {
                var dateFake: Date!

                beforeEach {
                    dateFake = formatter.date(from: "2017/08/09 22:31")
                    let fakeReports: [ReportViewModelProtocol] = [
                        ReportViewModelFake(projectId: nil, date: dateFake, value: 8.0, comment: nil, type: 3)
                    ]
                    let fakeProjectsDTO = [
                        ProjectDTO.fakeProjectDto(name: "fake_name1", id: 10),
                        ProjectDTO.fakeProjectDto(name: "fake_name2", id: 11)
                    ]
                    sut = DailyReportViewModel(date: dateFake, reports: fakeReports, projects: fakeProjectsDTO)
                }

                it("should have correct title") {
                    expect(sut.title).to(equal("Sick leave"))
                }

                it("should have correct dayType") {
                    expect(sut.dayType).to(equal(DayType.weekday))
                }
            }

            context("when initialize with weekend date") {
                var dateFake: Date!

                beforeEach {
                    dateFake = formatter.date(from: "2017/08/12 22:31")
                    sut = DailyReportViewModel(date: dateFake, reports: [], projects: [])
                }

                it("should have correct title") {
                    expect(sut.title).to(equal("Weekend!"))
                }

                it("should have correct day") {
                    expect(sut.day).to(equal(DateFormatter.dayFormatter.string(from: dateFake)))
                }

                it("should have correct dayType") {
                    expect(sut.dayType).to(equal(DayType.weekend))
                }

                describe("ReportsViewModel") {
                    var reportsViewModel: [ReportDetailsViewModelProtocol]!

                    beforeEach {
                        reportsViewModel = sut.reportsViewModel
                    }

                    it("should have 2 elements") {
                        expect(reportsViewModel).to(haveCount(0))
                    }
                }
            }

            context("when initialize with comming date") {
                var dateFake: Date!

                beforeEach {
                    var date = Date() + 1.day
                    while date.isInWeekend == true {
                        date = date + 1.day // swiftlint:disable:this shorthand_operator
                    }
                    dateFake = date
                    sut = DailyReportViewModel(date: dateFake, reports: [], projects: [])
                }

                it("should have correct title") {
                    expect(sut.title).to(beNil())
                }

                it("should have correct day") {
                    expect(sut.day).to(equal(DateFormatter.dayFormatter.string(from: dateFake)))
                }

                it("should have correct dayType") {
                    expect(sut.dayType).to(equal(DayType.comming))
                }

                describe("ReportsViewModel") {
                    var reportsViewModel: [ReportDetailsViewModelProtocol]!

                    beforeEach {
                        reportsViewModel = sut.reportsViewModel
                    }

                    it("should have 2 elements") {
                        expect(reportsViewModel).to(haveCount(0))
                    }
                }
            }

            context("when initialize with previous Date and empty reports") {
                var dateFake: Date!

                beforeEach {
                    var date = Date() - 1.day
                    while date.isInWeekend == true {
                        date = date - 1.day // swiftlint:disable:this shorthand_operator
                    }
                    dateFake = date
                    sut = DailyReportViewModel(date: dateFake, reports: [], projects: [])
                }

                it("should have correct title") {
                    expect(sut.title).to(equal("Missing"))
                }

                it("should have correct day") {
                    expect(sut.day).to(equal(DateFormatter.dayFormatter.string(from: dateFake)))
                }

                it("should have correct dayType") {
                    expect(sut.dayType).to(equal(DayType.missing))
                }

                describe("ReportsViewModel") {
                    var reportsViewModel: [ReportDetailsViewModelProtocol]!

                    beforeEach {
                        reportsViewModel = sut.reportsViewModel
                    }

                    it("should have 2 elements") {
                        expect(reportsViewModel).to(haveCount(0))
                    }
                }
            }
        }
    }

}
