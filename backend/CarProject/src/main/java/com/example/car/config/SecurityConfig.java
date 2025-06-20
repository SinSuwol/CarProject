package com.example.car.config;

import com.example.car.filter.JwtAuthFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.*;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.*;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthFilter jwtAuthFilter;

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .formLogin(form -> form.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers(
                		
                    "/",                          // index
                    "/register", "/login", "/logout", "/reissue",  // AuthController
                    "/newcar/**",                 // 상담 게시판 (신차)
                    "/rent/**",                   // 상담 게시판 (렌트)
                    "/admin/**",				  // 관리자 매핑
                    "/ws/**", "/topic/**", "/app/**", // WebSocket 관련
                    "/css/**", "/js/**", "/images/**", // 정적 리소스 (선택)
                    "/ws/**"
                )
                .permitAll()
                .requestMatchers("/chat/rooms").hasRole("ADMIN")
                .requestMatchers("/chat/history/**").authenticated()
   
                
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
