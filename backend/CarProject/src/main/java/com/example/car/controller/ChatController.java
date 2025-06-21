package com.example.car.controller;

import com.example.car.dto.MessageDto;
import com.example.car.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;

@CrossOrigin("*")
@Controller
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate simpMessagingTemplate;

    // 클라이언트 → /chat/chat.send/{roomId} 로 보냄
    @MessageMapping("/chat.send/{roomId}")
    public void send(@DestinationVariable("roomId") String roomId,
                     @Payload MessageDto dto) {
        dto.setRoomId(roomId);
        MessageDto processed = chatService.handleMessage(dto);

        // 서버 → /topic/room/{roomId}로 메시지 브로드캐스트
        simpMessagingTemplate.convertAndSend("/topic/room/" + roomId, processed);
    }
}
