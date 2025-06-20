package com.example.car.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.car.entity.RentComm;

public interface RentCommRepository extends JpaRepository<RentComm, Long> {
    List<RentComm> findAllByMember_UsernameOrderByRtRegdateDesc(String username);
}
