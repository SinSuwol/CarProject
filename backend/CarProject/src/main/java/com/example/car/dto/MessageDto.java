package com.example.car.dto;

import lombok.Data;

@Data
public class MessageDto {
    private String roomId;     // 채팅방 ID
    private String sender;     // 보낸 사람 ID or 닉네임
    private String message;    // 메시지 본문
    private String timestamp;  // (선택) 보낸 시간
}