package com.example.capstone.service;

import com.example.capstone.model.Records;
import com.example.capstone.repository.RecordsRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
@Service
@RequiredArgsConstructor
@Transactional
public class RecordsService {
    private final RecordsRepository recordsRepository;

    //find coordinates
    public Records findById(String id){
        return recordsRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Not found"));
    }

    //list all
    public List<Records> listAllRecords(){
        return recordsRepository.findAll();
    }

}
