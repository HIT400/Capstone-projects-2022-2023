package com.example.capstone.repository;

import com.example.capstone.model.Records;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RecordsRepository extends JpaRepository<Records, String> {
    Optional<Records> findById(String id);
}
