package com.example.car.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.car.repository.LiveCommRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class RoomListController {

    private final LiveCommRepository liveRepo;

    @GetMapping("/chat/rooms")
    public List<String> roomList() {
        LocalDateTime cut = LocalDateTime.now().minusDays(1);   // 최근 24시간 기준
        return liveRepo.findDistinctRoomIdsLast24h(cut);        // ★ 파라미터 전달
    }
}
