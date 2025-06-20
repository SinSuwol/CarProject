package com.example.car.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "live_comm")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LiveComm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long lvId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id")
    private Member sender;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id")
    private Member receiver;

    @Column(length = 3000)
    private String content;
    
    //컬럼 추가(읽지 않은 상담 개수)
    @Column(nullable = false)
    private boolean read;
    
    private LocalDateTime timestamp;

    private String roomId;
}
