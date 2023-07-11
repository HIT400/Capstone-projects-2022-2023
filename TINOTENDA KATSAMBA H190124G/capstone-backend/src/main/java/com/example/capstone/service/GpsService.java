package com.example.capstone.service;

import com.example.capstone.model.Driver;
import com.example.capstone.model.Gps;
import com.example.capstone.repository.GpsRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;
@Service
@RequiredArgsConstructor
@Transactional
public class GpsService {
    private final GpsRepository gpsRepository;

    // save gps coordinates
    public Gps saveGps(Gps gps){
        return gpsRepository.save(gps);
    }
    //find gps coordinates
    public Optional<Gps> findById(String id){
        return gpsRepository.findById(id);
    }

}
