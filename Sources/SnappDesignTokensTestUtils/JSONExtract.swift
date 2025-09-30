//
//  JSONExtract.swift
//
//  Created by Oleksii Kolomiiets on 26.02.2025.
//

import Foundation
import os.log

/// A class for securely reading and extracting data from JSON files
public final class JSONExtract {
    // Create a dedicated logger for this class
    private let logger = Logger(subsystem: "com.SnappDesignTokens.\(#file)", category: "JSONExtract")

    // File manager for file operations
    private let fileManager = FileManager.default

    // Initialize with default settings
    public init() {
        logger.debug("JSONExtract initialized")
    }

    /// Reads a JSON file and returns its contents as a string
    /// - Parameter filePath: Path to the JSON file
    /// - Returns: JSON content as a string or nil if reading failed
    public func readJSONFile(at filePath: String) -> String? {
        logger.info("Reading JSON file at: \(filePath)")

        do {
            // Check if file exists
            guard fileManager.fileExists(atPath: filePath) else {
                logger.error("File does not exist at path: \(filePath)")
                return nil
            }

            // Read file content
            let fileURL = URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)

            // Convert data to string
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                logger.error("Failed to convert file data to UTF-8 string")
                return nil
            }

            logger.info("Successfully read JSON file (\(jsonData.count) bytes)")
            return jsonString

        } catch {
            logger.error("Error reading JSON file: \(error.localizedDescription)")
            return nil
        }
    }

    /// Writes a JSON string to a file
    /// - Parameters:
    ///   - jsonString: The JSON content to write
    ///   - filePath: The path where the JSON file should be saved
    /// - Returns: Boolean indicating success or failure
    public func writeJSONFile(jsonData: Data, to fileURL: URL) -> Bool {
        logger.info("Writing JSON to file at: \(fileURL.absoluteString)")

        do {
            // Write data to file
            try jsonData.write(to: fileURL, options: [.atomic])
            logger.info("Successfully wrote JSON file (\(jsonData.count) bytes)")
            return true

        } catch {
            logger.error("Error writing JSON file: \(error.localizedDescription)")
            return false
        }
    }

    /// Extracts specific JSON values from a file
    /// - Parameters:
    ///   - filePath: Path to the JSON file
    ///   - keyPath: Array of keys to navigate the JSON structure
    /// - Returns: Extracted value as Any? or nil if extraction failed
    public func extractValue(from filePath: String, at keyPath: [String]) -> Any? {
        logger.info("Extracting value at keyPath: \(keyPath.joined(separator: "."))")
        
        // Read the JSON file
        guard let jsonString = readJSONFile(at: filePath) else {
            return nil
        }
        
        // Parse JSON string
        guard let jsonData = jsonString.data(using: .utf8) else {
            logger.error("Failed to convert JSON string to data")
            return nil
        }
        
        do {
            // Parse JSON
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // Navigate through key path
            var currentValue: Any? = jsonObject
            
            for key in keyPath {
                if let dictionary = currentValue as? [String: Any] {
                    currentValue = dictionary[key]
                } else if let array = currentValue as? [Any], let index = Int(key), index < array.count {
                    currentValue = array[index]
                } else {
                    logger.warning("Key '\(key)' not found in JSON structure")
                    return nil
                }
            }
            
            logger.info("Successfully extracted value at keyPath")
            return currentValue
            
        } catch {
            logger.error("JSON parsing error: \(error.localizedDescription)")
            return nil
        }
    }

    public func resourcesFileURL(fileName: String, filePath: String) -> URL {
        URL(fileURLWithPath: filePath)
            .deletingLastPathComponent() // Remove file name
            .appending(path: "Resources/\(fileName).json")
    }
}
