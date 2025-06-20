package com.example.car.entity;

import java.time.LocalDateTime;

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
@Table(name = "newcar_comm")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NewcarComm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long ncId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "m_id")
    private Member member;

    private String ncTitle;

    @Column(length = 3000)  // 🔍 본문 길이 늘림
    private String ncContent;

    private LocalDateTime ncRegdate;
    private LocalDateTime ncModdate;
}
