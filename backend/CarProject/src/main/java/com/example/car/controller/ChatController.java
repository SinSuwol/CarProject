package com.example.car.controller;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.example.car.dto.MessageDto;
import com.example.car.service.ChatService;

import lombok.RequiredArgsConstructor;


@CrossOrigin("*")
@Controller
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    //  SEND : /chat/chat.send/{roomId}
    //  SUB  : /topic/room/{roomId}
    @MessageMapping("/chat.send/{roomId}")
    @SendTo("/topic/room/{roomId}")
    public MessageDto send(@DestinationVariable("roomId") String roomId,
                           @Payload MessageDto dto) {          // 🟢
        dto.setRoomId(roomId);
        return chatService.handleMessage(dto);
    }
}

