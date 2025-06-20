package com.example.car.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.car.dto.UserDto;
import com.example.car.entity.Member;
import com.example.car.repository.MemberRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public void register(UserDto dto) {
        Member member = Member.builder()
                .username(dto.getUsername())
                .password(encoder.encode(dto.getPassword()))
                .name(dto.getName())
                .email(dto.getEmail())
                .phone(dto.getPhone())
                .role("user")
                .build();
        memberRepository.save(member);
    }

    public Member login(String username, String password) {
        return memberRepository.findByUsername(username)
                .filter(m -> encoder.matches(password, m.getPassword()))
                .orElse(null);
    }
}
