package com.example.car.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.example.car.dto.MessageDto;
import com.example.car.service.ChatService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ChatController {
	
	@Autowired
	private ChatService chatService;


    @MessageMapping("/chat.send")
    @SendTo("/topic/room/{roomId}")
    public MessageDto sendMessage(MessageDto message) {
        return chatService.handleMessage(message);
    }
}
