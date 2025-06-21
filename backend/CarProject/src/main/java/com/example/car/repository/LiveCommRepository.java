package com.example.car.repository;

import com.example.car.entity.LiveComm;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface LiveCommRepository extends JpaRepository<LiveComm, Long> {
    // 추후: 특정 채팅방 ID로 검색 등 메서드 추가 가능
	List<LiveComm> findTop100ByRoomIdOrderByTimestampAsc(String roomId);
	
	// LiveCommRepository
	@Query("""
	   select distinct lc.roomId
	   from   LiveComm lc
	   where  lc.timestamp >= :cut
	""")
	List<String> findDistinctRoomIdsLast24h(@Param("cut") LocalDateTime cut);


	@Query("SELECT lc.roomId FROM LiveComm lc " +
		       "WHERE lc.timestamp > :cut " +
		       "GROUP BY lc.roomId " +
		       "ORDER BY MAX(lc.timestamp) DESC")
		List<String> findRecentRoomIdsSorted(@Param("cut") LocalDateTime cut);
	
	@Query("SELECT lc.roomId, COUNT(lc) FROM LiveComm lc WHERE lc.read = 0 GROUP BY lc.roomId")
	List<Object[]> countUnreadMessagesByRoom();
	
	



}