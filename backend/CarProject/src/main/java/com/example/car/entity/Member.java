package com.example.car.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "member")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long mId;

    @Column(nullable = false, unique = true, length = 100)
    private String username;

    @Column(nullable = false, length = 300)  // 비밀번호 암호화 대비 넉넉하게
    private String password;

    @Column(length = 100)
    private String name;

    @Column(length = 300)  // 이메일은 길어질 수 있어서 확장
    private String email;

    @Column(length = 13)
    private String phone;

    @Column(length = 50)
    private String role;  // "user", "admin"
}

