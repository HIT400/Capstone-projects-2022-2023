package com.example.capstone.controller;

import com.example.capstone.model.Driver;
import com.example.capstone.service.DriverService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("driver")
public class DriverController {
    private final DriverService driverService;

    //    Save Driver
    @PostMapping("save")
    public ResponseEntity<Driver> saveDriver(@RequestBody Driver driver){
        return new ResponseEntity<>(driverService.saveDriver(driver), HttpStatus.CREATED);
    }
//    Find Driver By Id
    @GetMapping("get-by-id/{id}")
    public ResponseEntity<Optional<Driver>> findById(@PathVariable("id") String driverId){
        return new ResponseEntity<>(driverService.findById(driverId), HttpStatus.FOUND);
    }
//    Find Driver By Email
    @GetMapping("get-by-email/{email}")
    public ResponseEntity<Optional<Driver>> findByEmail(@PathVariable String email){
        return new ResponseEntity<>(driverService.findByEmail(email), HttpStatus.FOUND);
    }
//    Delete Driver By Id
    @DeleteMapping("delete-by-id/{id}")
    public ResponseEntity<String> deleteById(@PathVariable String id){
        return new ResponseEntity<>(driverService.deleteBYId(id),HttpStatus.OK);
    }
//    Update Driver
    @PutMapping("update-by-id")
    public ResponseEntity<Driver> updateDriver(@RequestBody Driver driver){
        return new ResponseEntity<>(driverService.updateDriver(driver), HttpStatus.OK);
    }

//    Update driver using path variable
    @PutMapping("update-by-param/{id}/{email}")
    public ResponseEntity<Driver> updateByPathVariable(@PathVariable String id, @PathVariable String email){
        return new ResponseEntity<>(driverService.updateUsingParams(id, email), HttpStatus.OK);
    }
//    List All Drivers
    @GetMapping("all-drivers")
    public ResponseEntity<List<Driver>> allDrivers(){
        return new ResponseEntity<>(driverService.listAllDrivers(), HttpStatus.OK);
    }
}
