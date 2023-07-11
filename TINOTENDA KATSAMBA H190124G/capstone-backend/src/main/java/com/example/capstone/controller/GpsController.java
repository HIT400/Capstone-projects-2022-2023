package com.example.capstone.controller;

import com.example.capstone.model.Driver;
import com.example.capstone.model.Gps;
import com.example.capstone.service.GpsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("gps-coordinates")
public class GpsController {
    private final GpsService gpsService;

    //save gps coordinates
    @PostMapping("save")
    public ResponseEntity<Gps> saveGps(@RequestBody Gps gps) {
        return new ResponseEntity<>(gpsService.saveGps(gps), HttpStatus.OK);
    }

    //Get Location
    @GetMapping("get-location")
    public ResponseEntity<Optional<Gps>> findById(@PathVariable("id") String gpsId) {
        return new ResponseEntity<>(gpsService.findById(gpsId),HttpStatus.FOUND);
    }

}