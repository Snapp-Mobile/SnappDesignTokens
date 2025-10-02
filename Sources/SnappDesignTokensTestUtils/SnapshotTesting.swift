//
//  SnapshotTesting.swift
//
//  Created by Volodymyr Voiko on 25.04.2025.
//

import Testing
import Foundation

private let snapshotsDirectoryPath = ".Snapshots"
private let jsonExtension = "json"

func matchSnapshot(
    _ data: Data,
    filePath: StaticString = #filePath,
    function: StaticString = #function,
) {
    let fileManager = FileManager.default

    do {
        let testDirectoryURL = URL(filePath: String(describing: filePath))
            .deletingPathExtension()
        let testSnapshotsDirectoryURL = testDirectoryURL
            .deletingLastPathComponent()
            .appendingPathComponent(snapshotsDirectoryPath)
            .appendingPathComponent(testDirectoryURL.lastPathComponent)

        let testName = String(describing: function)
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        let testSnapshotFileURL = testSnapshotsDirectoryURL
            .appending(component: testName)
            .appendingPathExtension(jsonExtension)

        if fileManager.fileExists(atPath: testSnapshotFileURL.path()) {
            let jsonString = try #require(String(data: data, encoding: .utf8))
            let existingData = try Data(contentsOf: testSnapshotFileURL)
            let existingJSONString = try #require(String(data: existingData, encoding: .utf8))
            #expect(
                existingData == data,
                """
                Recorded snapshot:
                \(jsonString)
                doesn't match expected:
                \(existingJSONString)
                """
            )
        } else {
            try fileManager.createDirectory(
                at: testSnapshotsDirectoryURL,
                withIntermediateDirectories: true
            )
            try data.write(to: testSnapshotFileURL)
            Issue.record("Snapshot doesn't exist. Created new at \(testSnapshotFileURL.path())")
        }
    } catch {
        Issue.record(error)
    }
}
