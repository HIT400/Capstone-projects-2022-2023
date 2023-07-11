package com.example.capstone.controller;

import com.example.capstone.model.Complaints;
import com.example.capstone.service.ComplaintsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/complaints")
@CrossOrigin(origins = "*")
public class ComplaintsController {
    private final ComplaintsService complaintsService;
    //save complaints
    @PostMapping("/save")
    public ResponseEntity<Complaints> saveComplaints(@RequestBody Complaints complaints){
        return new ResponseEntity<>(complaintsService.saveComplaints(complaints), HttpStatus.CREATED);
    }
    //get all complaints
    @GetMapping("/all-complaints")
    public ResponseEntity<List<Complaints>> allComplaints(){
        return new ResponseEntity<>(complaintsService.listAllComplaints(),HttpStatus.OK);
     }
     //delete complaints
    @DeleteMapping("delete-by-id/{id}")
    public ResponseEntity<String> deleteById(@RequestBody String id){
        return new ResponseEntity<>(complaintsService.deleteById(id),HttpStatus.OK);
    }


}
