//
//  BleMessageAttributes.swift
//  xgo
//
//  Created by 袁文麟 on 2021/8/25.
//

import Foundation


//通讯协议
public let BLE_WORD_BEGIN:[UInt8] = [0x55, 0x00];
public let BLE_ORDER_WRITE:UInt8 = 0x00;
public let BLE_ORDER_READ:UInt8 = 0x02;
public let BLE_ORDER_WRITE_RESPOND:UInt8 = 0x01;
public let BLE_WRITE_RESPOND:UInt8 = 0x11;
public let BLE_READ_READBACK:UInt8 = 0x12;
public let BLE_WORD_END:[UInt8] = [0x00,0xAA];
