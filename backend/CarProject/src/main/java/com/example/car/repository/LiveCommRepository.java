package com.example.car.repository;

import com.example.car.entity.LiveComm;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LiveCommRepository extends JpaRepository<LiveComm, Long> {
    // 추후: 특정 채팅방 ID로 검색 등 메서드 추가 가능
}