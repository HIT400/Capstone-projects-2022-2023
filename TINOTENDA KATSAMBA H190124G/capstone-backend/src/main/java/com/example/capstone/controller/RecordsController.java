package com.example.capstone.controller;

import com.example.capstone.model.Records;
import com.example.capstone.service.RecordsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/coordinate")
public class RecordsController {
    private final RecordsService recordsService;

    //find by id
    @GetMapping("/get-coordinates/{id}")
    public ResponseEntity<Records> findById(@PathVariable("id")String recordsId){
        return new ResponseEntity<>(recordsService.findById(recordsId), HttpStatus.OK);
    }
    //list all coordinates
    @GetMapping("/all-coordinates")
    public ResponseEntity<List<Records>> allRecords(){
        return new ResponseEntity<>(recordsService.listAllRecords(), HttpStatus.OK);
    }
}
