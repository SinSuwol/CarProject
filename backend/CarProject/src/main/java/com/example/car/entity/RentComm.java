package com.example.car.entity;

import java.time.LocalDateTime;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "rent_comm")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RentComm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long rtId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "m_id")
    private Member member;

    private String rtTitle;

    @Column(length = 3000)  // 🔍 본문 길이 늘림
    private String rtContent;

    @CreatedDate
    private LocalDateTime rtRegdate;
    
    @LastModifiedDate
    private LocalDateTime rtModdate;
}
