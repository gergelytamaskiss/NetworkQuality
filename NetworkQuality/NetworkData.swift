//
//  NetworkData.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 02. 08..
//

import Foundation

struct NetworkData: Codable {
    
    let baseRtt: Double
    let dlFlows, dlThroughput: Int32
    let endDate: Date?
//    let ilH2ReqResp, ilTCPHandshake443, ilTLSHandshake: [Int]
    let interfaceName: String
//    let ludForeignH2ReqResp, ludForeignTCPHandshake443, ludForeignTLSHandshake, ludSelfH2ReqResp: [Int]
    let osVersion: String
    let responsiveness, dlResponsiveness, ulResponsiveness: Int32?
    let startDate: Date
    let ulFlows, ulThroughput: Int32
    
    enum CodingKeys: String, CodingKey {
        case baseRtt = "base_rtt"
        case dlFlows = "dl_flows"
        case dlThroughput = "dl_throughput"
        case endDate = "end_date"
//        case ilH2ReqResp = "il_h2_req_resp"
//        case ilTCPHandshake443 = "il_tcp_handshake_443"
//        case ilTLSHandshake = "il_tls_handshake"
        case interfaceName = "interface_name"
//        case ludForeignH2ReqResp = "lud_foreign_h2_req_resp"
//        case ludForeignTCPHandshake443 = "lud_foreign_tcp_handshake_443"
//        case ludForeignTLSHandshake = "lud_foreign_tls_handshake"
//        case ludSelfH2ReqResp = "lud_self_h2_req_resp"
        case osVersion = "os_version"
        case responsiveness
        case dlResponsiveness = "dl_responsiveness"
        case ulResponsiveness = "ul_responsiveness"
        case startDate = "start_date"
        case ulFlows = "ul_flows"
        case ulThroughput = "ul_throughput"
    }
}
