package com.example.car.service;

import com.example.car.dto.MessageDto;
import com.example.car.entity.LiveComm;
import com.example.car.entity.Member;
import com.example.car.repository.LiveCommRepository;
import com.example.car.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final MemberRepository memberRepository;
    private final LiveCommRepository liveCommRepository;

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
}
