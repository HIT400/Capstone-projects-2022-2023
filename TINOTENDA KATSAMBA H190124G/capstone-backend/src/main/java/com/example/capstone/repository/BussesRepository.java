package com.example.capstone.repository;

import com.example.capstone.model.Busses;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BussesRepository extends JpaRepository< Busses , String > {
    @Override
    Optional<Busses>findById(String s);
}
