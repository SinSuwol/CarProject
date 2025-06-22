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
                .role("USER")
                .build();
        memberRepository.save(member);
    }

    public Member login(String username, String password) {
        return memberRepository.findByUsername(username)
                .filter(m -> encoder.matches(password, m.getPassword()))
                .orElse(null);
    }

    public boolean isUsernameTaken(String username) {
        return memberRepository.findByUsername(username).isPresent();
    }

    // ✅ 마이페이지용 함수 구현 추가
    public Member findByUsername(String username) {
        return memberRepository.findByUsername(username).orElse(null);
    }

    public void updateMemberInfo(String username, String email, String phone, String password) {
        Member member = memberRepository.findByUsername(username).orElseThrow();

        if (email != null) member.setEmail(email);
        if (phone != null) member.setPhone(phone);
        if (password != null && !password.isEmpty()) {
            member.setPassword(encoder.encode(password));
        }

        memberRepository.save(member);
    }
}
