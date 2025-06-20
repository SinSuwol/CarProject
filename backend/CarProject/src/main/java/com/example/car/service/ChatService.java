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

        Member sender = memberRepository.findByUsername(dto.getSender())
                                        .orElse(null);
        Member receiver = memberRepository.findByUsername("admin")
                                          .orElse(null);

        // 테스트용 : 회원이 없으면 dummy 행 삽입
        if (sender == null) {
            sender = memberRepository.save(
                Member.builder()
                      .username(dto.getSender())
                      .password("tmp")  // 암호화 X, 테스트용
                      .role("USER")
                      .build());
        }
        if (receiver == null) {
            receiver = memberRepository.save(
                Member.builder()
                      .username("admin")
                      .password("tmp")
                      .role("ADMIN")
                      .build());
        }

        LiveComm chat = liveCommRepository.save(
            LiveComm.builder()
                .sender(sender)
                .receiver(receiver)
                .content(dto.getMessage())
                .timestamp(LocalDateTime.now())
                .roomId(dto.getRoomId())
                .build());

        dto.setTimestamp(chat.getTimestamp().toString());
        return dto;                          // 절대 null 반환하지 않기
    }

    //읽지 않은 상담내역 개수
	public int getUnreadMessageCount() {
		return chatRepository.countByReadFalse();
	}

}
