package com.example.capstone.repository;

import com.example.capstone.model.Gps;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GpsRepository extends JpaRepository<Gps, String> {
    @Override
    Optional<Gps> findById(String s);
}
