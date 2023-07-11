package com.example.capstone.service;

import com.example.capstone.model.Complaints;
import com.example.capstone.repository.ComplaintsRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ComplaintsService {
    private final ComplaintsRepository complaintsRepository;

    //save complaints
    public Complaints saveComplaints(Complaints complaints){
        return complaintsRepository.save(complaints);
    }

    public List<Complaints> listAllComplaints() {
        return complaintsRepository.findAll();
    }

    //delete by id
    public String deleteById(String id) {
        complaintsRepository.deleteById(id);
        return """
                complaint with id %s has been deleted succesfully""".formatted(id);
    }
}
