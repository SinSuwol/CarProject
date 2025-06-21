package com.example.car.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "live_comm")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class LiveComm {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
                    generator = "lc_seq")
    @SequenceGenerator(name = "lc_seq", sequenceName = "LIVE_COMM_SEQ",
                       allocationSize = 1)
    @Column(name = "lv_id")
    private Long lvId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id", nullable = true)   // 테스트용 null 허용
    private Member sender;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id", nullable = true)
    private Member receiver;

    @Column(length = 3000)
    private String content;
    
    //컬럼 추가(읽지 않은 상담 개수)
    @Column(name = "read", nullable = false)
    private Integer read = 0;
    
    private LocalDateTime timestamp;
    private String roomId;
}
