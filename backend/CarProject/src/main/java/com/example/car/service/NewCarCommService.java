package com.example.car.service;

import com.example.car.dto.NewCarCommDto;
import com.example.car.entity.Member;
import com.example.car.entity.NewCarComm;
import com.example.car.repository.MemberRepository;
import com.example.car.repository.NewCarCommRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NewCarCommService {

    private final NewCarCommRepository newcarCommRepository;
    private final MemberRepository memberRepository;

    public NewCarCommDto create(String username, NewCarCommDto dto) {
        Member member = memberRepository.findByUsername(username).orElseThrow();
        NewCarComm entity = NewCarComm.builder()
                .member(member)
                .ncTitle(dto.getNcTitle())
                .ncContent(dto.getNcContent())
                .ncRegdate(LocalDateTime.now())
                .build();
        return toDto(newcarCommRepository.save(entity));
    }

    public List<NewCarCommDto> getAllByUsername(String username) {
        return newcarCommRepository.findAllByMember_UsernameOrderByNcRegdateDesc(username)
                .stream().map(this::toDto).collect(Collectors.toList());
    }

    public NewCarCommDto update(Long id, String newTitle, String newContent) {
        NewCarComm nc = newcarCommRepository.findById(id).orElseThrow();
        nc.setNcTitle(newTitle);
        nc.setNcContent(newContent);
        nc.setNcModdate(LocalDateTime.now());
        return toDto(newcarCommRepository.save(nc));
    }

    public void delete(Long id) {
        newcarCommRepository.deleteById(id);
    }

    public NewCarCommDto getById(Long id) {
        return newcarCommRepository.findById(id)
                .map(this::toDto)
                .orElseThrow(() -> new RuntimeException("상담 내역을 찾을 수 없습니다."));
    }
  
    //전체 신차 상담 내역 조회
    public List<NewCarCommDto> getAll() {
        List<NewCarComm> entities = newcarCommRepository.findAll();
        return entities.stream()
                .map(this::toDto)
                .toList();
    }
    
    public int countAll() {
        return (int) newcarCommRepository.count();  // 전체 개수 반환
    }
    
    private NewCarCommDto toDto(NewCarComm nc) {
        return NewCarCommDto.builder()
                .ncId(nc.getNcId())
                .username(nc.getMember().getUsername())
                .ncTitle(nc.getNcTitle())
                .ncContent(nc.getNcContent())
                .ncRegdate(nc.getNcRegdate())
                .ncModdate(nc.getNcModdate())
                .build();
    }
}