package com.example.capstone.repository;

import com.example.capstone.model.Complaints;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ComplaintsRepository extends JpaRepository<Complaints ,String> {
    @Override
    Optional<Complaints> findById(String s);
}
