package com.example.car.controller;

import com.example.car.dto.MessageDto;
import com.example.car.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin("*")
@Controller
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate simpMessagingTemplate;

    // ✅ WebSocket 메시지 수신 처리
    @MessageMapping("/chat.send/{roomId}")
    public void send(@DestinationVariable("roomId") String roomId,
                     @Payload MessageDto dto) {
        dto.setRoomId(roomId);
        MessageDto processed = chatService.handleMessage(dto);
        simpMessagingTemplate.convertAndSend("/topic/room/" + roomId, processed);
    }


}
