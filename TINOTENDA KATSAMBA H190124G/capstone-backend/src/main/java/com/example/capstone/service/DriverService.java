package com.example.capstone.service;

import com.example.capstone.model.Driver;
import com.example.capstone.repository.DriverRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class DriverService {
    private final DriverRepository driverRepository;

//    Save Driver
    public Driver saveDriver(Driver driver){
        return driverRepository.save(driver);
    }
//    Find Driver By Id
    public Optional<Driver> findById(String id){
        return driverRepository.findById(id);
    }
//    Find Driver By Email
    public Optional<Driver> findByEmail(String email){
        return driverRepository.findByEmail(email);
    }
//    Delete Driver By Id
    public String deleteBYId(String id){
//        Driver driver = driverRepository.findById(id).orElseThrow(()-> new RuntimeException(
//                """
//                        Driver with id %s not found""".formatted(id)
//        ));
//
//        driverRepository.delete(driver);
        driverRepository.deleteById(id);
        return """
                Driver with id %s deleted successfully""".formatted(id);
    }
//    Update Driver
    public Driver updateDriver(Driver driver){
        Driver oldDriver = driverRepository.findById(driver.getId()).orElseThrow(()-> new RuntimeException(
               """
                       Driver with id %s not found""".formatted(driver.getId())));

        oldDriver.setEmail(driver.getEmail());
        oldDriver.setFirstname(driver.getFirstname());
        return driverRepository.save(oldDriver);
    }

    public Driver updateUsingParams(String id, String email){
        Driver oldDriver = driverRepository.findById(id).orElseThrow(()-> new RuntimeException(
                """
                        Driver with id %s not found""".formatted(id)));

        oldDriver.setEmail(email);
        return driverRepository.save(oldDriver);
    }

    public List<Driver> listAllDrivers(){
        return driverRepository.findAll();
    }
}
