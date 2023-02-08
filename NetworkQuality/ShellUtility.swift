//
//  ShellUtility.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 02. 08..
//

import Foundation
import Logging

class ShellUtility {
    
//    let logger = Logger(label: "com.gergelytamas.Ernesto.ShellUtility")
    
    func executeCommand(_ command: String) -> Data {
        
        let process = Process()
        let stdout = Pipe()
        let stderr = Pipe()
        var stdoutData = Data.init(capacity: 8192)
        var stderrData = Data.init(capacity: 8192)
        
        process.standardOutput = stdout
        process.standardError = stderr
        process.arguments = ["-c", command]
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        
        do {
            try process.run()

            // Buffer the data while running
            while process.isRunning {
                stdoutData.append(pipeToData(stdout))
                stderrData.append(pipeToData(stderr))
            }

            process.waitUntilExit()

            stdoutData.append(pipeToData(stdout))
//            logger.error("\"stderr")
        }

        catch {
            print("\(error.localizedDescription)")
//            logger.error("\(error.localizedDescription)")
        }

        return stdoutData
    }
    
    private func pipeToString(_ pipe: Pipe) -> String {
        return dataToString(pipeToData(pipe))
    }

    private func dataToString(_ data: Data) -> String {
        return String(decoding: data, as: UTF8.self)
    }

    private func pipeToData(_ pipe: Pipe) -> Data {
        return pipe.fileHandleForReading.readDataToEndOfFile()
    }
    
}
