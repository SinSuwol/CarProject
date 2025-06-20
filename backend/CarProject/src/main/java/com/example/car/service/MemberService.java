package com.example.car.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.car.dto.UserDto;
import com.example.car.entity.Member;
import com.example.car.repository.MemberRepository;

import lombok.RequiredArgsConstructor;

import jakarta.annotation.PostConstruct;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @PostConstruct
    public void createAdminIfNotExist() {
        if (!memberRepository.existsByUsername("admin")) {
            Member admin = Member.builder()
                    .username("admin")
                    .password(encoder.encode("1234"))
                    .name("관리자")
                    .email("admin@example.com")
                    .phone("010-0000-0000")
                    .role("ADMIN")
                    .build();
            memberRepository.save(admin);
            System.out.println("✅ 관리자 계정 자동 생성됨");
        }
    }

    public void register(UserDto dto) {
        Member member = Member.builder()
                .username(dto.getUsername())
                .password(encoder.encode(dto.getPassword()))
                .name(dto.getName())
                .email(dto.getEmail())
                .phone(dto.getPhone())
                .role("USER") // 권한은 항상 대문자로 저장 권장
                .build();
        memberRepository.save(member);
    }

    public Member login(String username, String password) {
        return memberRepository.findByUsername(username)
                .filter(m -> encoder.matches(password, m.getPassword()))
                .orElse(null);
    }
}
