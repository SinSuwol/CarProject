package com.example.car.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        if (sender == null) {
            sender = memberRepository.save(Member.builder()
                    .username(dto.getSender())
                    .password("tmp")
                    .role("USER")
                    .build());
        }

        if (receiver == null) {
            receiver = memberRepository.save(Member.builder()
                    .username("admin")
                    .password("tmp")
                    .role("ADMIN")
                    .build());
        }

        LiveComm chat = liveCommRepository.save(LiveComm.builder()
                .sender(sender)
                .receiver(receiver)
                .content(dto.getMessage())
                .timestamp(LocalDateTime.now())
                .roomId(dto.getRoomId())
                .read(0)  // ✅ 이 줄 추가!
                .build());


        // ✅ sender 값 제대로 설정
        dto.setSender(sender.getUsername());
        dto.setTimestamp(chat.getTimestamp().toString());
        return dto;
    }

    // 미확인 메시지 수
    public int getUnreadMessageCount() {
        return chatRepository.countByReadFalse();
    }

    // 최근 24시간 내 대화한 roomId만 반환 (중복 제거)
    public List<String> getRecentRoomIds() {
        LocalDateTime cut = LocalDateTime.now().minusDays(1);
        return liveCommRepository.findDistinctRoomIdsLast24h(cut);
    }


    public List<String> getRecentChatRoomIds() {
        return getRecentRoomIds(); // ✅ 정상적으로 자기 메서드 호출
    }
    
    
    public List<String> getRecentRoomIdsSorted() {
        LocalDateTime cutoff = LocalDateTime.now().minusHours(24);
        return liveCommRepository.findRecentRoomIdsSorted(cutoff);
    }

    public Map<String, Integer> getUnreadMessageCounts() {
        List<Object[]> results = liveCommRepository.countUnreadMessagesByRoom(); // [roomId, count]
        Map<String, Integer> map = new HashMap<>();
        for (Object[] row : results) {
            map.put((String) row[0], ((Long) row[1]).intValue());
        }
        return map;
    }

   




}
