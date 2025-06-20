package com.example.car.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    /** 1) SockJS 제거  :  withSockJS() 삭제 */
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws/chat")                   // ← 그대로
                .setAllowedOriginPatterns("*");            // CORS 허용
                // .withSockJS();  ⬅️ 삭제
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.setApplicationDestinationPrefixes("/chat"); // SEND → /chat/...
        registry.enableSimpleBroker("/topic");               // SUB  → /topic/...
    }
}
