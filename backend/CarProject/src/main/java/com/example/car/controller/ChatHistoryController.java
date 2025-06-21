package com.example.car.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.example.car.dto.MessageDto;
import com.example.car.repository.LiveCommRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class ChatHistoryController {

    private final LiveCommRepository liveRepo;

    /** GET /chat/history/{roomId}  ➜ 최근 100건 */
    @GetMapping("/chat/history/{roomId}")
    public List<MessageDto> history(@PathVariable("roomId")String roomId) {
        return liveRepo.findTop100ByRoomIdOrderByTimestampAsc(roomId)   // JPA 메서드
                .stream()
                .map(lc -> {
                    MessageDto d = new MessageDto();
                    d.setRoomId(roomId);
                    d.setSender(lc.getSender() != null ?
                                 lc.getSender().getUsername() : "system");
                    d.setMessage(lc.getContent());
                    d.setTimestamp(lc.getTimestamp().toString());
                    return d;
                })
                .toList();
    }
}
