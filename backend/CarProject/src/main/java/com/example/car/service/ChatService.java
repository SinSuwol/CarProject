package com.example.car.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import com.example.car.dto.MessageDto;
import com.example.car.entity.LiveComm;
import com.example.car.entity.Member;
import com.example.car.repository.ChatRepository;
import com.example.car.repository.LiveCommRepository;
import com.example.car.repository.MemberRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final MemberRepository memberRepository;
    private final LiveCommRepository liveCommRepository;
    private final ChatRepository chatRepository;
    
    public MessageDto handleMessage(MessageDto dto) {
        Member sender = memberRepository.findByUsername(dto.getSender()).orElse(null);
        Member receiver = memberRepository.findByUsername("admin").orElse(null);

        if (sender == null || receiver == null) return null;

        liveCommRepository.save(LiveComm.builder()
                .sender(sender)
                .receiver(receiver)
                .content(dto.getMessage())
                .timestamp(LocalDateTime.now())
                .roomId(dto.getRoomId())
                .build());

        dto.setTimestamp(LocalDateTime.now().toString());
        return dto;
    }
    
    public int getUnreadMessageCount() {
        // 미확인 메시지 수 조회 예시 (DB에서 읽지 않은 메시지 개수 카운트)
        return chatRepository.countByReadFalse();
    }
}
