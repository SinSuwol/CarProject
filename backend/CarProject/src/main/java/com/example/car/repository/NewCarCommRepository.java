package com.example.car.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.car.entity.NewCarComm;

public interface NewCarCommRepository extends JpaRepository<NewCarComm, Long> {
    List<NewCarComm> findAllByMember_UsernameOrderByNcRegdateDesc(String username);
}
