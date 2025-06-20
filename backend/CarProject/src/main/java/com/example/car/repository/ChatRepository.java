package com.example.car.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.car.entity.LiveComm;

public interface ChatRepository extends JpaRepository<LiveComm, Long> {
    int countByReadFalse();  // 읽지 않은 메시지 개수 조회 메서드
}
