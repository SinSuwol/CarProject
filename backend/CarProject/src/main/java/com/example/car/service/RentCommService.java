package com.example.car.service;

import com.example.car.dto.RentCommDto;
import com.example.car.entity.Member;
import com.example.car.entity.RentComm;
import com.example.car.repository.MemberRepository;
import com.example.car.repository.RentCommRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RentCommService {

    private final RentCommRepository rentCommRepository;
    private final MemberRepository memberRepository;

    public RentCommDto create(String username, RentCommDto dto) {
        Member member = memberRepository.findByUsername(username).orElseThrow();
        RentComm entity = RentComm.builder()
                .member(member)
                .rtTitle(dto.getRtTitle())
                .rtContent(dto.getRtContent())
                .rtRegdate(LocalDateTime.now())
                .build();
        return toDto(rentCommRepository.save(entity));
    }

    public List<RentCommDto> getAllByUsername(String username) {
        return rentCommRepository.findAllByMember_UsernameOrderByRtRegdateDesc(username)
                .stream().map(this::toDto).collect(Collectors.toList());
    }

    public RentCommDto update(Long id, String newTitle, String newContent) {
        RentComm rent = rentCommRepository.findById(id).orElseThrow();
        rent.setRtTitle(newTitle);
        rent.setRtContent(newContent);
        rent.setRtModdate(LocalDateTime.now());
        return toDto(rentCommRepository.save(rent));
    }

    public void delete(Long id) {
        rentCommRepository.deleteById(id);
    }

    public RentCommDto getById(Long id) {
        return rentCommRepository.findById(id)
                .map(this::toDto)
                .orElseThrow(() -> new RuntimeException("상담 내역이 없습니다."));
    }

    private RentCommDto toDto(RentComm r) {
        return RentCommDto.builder()
                .rtId(r.getRtId())
                .username(r.getMember().getUsername())
                .rtTitle(r.getRtTitle())
                .rtContent(r.getRtContent())
                .rtRegdate(r.getRtRegdate())
                .rtModdate(r.getRtModdate())
                .build();
    }
}