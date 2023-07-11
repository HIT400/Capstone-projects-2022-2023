package com.example.capstone.controller;

import com.example.capstone.model.Busses;
import com.example.capstone.service.BussesService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("busses")

@CrossOrigin(origins = "*")
public class BussesController {
    private final BussesService bussesService;

    //save new bus
    @PostMapping("save")
    public ResponseEntity<Busses> saveBusses(@RequestBody Busses busses){
        return new ResponseEntity<>(bussesService.saveBusses(busses), HttpStatus.CREATED);
    }

    //list all buses
    @GetMapping("all-busses")
    public ResponseEntity<List<Busses>> allBusses(){
        return new ResponseEntity<>(bussesService.listAllBusses(),HttpStatus.OK);
    }
    //delete bus
    @DeleteMapping("delete-bus")
    public ResponseEntity<String> deleteById(@PathVariable String id){
        return new ResponseEntity<>(bussesService.deleteById(id),HttpStatus.OK);
    }
}
